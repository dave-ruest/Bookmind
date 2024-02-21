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
			try self.container = ModelContainer(for: Author.self, Book.self, configurations: config)
		} catch {
			fatalError("Could not create swift data storage")
		}
	}
	
	/// Save the specified book and authors. Do *not* insert the book or authors
	/// if one is already stored with the same unique identifier. Carefully set
	/// the many to many relationships between books and authors, again avoiding
	/// duplicates.
	@MainActor func add(book: Book, authors: [Author]) {
		let addedBook = self.add(book)
		for author in authors {
			let addedAuthor = self.add(author)
			if !addedBook.authors.contains(addedAuthor) {
				addedBook.authors.append(addedAuthor)
			}
		}
		self.save()
	}
	
	@MainActor func delete(_ authors: [Author]) {
		for author in authors {
			self.interactor.delete(author)
		}
		self.save()
	}
	
	@MainActor func delete(_ books: [Book]) {
		for book in books {
			self.interactor.delete(book)
		}
		self.save()
	}
	
	@MainActor private func save() {
		do {
			try self.interactor.save()
		} catch {
			print(error)
		}
	}
	
	/// Ensure the specified author is inserted without duplicates.
	/// - Parameter author: the author to be inserted.
	/// - Returns: the specified author, if no authors with the same
	/// identifer were saved previously. Otherwise return the previously
	/// saved author.
	@MainActor private func add(_ author: Author) -> Author {
		let olid = author.olid
		let filter = FetchDescriptor<Author>(predicate: #Predicate { author in
			author.olid == olid
		})
		
		var conflicts = [Author]()
		do {
			conflicts = try self.interactor.fetch(filter)
		} catch {
			print(error)
		}
		
		if let original = conflicts.first {
			return original
		}
		
		self.interactor.insert(author)
		return author
	}

	/// Ensure the specified book is inserted without duplicates.
	/// - Parameter book: the book to be inserted.
	/// - Returns: the specified book, if no books with the same
	/// identifer were saved previously. Otherwise return the previously
	/// saved book.
	@MainActor private func add(_ book: Book) -> Book {
		let isbn = book.isbn
		let filter = FetchDescriptor<Book>(predicate: #Predicate { book in
			book.isbn == isbn
		})
		
		var duplicates = [Book]()
		do {
			duplicates = try self.interactor.fetch(filter)
		} catch {
			print(error)
		}
		
		if let duplicate = duplicates.first {
			return duplicate
		}
		
		self.interactor.insert(book)
		return book
	}
	
	@MainActor static var preview: StorageModel {
		let model = StorageModel(preview: true)
		model.add(book: Book.Preview.dorsai, authors: [Author.Preview.dickson])
		model.add(book: Book.Preview.legend, authors: [Author.Preview.gemmell])
		model.add(book: Book.Preview.quiet, authors: [Author.Preview.cain])
		return model
	}
}
