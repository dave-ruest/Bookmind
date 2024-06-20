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
	@State var work: Work

	/// Core data storage, used to delete editions.
	@EnvironmentObject private var storage: StorageModel
	/// Cache for cover art, injected by the app.
	@EnvironmentObject private var covers: CoverModel
	/// The cover image, fetched on appear.
	@State private var cover: UIImage?
	/// The editions page view uses a binding to this state to communicate
	/// its selected edition. The work screen uses the selected edition for
	/// its background cover art and its own state picker.
	@State private var selectedEdition: Edition
	
	init(work: Work) {
		self.work = work
		// TODO: remove force unwrap
		self.selectedEdition = work.editions.first!
	}

	var body: some View {
		ZStack {
			CoverBackgroundView(edition: self.$selectedEdition)
			ViewThatFits {
				VStack() {
					EditionPageView(work: self.work, selectedEdition: self.$selectedEdition)
					OwnStateView(state: self.$selectedEdition.ownState)
					ReadStateView(state: self.$work.readState)
					if self.work.readState == .read {
						RatingView(rating: self.$work.rating)
					}
				}
				HStack() {
					EditionPageView(work: self.work, selectedEdition: self.$selectedEdition)
					VStack() {
						OwnStateView(state: self.$selectedEdition.ownState)
						ReadStateView(state: self.$work.readState)
						if self.work.readState == .read {
							RatingView(rating: self.$work.rating)
						}
					}
				}
			}
			.padding()
			.dynamicTypeSize(.small ... .accessibility3)
		}
		.navigationBarTitleDisplayMode(.inline)
	}
	
	// TODO: restore edit button and edition delete
	private func delete(at offsets: IndexSet) {
		let editions = offsets.map { self.work.editions[$0] }
		self.storage.delete(editions)
		self.work.editions.remove(atOffsets: offsets)
	}
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


#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.legend)
	return NavigationStack {
		WorkScreen(work: book.work)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
