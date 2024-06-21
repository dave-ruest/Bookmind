//
//  CoverFetchModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-20.
//

import SwiftUI

/// A view modifier which pulls cover ids from its edition binding, and
/// pushes any loaded cover art to its cover binding. This consolidates
/// the fetchCover code in one place. Attaching re-usable behavior to
/// any view at all is... pretty powerful. 
struct CoverFetchModifier: ViewModifier {
	@Binding var edition: Edition
	@Binding var cover: UIImage
	/// Cache for cover art, injected by the app.
	@EnvironmentObject private var covers: CoverModel

	func body(content: Content) -> some View {
		content
			.onChange(of: self.edition, initial: true) {
				self.fetchCover()
			}
	}
	
	private func fetchCover() {
		guard let coverId = self.edition.coverIds.first else { return }
		
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

extension View {
	/// A view modifier which pulls cover ids from its edition binding, and
	/// pushes any loaded cover art to its cover binding. This consolidates
	/// the fetchCover code in one place.
	func onChange(of edition: Binding<Edition>, update: Binding<UIImage>) -> some View{
		modifier(CoverFetchModifier(edition: edition, cover: update))
	}
}
