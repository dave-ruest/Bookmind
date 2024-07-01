//
//  CancelButton.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// CancelButton dismisses the current screen.
struct CancelButton: View {
	@Environment(\.dismiss) var dismiss

	var body: some View {
		Button(action: {
			self.dismiss()
		}, label: {
			Label("Cancel", systemImage: "minus.diamond.fill")
				.bookButtonStyle()
		})
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			CancelButton()
		}
		.padding()
	}
}
