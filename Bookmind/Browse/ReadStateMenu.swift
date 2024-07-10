//
//  ReadStateMenu.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// ReadStateMenu displays and modifies a read state binding.
struct ReadStateMenu: View {
	@Binding var state: ReadState
	
	var body: some View {
		Menu {
			ForEach(ReadState.allCases) { aState in
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
			Label(self.state.description, systemImage: "book.fill")
				.bookButtonStyle()
		}
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			ReadStateMenu(state: .constant(.none))
			ReadStateMenu(state: .constant(.want))
			ReadStateMenu(state: .constant(.reading))
			ReadStateMenu(state: .constant(.read))
		}
		.padding()
	}
}
