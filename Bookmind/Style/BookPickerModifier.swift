//
//  BookPickerModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// BookPickerModifier defines an app specific picker appearance.
/// Sizing should be shared with other view styles, so different view styles
/// have similar heights and widths when stacked together. Background
/// should be shared with other styles as well, for consistency and contrast
/// with the forground color. 
struct BookPickerModifier: ViewModifier {
	@ScaledMetric(relativeTo: .body) private var padding = BookStyle.padding
	
	func body(content: Content) -> some View {
		content
			.pickerStyle(.menu)
			.labelsHidden()
			.bookButtonStyle()
	}
}

extension View {
	/// Apply the "book picker" style. Shares a border with button style
	/// to indicate "tappable" and shares a background with other views
	/// that need contrast with our text color.
	func bookPickerStyle() -> some View {
		modifier(BookPickerModifier())
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			Picker("One", selection: .constant(1)) {
				Text("One")
				Text("Two")
			}
			.bookPickerStyle()
		}
		.padding()
	}
}
