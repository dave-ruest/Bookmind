//
//  BookScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/4/24.
//

import SwiftData
import SwiftUI

/// BookScreen displays a book: rating, read state, and all editions.
/// Each edition is shown in a list with own state and cover art, or
/// just the ISBN if no cover is available.
struct BookScreen: View {
	/// The book whose properties and editions we'll display.
	/// Variable and observable because the user may edit rating and
	/// read state. Editions may be deleted but that is a core data storage
	/// operation. 
	@ObservedObject var book: Book
	/// Core data storage, used to delete editions.
	/// Set by the app or preview.
	@EnvironmentObject var storage: StorageModel

	var body: some View {
		ZStack {
			Color(.background)
				.ignoresSafeArea()
			VStack(spacing: 16.0) {
				Text(self.book.title)
					.font(.title)
				Picker(book.readState.description, selection: self.$book.readState) {
					ForEach(ReadState.allCases) { read in
						Text(read.description)
					}
				}
				.bookButton()
				RatingView(rating: $book.rating)
				List {
					// The "self.book.editions" here lazy loads books
					// from the many to many core data relationship.
					// Adding and deleting are trickier but wow does
					// this ever "just work".
					ForEach(self.book.editions) { edition in
						EditionView(edition: edition)
					}
					.onDelete(perform: delete)
					.listRowSeparator(.visible, edges: .top)
				}.bookList()
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
		let editions = offsets.map { self.book.editions[$0] }
		self.storage.delete(editions)
		self.book.editions.remove(atOffsets: offsets)
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let edition = Edition.Preview.quiet
	let book = Book.Preview.quiet
	_ = storage.insert(edition: edition, book: book,authors: [Author.Preview.cain])
	return NavigationStack {
		BookScreen(book: book)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
