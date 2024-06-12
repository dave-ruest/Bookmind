//
//  BookStyle.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import Foundation
import SwiftUI

/// BookStyle defines constants shared by view styles.
struct BookStyle {
	static var border = 2.0
	// TODO: Adjust for high contrast
	static var opacity = 0.66
	static var padding = 8.0
}

extension View {
	/// Apply a "bookmind" background shared by several view styles.
	/// We want text to float over backgrounds or book covers. But we the
	/// background to provide contrast with the text, so we use the background
	/// color but with some transparency.
	func bookViewBackground() -> some View {
		background(.background.opacity(BookStyle.opacity),
						in: Capsule())
	}
	
	/// Apply a "bookmind" frame shared by several view styles.
	/// We want buttons and pickers to fill the width of the screen, but
	/// not awkwardly wide on tablets, so 400 points max. We want the
	/// height of buttons and pickers to increase for larger text accessibilty
	/// sizes, but not go below 40 points, so we set a min height as well.
	func bookViewFrame() -> some View {
		frame(maxWidth: 400.0, minHeight: 40.0)
	}
}
