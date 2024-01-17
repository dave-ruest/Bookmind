//
//  BookButtonModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/7/24.
//

import SwiftUI

/// BookButtonModifier adds a border to the capsule shaped material
/// background applied by BookTextModifier. The similar appearance
/// should add consistency to the button and text on the scanner
/// screen.
struct BookButtonModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.bookText()
			.overlay {
				Capsule()
					.stroke(Color(.label), lineWidth: 2.0)
			}
	}
}

extension View {
	/// A bordered, capsule shaped material background.
	func bookButton() -> some View {
		modifier(BookButtonModifier())
	}
}

#Preview {
	Label("Add Book", systemImage: "book.fill")
		.bookButton()
}
