//
//  BookButtonModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/7/24.
//

import SwiftUI

/// BookButtonModifier defines an app specific button appearance.
/// Sizing should be shared with other view styles, so different view styles
/// have similar heights and widths when stacked together. Background
/// should be shared with other styles as well, for consistency and contrast
/// with the forground color. 
struct BookButtonModifier: ViewModifier {
	@ScaledMetric(relativeTo: .body) private var borderWidth = 2.0
	@ScaledMetric(relativeTo: .body) private var padding = BookStyle.padding

	func body(content: Content) -> some View {
		content
			.fontWeight(.bold)
			.bookViewFrame()
			.padding(self.padding)
			.bookViewBackground()
			.overlay {
				Capsule()
					.stroke(Color(.accent), lineWidth: self.borderWidth)
			}
	}
}

extension View {
	/// Apply the "bookmind button" appearance. Should be used by as many
	/// tappable controls as possible (buttons, pickers) as an extra clue
	/// that the view can be tapped.
	func bookButtonStyle() -> some View {
		modifier(BookButtonModifier())
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			Label("Scan Book", systemImage: "camera.fill")
				.bookButtonStyle()
			Label("Save Book", systemImage: "square.and.arrow.down.fill")
				.bookButtonStyle()
			Label("Edit Book", systemImage: "book.fill")
				.bookButtonStyle()
		}
			.padding()
	}
}
