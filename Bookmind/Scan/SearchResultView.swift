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
	let result: BookSearch.Result
	@EnvironmentObject var covers: CoverModel
	@State var cover: UIImage?
	@ScaledMetric(relativeTo: .body) private var imageHeight = 40.0

	var body: some View {
		HStack(spacing: 16.0) {
			if self.cover != nil {
				Image(uiImage: self.cover!)
					.resizable()
					.scaledToFit()
					.cornerRadius(8.0)
					.frame(height: self.imageHeight)
			}
			VStack(alignment: self.cover == nil ? .center : .leading) {
				if self.title != nil {
					Text(self.title!)
						.fontWeight(.bold)
				}
				Text(self.subtitle)
			}
		}
		.padding()
		.frame(maxWidth: 330)
		.background(.regularMaterial)
		.cornerRadius(24.0)
		.onAppear {
			self.fetchCover()
		}
	}
	
	private var title: String? {
		if case .found(_, let book, _) = self.result {
			return book.title
		}
		return nil
	}
	
	private var subtitle: String {
		switch self.result {
			case .searching(let isbn):
				return "Searching for ISBN \(isbn)"
			case .found(_, _, let authors):
				return authors.map { $0.name }.joined(separator: ", ")
			case .failed(let isbn):
				return "Could not find ISBN \(isbn)"
		}
	}
	
	private func fetchCover() {
		guard case .found(let edition, _, _) = self.result else { return }
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
	VStack {
		SearchResultView(result: BookSearch.Preview.failed)
		SearchResultView(result: BookSearch.Preview.searching)
		SearchResultView(result: BookSearch.Preview.quiet)
		SearchResultView(result: BookSearch.Preview.legend)
		SearchResultView(result: BookSearch.Preview.dorsai)
	}
	.environmentObject(CoverModel())
}
