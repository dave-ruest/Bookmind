//
//  OwnStateView.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// OwnStateView displays and modifies an own state binding.
struct OwnStateView: View {
	@Binding var state: OwnState
	
	var body: some View {
		Picker("Ownership", selection: self.$state) {
			ForEach(OwnState.allCases) { owned in
				Text(owned.description)
			}
		}
		.bookPickerStyle()
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			OwnStateView(state: .constant(.own))
			OwnStateView(state: .constant(.want))
			OwnStateView(state: .constant(.maybe))
			OwnStateView(state: .constant(.none))
		}
		.padding()
	}
}
