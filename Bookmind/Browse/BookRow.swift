//
//  BookRow.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/27/24.
//

import SwiftUI

struct BookRow: View {
	var book: Book
	@ScaledMetric(relativeTo: .body) private var imageHeight = 40.0
	private var imageWidth : Double {
		self.imageHeight * 2 / 3
	}

	var body: some View {
		HStack {
			Image(uiImage: book.cover ?? UIImage())
				.resizable()
				.scaledToFit()
				.frame(width: self.imageWidth, height: self.imageHeight)
			VStack(alignment: .leading) {
				Text(book.title)
					.fontWeight(.bold)
				if !book.authors.isEmpty {
					Text(book.authors)
				}
			}
		}
		.listRowSeparatorTint(.accent)
		.listRowBackground(Color(.clear))
	}
}

#Preview {
	List {
		BookRow(book: Book.Preview.quiet)
		BookRow(book: Book.Preview.dorsai)
		BookRow(book: Book.Preview.legend)
	}
	.listStyle(.plain)
	.background(Color.background)
}
