//
//  WorkListLabel.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-19.
//

import SwiftUI

/// WorkListLabel provides a summary of a work suitable for a list row.
/// Feels like it could show a bit more information, like maybe the rating,
/// or an icon if the book or edition are on the reading or shopping lists.
struct WorkListLabel: View {
	/// The work whose name and cover will be shown.
	@State var work: Work
	
	/// Cache for cover art, injected by the app.
	@EnvironmentObject private var covers: CoverModel
	/// The cover image, fetched on appear.
	@State private var cover = UIImage(resource: .defaultCover)
	/// A slightly larger cover looks nice on the author screen.
	@ScaledMetric(relativeTo: .body) private var imageHeight = 60.0

	var body: some View {
		HStack() {
			Image(uiImage: self.cover)
				.resizable()
				.scaledToFit()
				.frame(height: self.imageHeight)
			Text(work.title)
			Spacer()
		}
		.bookViewFrame()
		.task {
			self.fetchCover()
		}
	}
	
	private func fetchCover() {
		guard let edition = self.work.editions.first else { return }
		guard let coverId = edition.coverIds.first else { return }
		
		if let cover = self.covers.getCover(coverId) {
			self.cover = cover
			return
		}
		
		self.covers.fetch(coverId: coverId) { image in
			if let image {
				self.cover = image
			}
		}
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let dorsai = storage.insert(book: Book.Preview.dorsai)
	let legend = storage.insert(book: Book.Preview.legend)
	let quiet = storage.insert(book: Book.Preview.quiet)
	return VStack {
		WorkListLabel(work: dorsai.work)
		WorkListLabel(work: legend.work)
		WorkListLabel(work: quiet.work)
	}
	.padding()
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
