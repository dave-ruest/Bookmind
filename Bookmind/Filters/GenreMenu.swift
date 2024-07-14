//
//  GenreMenu.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-07-12.
//

import SwiftUI

/// GenreMenu displays the list of genres. When we add genres as
/// an entity, it will have a many to one relationship with works.
/// We'll update library filter to also filter out any books not
/// in the selected genre.
struct GenreMenu: View {
	var body: some View {
		Menu {
			Text("Coming soon!")
		} label: {
			Text("Genre")
				.fontWeight(.bold)
		}
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack {
			GenreMenu()
		}
		.padding()
	}
}
