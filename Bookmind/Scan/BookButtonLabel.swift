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
	let book: Book
	
	@EnvironmentObject private var covers: CoverModel
	@State private var cover: UIImage?
	@ScaledMetric(relativeTo: .body) private var imageHeight = 40.0
	@ScaledMetric(relativeTo: .body) private var border = BookStyle.border
	@ScaledMetric(relativeTo: .body) private var padding = BookStyle.padding

	var body: some View {
		HStack(spacing: 16.0) {
			if self.cover != nil {
				Image(uiImage: self.cover!)
					.resizable()
					.scaledToFit()
					.frame(height: self.imageHeight)
			}
			VStack(alignment: self.cover == nil ? .center : .leading) {
				Text(self.book.work.title)
					.fontWeight(.bold)
				Text(self.book.authors.names)
			}
		}
		.bookViewFrame()
		.padding(self.padding)
		.bookViewBackground()
		.overlay {
			Capsule()
				.stroke(Color(.accent), lineWidth: self.border)
		}
		.task(priority: .background) {
			self.fetchCover()
		}
	}
	
	private func fetchCover() {
		guard let coverId = book.edition.coverIds.first else { return }
		
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
	return ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		NavigationStack {
			VStack(spacing: 16.0) {
				BookButtonLabel(book: Book.Preview.dorsai)
				BookButtonLabel(book: Book.Preview.legend)
				BookButtonLabel(book: Book.Preview.quiet)
				BookButtonLabel(book: Book.Preview.dune1986)
				BookButtonLabel(book: Book.Preview.dune1987)
			}
			.padding()
		}
	}
	.environmentObject(CoverModel())
}
