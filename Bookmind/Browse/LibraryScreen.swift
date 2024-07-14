//
//  LibraryScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/27/24.
//

import SwiftData
import SwiftUI

/// LibraryScreen displays a list of authors.
struct LibraryScreen: View {
	@Query(sort: [SortDescriptor(\Author.lastName, comparator: .localizedStandard)]) var authors: [Author]
	@Binding var filter: LibraryFilter

	var body: some View {
		List {
			ForEach(self.filter(self.authors)) { author in
				NavigationLink {
					AuthorScreen(author: author.author)
				} label: {
					AuthorLabel(filter: author)
				}
				.bookListRowStyle()
			}
		}
		.padding(.top, 1)
		.listStyle(.plain)
		.listRowSeparatorTint(.accent)
		.navigationBarTitleDisplayMode(.large)
		.navigationTitle(self.filter.title)
	}
}

#Preview {
	NavigationStack {
		ZStack {
			LibraryBackgroundView()
			LibraryScreen(filter: .constant(LibraryFilter.Preview.authors))
		}
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}

#Preview {
	NavigationStack {
		ZStack {
			LibraryBackgroundView()
			LibraryScreen(filter: .constant(LibraryFilter.Preview.own))
		}
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}

#Preview {
	NavigationStack {
		ZStack {
			LibraryBackgroundView()
			LibraryScreen(filter: .constant(LibraryFilter.Preview.read))
		}
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}
