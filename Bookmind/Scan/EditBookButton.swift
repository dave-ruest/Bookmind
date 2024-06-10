//
//  AddButton.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// EditBookButton displays a navigation link when its bindings
/// are non-nil. It displays an empty view otherwise. 
///
/// This button is currently quite specific to the scan screen.
/// We'll factor out any common code when we start the search
/// flow.
struct EditBookButton: View {
	@Binding var edition: Edition?
	@Binding var book: Book?
	@Binding var authors: [Author]
	
	@EnvironmentObject private var covers: CoverModel
	@State private var cover: UIImage?
	@ScaledMetric(relativeTo: .body) private var imageHeight = 40.0

	var body: some View {
		if book == nil || edition == nil || authors.isEmpty {
			EmptyView()
		} else {
			NavigationLink {
				ScannedBookScreen(book: self.book!, edition: self.edition!)
			} label: {
				HStack(spacing: 16.0) {
					if self.cover != nil {
						Image(uiImage: self.cover!)
							.resizable()
							.scaledToFit()
							.frame(height: self.imageHeight)
					}
				}
				VStack(alignment: self.cover == nil ? .center : .leading) {
					Text(self.book!.title)
					Text(self.authorNames)
				}
			}
			.bookButtonStyle()
			.onChange(of: self.edition, initial: true) {
				self.editionChanged()
			}
		}
	}
	
	private var authorNames: String {
		// added sorting to make test deterministic
		// seems the storage is unordered, need to fix if we need ordered
		// i.e. to match the list of authors on the edition
		let sorted = authors.sorted { $0.lastName < $1.lastName }
		return sorted.map { $0.name }.joined(separator: ", ")
	}
	
	private func editionChanged() {
		guard let edition else { return }
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
	let edition = Edition.Preview.quiet
	let book = Book.Preview.quiet
	let authors = [Author.Preview.cain]
	
	return ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		NavigationStack {
			VStack(spacing: 16.0) {
				EditBookButton(edition: .constant(nil), book: .constant(book), authors: .constant(authors))
				EditBookButton(edition: .constant(edition), book: .constant(nil), authors: .constant(authors))
				EditBookButton(edition: .constant(edition), book: .constant(book), authors: .constant([]))
				EditBookButton(edition: .constant(edition), book: .constant(book), authors: .constant(authors))
				EditBookButton(edition: .constant(Edition.Preview.legend),
							   book: .constant(Book.Preview.legend),
							   authors: .constant([Author.Preview.gemmell]))
				EditBookButton(edition: .constant(Edition.Preview.dorsai),
							   book: .constant(Book.Preview.dorsai),
							   authors: .constant([Author.Preview.dickson]))
			}
			.padding()
		}
	}
	.environmentObject(CoverModel())
}
