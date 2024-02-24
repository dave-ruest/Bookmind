//
//  BookScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/4/24.
//

import SwiftData
import SwiftUI

struct BookScreen: View {
	@ObservedObject var book: Book

	var body: some View {
		ZStack {
			Color(.background)
				.ignoresSafeArea()
			VStack(spacing: 16.0) {
				Text(self.book.title)
				Picker(book.readState.description, selection: self.$book.readState) {
					ForEach(ReadState.allCases) { read in
						Text(read.description)
					}
				}
				.bookButton()
				RatingView(rating: $book.rating)
				List {
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
		
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let edition = Edition.Preview.quiet
	let book = Book.Preview.quiet
	_ = storage.add(edition: edition, book: book,authors: [Author.Preview.cain])
	return NavigationStack {
		BookScreen(book: book)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
