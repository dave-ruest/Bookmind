//
//  BookTextModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/7/24.
//

import SwiftUI

/// BookTextModifier applies a capsule shaped material background to
/// a text view. The material background should work nicely over
/// a scanner screen.
struct BookTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding()
			.frame(maxWidth: 330)
			.background(.regularMaterial)
			.clipShape(Capsule())
			.fontWeight(.medium)
	}
}

extension View {
	/// A capsule shaped material background.
	func bookText() -> some View {
		modifier(BookTextModifier())
	}
}

#Preview {
	Label("Browse", systemImage: "book.fill")
		.bookText()
}
