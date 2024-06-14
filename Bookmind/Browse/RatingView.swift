//
//  RatingView.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/18/24.
//

import SwiftUI

/// RatingView displays and modifies a rating binding. 
struct RatingView: View {
	@Binding var rating: Int
	
	var body: some View {
		HStack {
			ForEach(1...5, id: \.self) { number in
				Button(action: {
					rating = number
				}, label: {
					Image(systemName: number <= rating 
						  ? "star.fill" : "star")
				})
			}
		}
		.buttonStyle(.plain)
		.bookButtonStyle()
		.dynamicTypeSize(.small ... .accessibility3)
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			RatingView(rating: .constant(0))
			RatingView(rating: .constant(3))
			RatingView(rating: .constant(5))
		}
		.padding()
	}
}
