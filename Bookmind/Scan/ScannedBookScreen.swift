//
//  SingleEditionBookScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-05.
//

import SwiftData
import SwiftUI

/// ScannedBookScreen displays a scanned book: an edition and its work.
struct ScannedBookScreen: View {
	/// The book to display. The user may edit rating and read state.
	@State var book: Book
	
	/// Core data storage, used to edit book and edition.
	@EnvironmentObject private var storage: StorageModel
	/// Cache for cover art, injected by the app.
	@EnvironmentObject private var covers: CoverModel
	/// The cover image, fetched on appear.
	@State private var cover: UIImage?
	
	var body: some View {
		ZStack {
			CoverBackgroundView(edition: self.$book.edition)
			ViewThatFits {
				VStack(spacing: 8.0) {
					CoverView(book: self.book)
					OwnStateView(state: self.$book.edition.ownState)
					ReadStateView(state: self.$book.work.readState)
					RatingView(rating: self.$book.work.rating)
					DoneButton()
				}
				HStack(spacing: 8.0) {
					CoverView(book: self.book)
					VStack() {
						OwnStateView(state: self.$book.edition.ownState)
						ReadStateView(state: self.$book.work.readState)
						RatingView(rating: self.$book.work.rating)
						DoneButton()
					}
				}
			}
			.padding()
			.navigationBarTitleDisplayMode(.inline)
			.dynamicTypeSize(.small ... .accessibility3)
		}.task {
			self.fetchCover()
		}
	}
	
	private func fetchCover() {
		guard let coverId = self.book.edition.coverIds.first else { return }
		
		if let cover = self.covers.getCover(coverId) {
			self.cover = cover
			return
		}
		
		self.covers.fetch(coverId: coverId) { image in
			self.cover = image
		}
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.quiet)
	return ScannedBookScreen(book: book)
			.modelContainer(storage.container)
	.environmentObject(CoverModel())
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.legend)
	return ScannedBookScreen(book: book)
			.modelContainer(storage.container)
	.environmentObject(CoverModel())
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.dorsai)
	return ScannedBookScreen(book: book)
			.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
