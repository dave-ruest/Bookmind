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
	@ObservedObject var book: Book
	/// The edition to display. The user may edit the own state.
	@ObservedObject var edition: Edition
	/// Core data storage, used to edit book and edition.
	@EnvironmentObject var storage: StorageModel
	/// Cache for cover art, injected by the app.
	@EnvironmentObject var covers: CoverModel
	/// The cover image, fetched on appear.
	@State var cover: UIImage?
	
	var body: some View {
		ZStack {
			CoverBackgroundView(cover: self.$cover)
			ViewThatFits {
				VStack(spacing: 8.0) {
					CoverView(book: self.book, edition: self.edition, cover: self.$cover)
					OwnStateView(state: self.$edition.ownState)
					ReadStateView(state: self.$book.readState)
					RatingView(rating: $book.rating)
					DoneButton()
				}
				.padding()
				HStack(spacing: 8.0) {
					CoverView(book: self.book, edition: self.edition, cover: self.$cover)
					VStack() {
						OwnStateView(state: self.$edition.ownState)
						ReadStateView(state: self.$book.readState)
						RatingView(rating: $book.rating)
						DoneButton()
					}
				}
				.padding()
			}
			.navigationBarTitleDisplayMode(.inline)
			.dynamicTypeSize(.small ... .accessibility3)
		}.task {
			self.fetchCover()
		}
	}
	
	private func fetchCover() {
		guard let coverId = edition.coverIds.first else { return }
		
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
	let edition = Edition.Preview.quiet
	let book = Book.Preview.quiet
	storage.insert(edition: edition, book: book, authors: [Author.Preview.cain])
	return ScannedBookScreen(book: book, edition: edition)
			.modelContainer(storage.container)
	.environmentObject(CoverModel())
}

#Preview {
	let storage = StorageModel(preview: true)
	let edition = Edition.Preview.legend
	let book = Book.Preview.legend
	storage.insert(edition: edition, book: book, authors: [Author.Preview.gemmell])
	return ScannedBookScreen(book: book, edition: edition)
			.modelContainer(storage.container)
	.environmentObject(CoverModel())
}

#Preview {
	let storage = StorageModel(preview: true)
	let edition = Edition.Preview.dorsai
	let book = Book.Preview.dorsai
	storage.insert(edition: edition, book: book, authors: [Author.Preview.dickson])
	return ScannedBookScreen(book: book, edition: edition)
			.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
