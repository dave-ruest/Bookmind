//
//  BookGroupModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/7/24.
//

import SwiftUI

/// BookGroupModifier defines a "group" appearance. This should
/// be applied to stacks that group several other views, but want
/// a shared overlay to contrast their text against a backround.
struct BookGroupModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.bookViewFrame()
			.padding(16.0)
			.background(.background.opacity(BookStyle.opacity))
			.cornerRadius(16.0)
	}
}

extension View {
	/// Apply the bookmind "group" styling. This uses the shared
	/// background for text contrast over a book cover background
	/// and some sizing consistent with buttons and pickers.
	func bookGroupStyle() -> some View {
		modifier(BookGroupModifier())
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			VStack(spacing: 8.0) {
				Text("Stormbringer")
					.font(.title)
				Text("Michael Moorcock")
			}
			.bookGroupStyle()
		}
		.padding()
	}
}
