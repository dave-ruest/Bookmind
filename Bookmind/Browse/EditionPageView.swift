//
//  EditionPageView.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-12.
//

import SwiftUI

/// EditionPageView is a paginated tab view of book editions. 
struct EditionPageView: View {
	/// The work whose editions will be displayed in the stack.
	/// There will usually be only one edition. But this view will look
	/// really, really smart when there are multiple editions.
	let filter: FilteredWork
	/// A binding to pass selection back to the containing view.
	@Binding var selectedEdition: Edition
	
	var body: some View {
		TabView(selection: self.$selectedEdition) {
			ForEach(filter.books) { book in
				CoverView(book: book)
					.tag(book)
			}
		}
		.bookCoverFrame()
		.tabViewStyle(.page)
		.indexViewStyle(.page(backgroundDisplayMode: .always))
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	var book = storage.insert(book: Book.Preview.dune1986)
	book = storage.insert(book: Book.Preview.dune1987)
	let filter = FilteredWork(work: book.work)
	return ZStack {
		EditionPageView(filter: filter, selectedEdition: .constant(book.edition))
	}
	.padding()
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
