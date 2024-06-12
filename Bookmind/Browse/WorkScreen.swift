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
	@ObservedObject var work: Work
	/// Core data storage, used to delete editions.
	/// Set by the app or preview.
	@EnvironmentObject var storage: StorageModel

	var body: some View {
		ZStack {
			Color(.background)
				.ignoresSafeArea()
			VStack(spacing: 16.0) {
				Text(self.work.title)
					.font(.title)
				Picker(work.readState.description, selection: self.$work.readState) {
					ForEach(ReadState.allCases) { read in
						Text(read.description)
					}
				}
				.bookButtonStyle()
				RatingView(rating: $work.rating)
				List {
					// The "self.book.editions" here lazy loads books
					// from the many to many core data relationship.
					// Adding and deleting are trickier but wow does
					// this ever "just work".
					ForEach(self.work.editions) { edition in
						EditionView(edition: edition)
					}
					.onDelete(perform: delete)
					.listRowSeparator(.visible, edges: .top)
				}.bookListStyle()
				Spacer()
			}
			.navigationBarTitleDisplayMode(.inline)
			.dynamicTypeSize(.small ... .accessibility2)
			.toolbar {
				EditButton()
			}
		}
	}
	
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
		ZStack {
			Color(.background)
				.ignoresSafeArea()
			WorkScreen(work: book.work)
				.padding()
		}
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
