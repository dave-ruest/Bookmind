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
				Text(book.title)
					.listRowBackground(Color(.clear))
			}
		}
		.listStyle(.plain)
		.listRowSeparatorTint(.accent)
		.background(Color(.background))
		.navigationTitle(self.author.name)
		.navigationBarTitleDisplayMode(.large)
	}
}

#Preview {
	// TODO: refactor preview so author has book relationship
	let storage = StorageModel.preview
	return AuthorScreen(author: Author.Preview.dickson)
		.modelContainer(storage.container)
}
