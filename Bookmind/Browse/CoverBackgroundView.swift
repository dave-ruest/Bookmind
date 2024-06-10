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
	@Binding var cover: UIImage?
	
	var body: some View {
		if self.cover == nil {
			Color(.background)
				.ignoresSafeArea()
				.brightness(-0.2)
		} else {
			Image(uiImage: self.cover!)
				.resizable()
				.ignoresSafeArea()
				.blur(radius: 8.0)
				.brightness(-0.2)
		}
	}
}
