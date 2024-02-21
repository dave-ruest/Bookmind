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
	@EnvironmentObject var storage: StorageModel
	/// The author whose name and books we'll show.
	/// That "self.author.books" below is so breathtakingly simple
	/// it was a little difficult to grasp. This truly "just works"
	/// after we set up the many to many relationship. Well, we
	/// also have to be careful to avoid crashes on insertion.
	/// But boy does it look good here.
	let author: Author

	var body: some View {
		List {
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
		let delete = offsets.map { self.author.books[$0] }
		self.storage.delete(delete)
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let author = Author.Preview.cain
	storage.add(book: Book.Preview.quiet, authors: [author])
	return NavigationStack {
		AuthorScreen(author: author)
			.modelContainer(storage.container)
	}
}
