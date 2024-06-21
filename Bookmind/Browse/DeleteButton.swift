//
//  DeleteButton.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-20.
//

import SwiftUI

/// DeleteButton defines a destructive button appearance consistent with
/// the standard book button style. We use the apple prominent destructive
/// button style (white text on red) but change the font weight, padding,
/// frame and border overlay to match normal buttons.
struct DeleteButton: View {
	/// Code to run when the button is tapped. This is a strong reference so
	/// be careful to use weak references to self to avoid a leak.
	var action: (() -> Void)
	
	@ScaledMetric(relativeTo: .body) private var border = BookStyle.border
	@ScaledMetric(relativeTo: .body) private var padding = BookStyle.padding

	var body: some View {
		Button(role: .destructive, action: self.action, label: {
			Text("Delete")
				.fontWeight(.bold)
				.bookViewFrame()
				.padding(self.padding)
		})
		.buttonStyle(.borderedProminent)
		.buttonBorderShape(.capsule)
		.overlay {
			Capsule()
				.stroke(Color(.accent), lineWidth: self.border)
		}
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			DeleteButton() {}
		}
		.padding()
	}
}
