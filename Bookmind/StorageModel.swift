//
//  StorageModel.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/28/24.
//

import Foundation
import SwiftData

/// StorageModel configures swift data for Bookmind. A memory only
/// model must be used for previews. The app currently stores data
/// only on the phone. When we support cloud storage, one assumes
/// that will be done here, but we'll see. We do want icloud sign
/// in to be optional.
///
/// It is also proving a convenient place for persistence related
/// behavior like add(). Swift data objects crash if not saved in
/// the correct order. And it seems icloud doens't support unique
/// attributes, so we implement that ourselves by checking for
/// duplicates here. That behavior fits nicely here where we have
/// easy access to the interactor; it would be more verbose to
/// implement that in a view.
final class StorageModel: ObservableObject {
	/// The swift data model container required to fetch saved
	/// books and authors. 
	let container: ModelContainer
	/// Internal shorthand for the swift data context. Not that
	/// much shorter or better named, but maybe a little better.
	@MainActor private var interactor: ModelContext {
		container.mainContext
	}
	
	/// Create a new storage model for saved swift data.
	/// - Parameter preview: send true for the "volatile" memory only model
	/// required by swift ui previews. Send false for a model which saves
	/// data to storage that will persist across app restarts.
	init(preview: Bool = false) {
		let config = ModelConfiguration(isStoredInMemoryOnly: preview)
		do {
			try self.container = ModelContainer(for: Author.self, Work.self, Edition.self, configurations: config)
		} catch {
			fatalError("Could not create swift data storage")
		}
	}
	
	/// Save the specified book: its edition, book and authors. Convenience method
	/// that calls insert(edition:work:authors:).
	@MainActor func insert(book: Book) -> Book {
		self.insert(edition: book.edition, work: book.work, authors: book.authors)
	}
	
	/// Save the specified edition, book and authors. Do *not* insert any entities
	/// if one is already stored with the same unique identifier. Carefully set
	/// the many to many relationships between books and authors, again avoiding
	/// duplicates.
	@MainActor func insert(edition: Edition, work: Work, authors: [Author]) -> Book {
		let deDupedWork = self.insert(entity: work)
		
		for author in authors {
			let deDupedAuthor = self.insert(entity: author)
			if !deDupedWork.authors.contains(deDupedAuthor) {
				deDupedWork.authors.append(deDupedAuthor)
			}
			if !deDupedAuthor.books.contains(deDupedWork) {
				deDupedAuthor.books.append(deDupedWork)
			}
		}
		
		let deDupedEdition = self.insert(entity: edition)
		if !deDupedWork.editions.contains(deDupedEdition) {
			deDupedEdition.work = deDupedWork
		}
		
		self.save()
		return Book(edition: deDupedEdition, work: deDupedWork, authors: deDupedWork.authors)
	}
	
	/// Delete the specified entity from storage.
	@MainActor func delete<Entity>(_ entities: [Entity]) where Entity: PersistentModel {
		for entity in entities {
			self.interactor.delete(entity)
		}
	}
	
	@MainActor private func save() {
		guard self.interactor.hasChanges else { return }
		do {
			try self.interactor.save()
		} catch {
			print(error)
		}
	}
	
	/// Return true if there are saved entities matching the specified query.
	/// Use this if you do not need the actual stored instances, the fetch count is supposed
	/// to be faster. Return false if there are no saved entities matching the query.
	@MainActor func isStored<Entity>(entity: Entity) -> Bool where Entity: Fetchable {
		do {
			let count = try self.interactor.fetchCount(entity.identityQuery())
			return count > 0
		} catch {
			print(error)
		}
		return false
	}
	
	/// Insert the specified entity into storage. If an entity was previously saved with the same identifier, return
	/// that saved instance. Otherwise insert the specified entity into storage and return that same instance.
	@MainActor func insert<Entity>(entity: Entity) -> Entity where Entity: Fetchable {
		var stored = [Entity]()
		do {
			stored = try self.interactor.fetch(entity.identityQuery())
		} catch {
			print(error)
		}
		if let original = stored.first {
			return original
		}
		
		self.interactor.insert(entity)
		return entity
	}
	
	/// Return an array of entities matching the specified descriptor. 
	@MainActor func fetch<Entity>(_ descriptor: FetchDescriptor<Entity>) -> [Entity] {
		do {
			let results = try self.interactor.fetch(descriptor)
			return results
		} catch {
			print(error)
		}
		return []
	}
	
	@MainActor static var preview: StorageModel {
		let model = StorageModel(preview: true)
		_ = model.insert(book: Book.Preview.dorsai)
		_ = model.insert(book: Book.Preview.legend)
		_ = model.insert(book: Book.Preview.quiet)
		_ = model.insert(book: Book.Preview.dune1987)
		_ = model.insert(book: Book.Preview.dune1986)
		return model
	}
}

/// Fetchables implement an identity query storage can use to see if an entity
/// with the same identifer is already saved. We *should* be able to use the id
/// from Identifiable but this doesn't work with the predicate macro. 
public protocol Fetchable: PersistentModel {
	func identityQuery() -> FetchDescriptor<Self>
}
