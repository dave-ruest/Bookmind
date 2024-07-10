//
//  OwnStateMenu.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// OwnStateMenu displays and modifies an own state binding.
struct OwnStateMenu: View {
	@Binding var state: OwnState
	
	var body: some View {
		Menu {
			ForEach(OwnState.allCases) { aState in
				Button {
					self.state = aState
				} label: {
					if aState == self.state {
						Label(aState.description, systemImage: "checkmark")
					} else {
						Text(aState.description)
					}
				}
			}
		} label: {
			Label(self.state.description, systemImage: "book.closed.fill")
				.bookButtonStyle()
		}
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			OwnStateMenu(state: .constant(.none))
			OwnStateMenu(state: .constant(.want))
			OwnStateMenu(state: .constant(.own))
		}
		.padding()
	}
}
