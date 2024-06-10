//
//  ReadStateView.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-07.
//

import SwiftUI

/// ReadStateView displays and modifies a read state binding.
struct ReadStateView: View {
	@Binding var state: ReadState
	
	var body: some View {
		Picker("Ownership", selection: self.$state) {
			ForEach(ReadState.allCases) { state in
				Text(state.description)
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
			ReadStateView(state: .constant(.read))
			ReadStateView(state: .constant(.want))
			ReadStateView(state: .constant(.maybe))
			ReadStateView(state: .constant(.none))
		}
		.padding()
	}
}
