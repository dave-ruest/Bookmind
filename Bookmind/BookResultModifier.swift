//
//  BookResultModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/7/24.
//

import SwiftUI

/// BookResultModifier applies a capsule shaped material background to
/// a text view. The material background should work nicely over
/// a scanner screen.
struct BookResultModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding()
			.frame(maxWidth: 330)
			.background(.regularMaterial)
			.cornerRadius(24.0)
	}
}

extension View {
	/// A capsule shaped material background.
	func bookResult() -> some View {
		modifier(BookResultModifier())
	}
}

#Preview {
	Text("Stormbringer\nISBN 978-3-16-148410-0")
		.bookResult()
}
