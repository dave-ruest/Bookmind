//
//  BookTextFieldModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-07-02.
//

import SwiftUI

/// BookTextFieldModifier defines an app specific text field appearance.
/// Frame size is shared with other buttons and groups, so padding, height
/// and widths are similar when stacked. Border is similar to button,
/// hopefully indicating a "tappable" element. But the border is rounded,
/// not capsule, hopefully indicating this is different from a button.
struct BookTextFieldModifier: ViewModifier {
	@ScaledMetric(relativeTo: .body) private var border = BookStyle.border
	@ScaledMetric(relativeTo: .body) private var padding = BookStyle.padding
	
	func body(content: Content) -> some View {
		content
			.padding(EdgeInsets(top: self.padding, leading: self.padding * 2, bottom: self.padding, trailing: self.padding * 2))
			.bookViewFrame()
			.background(.background.opacity(0.75),
						in: RoundedRectangle(cornerRadius: 8.0))
			.overlay {
				RoundedRectangle(cornerRadius: 8.0)
					.stroke(Color(.accent), lineWidth: self.border)
			}
	}
}

extension View {
	/// Apply the "bookmind text field" apperance. Indicates tappable,
	/// but slightly different from buttons and pickers.
	func bookTextFieldStyle() -> some View {
		modifier(BookTextFieldModifier())
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack {
			TextField("ISBN", text: .constant("444-44444-444-4"))
				.bookTextFieldStyle()
			TextField("First Name", text: .constant(""))
				.bookTextFieldStyle()
			TextField("Last Name", text: .constant(""))
				.bookTextFieldStyle()
			TextField("Title", text: .constant("Dune"))
				.bookTextFieldStyle()
		}
			.padding()
	}
}
