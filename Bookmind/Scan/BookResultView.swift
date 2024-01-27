//
//  BookResultView.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/25/24.
//

import SwiftUI

/// BookResultView displays the title, author and cover of a book.
/// It hides the cover and authors if they are nil, so may be used
/// to display a book while that books information is still being
/// fetched.
struct BookResultView: View {
	let book: Book
	@ScaledMetric(relativeTo: .title) private var title = 32

	var body: some View {
		HStack(spacing: 16.0) {
			if self.hasCover {
				Image(uiImage: self.book.cover!)
					.resizable()
					.scaledToFit()
					.cornerRadius(8.0)
					.frame(maxHeight: self.title * 2)
			}
			VStack(alignment: self.hasCover ? .leading : .center) {
				Text(book.title)
					.font(.title)
				if !book.authors.isEmpty {
					Text(book.authors)
						.font(.title2)
				} else {
					Text(book.isbn)
				}
			}
		}
		.padding()
		.frame(maxWidth: 330)
		.background(.regularMaterial)
		.cornerRadius(24.0)
	}
	
	private var hasCover: Bool {
		self.book.cover != nil
	}
}

#Preview {
	VStack {
		BookResultView(book: Book.Preview.quiet)
		BookResultView(book: Book.Preview.legend)
		BookResultView(book: Book.Preview.dorsai)
	}
}
