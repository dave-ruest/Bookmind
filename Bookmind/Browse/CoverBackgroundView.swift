//
//  CoverBackgroundView.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// CoverBackgroundView displays a cover in a background view.
/// It fills the background and ignores the safe area. If the
/// cover image is not available, a plain background color is shown.
/// If the image *is* available, it is blurred, stretched and
/// slightly darkened. The idea is to provide content specific
/// visual interest but not distract too much from book details.
struct CoverBackgroundView: View {
	@Binding var edition: Edition
	
	/// Cache for cover art, injected by the app.
	@EnvironmentObject private var covers: CoverModel
	/// The cover image, fetched on appear.
	@State private var cover: UIImage?

	var body: some View {
		Group {
			if self.cover == nil {
				Color(.background)
			} else {
				Image(uiImage: self.cover!)
					.resizable()
					.blur(radius: 8.0)
			}
		}
		.ignoresSafeArea()
		.brightness(-0.2)
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbarBackground(.thinMaterial, for: .navigationBar)
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
			self.cover = image
		}
	}
}
