//
//  SearchResultView.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/25/24.
//

import SwiftUI

/// SearchResultView displays the title, author and cover of a book.
/// It hides the cover and authors if they are nil, so may be used
/// to display a book while that books information is still being
/// fetched.
struct SearchResultView: View {
	let book: Book
	let authors: [Author]
	@ScaledMetric(relativeTo: .body) private var imageHeight = 40.0

	var body: some View {
		HStack(spacing: 16.0) {
			if self.hasCover {
				Image(uiImage: self.book.cover!)
					.resizable()
					.scaledToFit()
					.cornerRadius(8.0)
					.frame(height: self.imageHeight)
			}
			VStack(alignment: self.hasCover ? .leading : .center) {
				Text(book.title)
					.fontWeight(.bold)
				if !self.authors.isEmpty {
					Text(self.authorNames)
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
	
	private var authorNames: String {
		self.authors.map { $0.name }.joined(separator: ", ")
	}
}

#Preview {
	VStack {
		SearchResultView(book: Book.Preview.quiet, authors: [Author.Preview.cain])
		SearchResultView(book: Book.Preview.legend, authors: [Author.Preview.gemmell])
		SearchResultView(book: Book.Preview.dorsai, authors: [Author.Preview.dickson])
	}
}
