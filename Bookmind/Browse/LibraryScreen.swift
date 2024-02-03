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
	@Query(sort: \Author.name) var authors: [Author]

	var body: some View {
		List {
			ForEach(self.authors) { author in
				NavigationLink {
					AuthorScreen(author: author)
				} label: {
					Text(author.name)
						.fontWeight(.medium)
				}
				.listRowBackground(Color(.clear))
			}
		}
		.listStyle(.plain)
		.listRowSeparatorTint(.accent)
		.background(Color(.background))
	}
}

#Preview {
	LibraryScreen()
		.modelContainer(StorageModel.preview.container)
}
