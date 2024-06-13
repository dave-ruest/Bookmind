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
	let work: Work
	/// A binding to pass selection back to the containing view.
	@Binding var selectedEdition: Edition
	
	var body: some View {
		TabView(selection: self.$selectedEdition) {
			ForEach(work.editions) { edition in
				CoverView(book: Book(edition: edition, work: self.work, authors: self.work.authors))
					.tag(edition)
			}
		}
		.tabViewStyle(.page)
		.indexViewStyle(.page(backgroundDisplayMode: .always))
		.bookCoverFrame()
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	var book = storage.insert(book: Book.Preview.dune1986)
	book = storage.insert(book: Book.Preview.dune1987)
	return ZStack {
		EditionPageView(work: book.work, selectedEdition: .constant(book.edition))
	}
	.padding()
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
