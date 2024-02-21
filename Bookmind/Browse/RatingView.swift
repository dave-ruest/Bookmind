//
//  RatingView.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/18/24.
//

import SwiftUI

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
		.bookButton()
	}
}

#Preview {
	RatingView(rating: .constant(3))
}
