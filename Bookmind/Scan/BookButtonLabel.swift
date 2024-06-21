//
//  AddButton.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// BookButtonLabel displays a book in a "bookmind style" button.
/// The cover, title and authors are arranged in a compact layout.
/// The border, padding and minimum height match the bookmind
/// button style. 
struct BookButtonLabel: View {
	@Binding var book: Book
	
	@State private var cover = UIImage(resource: .defaultCover)
	@ScaledMetric(relativeTo: .body) private var imageHeight = 40.0
	@ScaledMetric(relativeTo: .body) private var border = BookStyle.border
	@ScaledMetric(relativeTo: .body) private var padding = BookStyle.padding

	var body: some View {
		HStack(spacing: 16.0) {
			Image(uiImage: self.cover)
				.resizable()
				.scaledToFit()
				.frame(height: self.imageHeight)
			VStack(alignment: .leading) {
				Text(self.book.work.title)
					.fontWeight(.bold)
				Text(self.book.authors.names)
			}
			.lineLimit(2)
			.multilineTextAlignment(.leading)
		}
		.bookViewFrame()
		.padding(self.padding)
		.bookViewBackground()
		.overlay {
			Capsule()
				.stroke(Color(.accent), lineWidth: self.border)
		}
		.onChange(of: self.$book.edition, update: self.$cover)
	}
}

#Preview {
	return ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		NavigationStack {
			VStack(spacing: 16.0) {
				BookButtonLabel(book: .constant(Book.Preview.dorsai))
				BookButtonLabel(book: .constant(Book.Preview.legend))
				BookButtonLabel(book: .constant(Book.Preview.quiet))
				BookButtonLabel(book: .constant(Book.Preview.dune1986))
				BookButtonLabel(book: .constant(Book.Preview.dune1987))
			}
			.padding()
		}
	}
	.environmentObject(CoverModel())
}
