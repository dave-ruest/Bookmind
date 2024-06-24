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
					AuthorScreen(author: author)
				} label: {
					HStack {
						Text("\(author.firstName) **\(author.lastName)**")
						Spacer()
						Text("\(author.books.count)")
					}
					.bookViewFrame()
				}
				.bookListRowStyle()
			}.onDelete(perform: delete)
		}
		.listStyle(.plain)
		.listRowSeparatorTint(.accent)
//		.background(Color(.background))
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
		ZStack {
			LibraryBackgroundView()
			LibraryScreen()
		}
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}
