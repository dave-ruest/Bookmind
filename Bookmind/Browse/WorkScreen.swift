//
//  WorkScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/4/24.
//

import SwiftData
import SwiftUI

/// WorkScreen displays a book: rating, read state, and all editions.
/// Each edition is shown in a list with own state and cover art, or
/// just the ISBN if no cover is available.
struct WorkScreen: View {
	/// The book whose properties and editions we'll display.
	/// Variable and observable because the user may edit rating and
	/// read state. Editions may be deleted but that is a core data storage
	/// operation. 
	@State private var work: Work
	/// A filter on the works editions, which may be hidden based on read
	/// or own state or genre.
	@State private var filter: FilteredWork
	/// The editions page view uses a binding to this state to communicate
	/// its selected edition. The work screen uses the selected edition for
	/// its background cover art and its own state picker.
	@State private var selectedEdition: Edition
	/// Updated by the editable modifier when edit mode changes.
	@State private var isEditing = false
	/// The height class environment variable, used in screen layout.
	@Environment(\.verticalSizeClass) private var heightClass
	/// Core data storage, used to delete editions.
	@EnvironmentObject private var storage: StorageModel
	/// The dismiss environment variable, used to close the screen if
	/// we delete the last edition of a work and the work.
	@Environment(\.dismiss) private var dismiss

	init(work: Work) {
		self.work = work
		self.filter = FilteredWork(work: work)
		self.selectedEdition = work.editions.first ?? Edition(isbn: "")
	}
	
	init(filter: FilteredWork) {
		self.work = filter.work
		self.filter = filter
		self.selectedEdition = filter.books.first?.edition ?? Edition(isbn: "")
	}

	var body: some View {
		// should be easy to ifdef a different case for ipad
		let AStack = heightClass == .compact
			? AnyLayout(HStackLayout())
			: AnyLayout(VStackLayout())
		
		ZStack {
			CoverBackgroundView(edition: self.$selectedEdition)
			AStack {
				if self.isEditing {
					VStack {
						TextField("Title", text: self.$work.title, axis: .vertical)
							.bookViewFrame()
							.bookTextFieldStyle()
						List {
							ForEach(self.work.authors) { author in
								AuthorLabel(author: author)
							}
						}
						.scrollContentBackground(.hidden)
						.colorMultiply(.background.opacity(BookStyle.opacity))
					}
					Spacer()
					DeleteButton { self.delete() }
				} else {
					EditionPageView(filter: self.filter, selectedEdition: self.$selectedEdition)
					VStack {
						Text(.init("**ISBN 13**: " + self.selectedEdition.isbn))
							.bookGroupStyle()
						OwnStateMenu(state: self.$selectedEdition.ownState)
						ReadStateMenu(state: self.$work.readState)
					}
				}
			}
			.animation(.smooth, value: self.isEditing)
			.editable(self.$isEditing)
			.padding()
			.dynamicTypeSize(.small ... .accessibility3)
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			EditButton()
		}
	}
	
	private func delete() {
		self.storage.delete([self.selectedEdition])
		self.work.editions.removeAll(where: { $0 == self.selectedEdition })
		
		if self.work.editions.isEmpty {
			self.dismiss()
			
			let authors = self.work.authors
			self.storage.delete([self.work])
			for author in authors {
				author.books.removeAll(where: { $0 == self.work })
			}
			let bookless = authors.filter { $0.books.isEmpty }
			if !bookless.isEmpty {
				self.storage.delete(bookless)
			}
		}
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.legend)
	return NavigationStack {
		WorkScreen(work: book.work)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.quiet)
	return NavigationStack {
		WorkScreen(work: book.work)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}

#Preview {
	let storage = StorageModel(preview: true)
	var book = storage.insert(book: Book.Preview.dune1986)
	book = storage.insert(book: Book.Preview.dune1987)
	return NavigationStack {
		WorkScreen(work: book.work)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
