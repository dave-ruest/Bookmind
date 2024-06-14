//
//  CoverView.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// CoverView displays an edition of a book.
///
/// If cover art is available, the view just displays that image,
/// since all the book information should be there, prettier than
/// we can show it.
///
/// If no cover art is available, show as much book details as
/// space permits. There should usually be enough space for title,
/// authors and isbn but larger accessibility sizes are very space
/// constrained.
struct CoverView: View {
	let book: Book
	
	/// Cache for cover art, injected by the app.
	@EnvironmentObject private var covers: CoverModel
	/// The cover image, fetched on appear.
	@State private var cover: UIImage?

	var body: some View {
		Group {
			if cover == nil {
				ViewThatFits {
					BookTallHeader(book: self.book)
					BookHeader(book: self.book)
					BookShortHeader(book: self.book)
				}
			} else {
				Image(uiImage: self.cover!)
					.resizable()
					.aspectRatio(contentMode: .fit)
			}
		}
		.bookCoverFrame()
		.task {
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

	private struct BookTallHeader: View {
		let book: Book

		var body: some View {
			VStack(spacing: 8.0) {
				VStack(spacing: 8.0) {
					Text(self.book.work.title)
						.font(.title)
					Text(self.book.authors.names)
					Text(self.book.edition.isbn)
				}
				.bookGroupStyle()
			}
		}
	}

	private struct BookHeader: View {
		let book: Book

		var body: some View {
			VStack(spacing: 8.0) {
				VStack(spacing: 8.0) {
					Text(self.book.work.title)
						.font(.title)
					Text(self.book.authors.names)
				}
				.bookGroupStyle()
			}
		}
	}
	
	private struct BookShortHeader: View {
		let book: Book
		
		var body: some View {
			VStack(spacing: 8.0) {
				Text(self.book.work.title)
					.font(.title)
				Text(self.book.authors.names)
			}
			.bookGroupStyle()
		}
	}
}
