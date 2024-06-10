//
//  DoneButton.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-08.
//

import SwiftUI

/// DoneButton dismisses the current screen.
struct DoneButton: View {
	@Environment(\.dismiss) var dismiss

	var body: some View {
		Button(action: {
			self.dismiss()
		}, label: {
			Label("Done", systemImage: "arrowshape.backward.fill")
				.bookButtonStyle()
		})
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			DoneButton()
		}
		.padding()
	}
}
