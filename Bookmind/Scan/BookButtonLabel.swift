//
//  AddButton.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// BookButtonLabel displays a navigation link when its bindings
/// are non-nil. It displays an empty view otherwise. 
///
/// This button is currently quite specific to the scan screen.
/// We'll factor out any common code when we start the search
/// flow.
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
			}
			.padding()
		}
	}
	.environmentObject(CoverModel())
}
