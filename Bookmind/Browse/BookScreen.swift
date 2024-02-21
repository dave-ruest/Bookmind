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
				SearchResultView(book: self.book, authors: self.book.authors)
				Picker(book.ownState.description, selection: self.$book.ownState) {
					ForEach(OwnState.allCases) { owned in
						Text(owned.description)
					}
				}
				.bookButton()
				Picker(book.readState.description, selection: self.$book.readState) {
					ForEach(ReadState.allCases) { read in
						Text(read.description)
					}
				}
				.bookButton()
				RatingView(rating: $book.rating)
				Spacer()
			}
			.navigationBarTitleDisplayMode(.inline)
			.pickerStyle(.menu)
			.dynamicTypeSize(.small ... .accessibility2)
		}
	}
	
	private func toggleImage(_ isOn: Bool) -> String {
		isOn ? "checkmark.circle" : "circle"
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = Book.Preview.quiet
	storage.add(book: book, authors: [Author.Preview.cain])
	return NavigationStack {
		BookScreen(book: book)
			.modelContainer(storage.container)
	}
}
