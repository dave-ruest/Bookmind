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
	@State var book: Book
	
	/// The cover image, fetched on appear.
	@State private var cover = UIImage(resource: .defaultCover)

	var body: some View {
		ZStack {
			Image(uiImage: self.cover)
				.resizable()
				.aspectRatio(contentMode: .fit)
			if self.cover == UIImage(resource: .defaultCover) {
				VStack() {
					Text(self.book.work.title)
						.font(.title)
					Text(self.book.authors.names)
				}
				.bookGroupStyle()
			}
		}
		.bookCoverFrame()
		.onChange(of: self.$book.edition, update: self.$cover)
	}
}
