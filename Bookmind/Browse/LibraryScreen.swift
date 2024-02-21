//
//  LibraryScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/27/24.
//

import SwiftData
import SwiftUI

/// LibraryScreen displays a list of authors. We've only just
/// added basic persistence, so this screen is also rough. We
/// expect rather a lot of polish here: must be stored by
/// last name, some kind of search where you can find just the
/// book by title, if you forget the author name...
struct LibraryScreen: View {
	@EnvironmentObject var storage: StorageModel
	@Query(sort: \Author.lastName, order: .forward) var authors: [Author]
	
	var body: some View {
		List {
			ForEach(self.authors) { author in
				NavigationLink {
//					if author.books.count == 1 {
//						BookScreen(book: author.books.first!)
//					} else {
						AuthorScreen(author: author)
//					}
				} label: {
					Text("\(author.firstName) **\(author.lastName)**")
				}
				.listRowBackground(Color(.clear))
			}.onDelete(perform: delete)
		}
		.listStyle(.plain)
		.listRowSeparatorTint(.accent)
		.background(Color(.background))
		.toolbar {
			EditButton()
		}
		.navigationBarTitleDisplayMode(.large)
		.navigationTitle("Bookmind")
	}
	
	private func delete(at offsets: IndexSet) {
		let delete = offsets.map { self.authors[$0] }
		self.storage.delete(delete)
	}
}

#Preview {
	NavigationStack {
		LibraryScreen()
			.modelContainer(StorageModel.preview.container)
	}
}
