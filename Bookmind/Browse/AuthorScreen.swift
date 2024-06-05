//
//  AuthorScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/30/24.
//

import SwiftData
import SwiftUI

/// AuthorScreen displays the list of books for a specific author.
struct AuthorScreen: View {
	/// The author whose name and books willl be shown.
	/// Constant as we don't define any editable author properties - yet.
	/// Books may be deleted but that is a core data storage operation.
	let author: Author
	/// Core data storage, used to delete editions.
	/// Set by the app or preview.
	@EnvironmentObject var storage: StorageModel

	var body: some View {
		List {
			// The "self.author.books" here lazy loads books
			// from the many to many core data relationship.
			// Adding and deleting are trickier but wow does
			// this ever "just work".
			ForEach(self.author.books) { book in
				NavigationLink {
					BookScreen(book: book)
				} label: {
					Text(book.title)
				}
				.listRowBackground(Color(.clear))
			}.onDelete(perform: delete)
		}
		.listStyle(.plain)
		.listRowSeparatorTint(.accent)
		.background(Color(.background))
		.navigationTitle(self.author.name)
		.navigationBarTitleDisplayMode(.large)
		.toolbar {
			EditButton()
		}
	}
	
	private func delete(at offsets: IndexSet) {
		let books = offsets.map { self.author.books[$0] }
		self.storage.delete(books)
		self.author.books.remove(atOffsets: offsets)
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let author = Author.Preview.cain
	_ = storage.insert(edition: Edition.Preview.quiet, book: Book.Preview.quiet, authors: [author])
	return NavigationStack {
		AuthorScreen(author: author)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
