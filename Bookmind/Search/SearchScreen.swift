//
//  SearchScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-21.
//

import SwiftUI

struct SearchScreen: View {
	@State private var searchType: SearchType = .ISBN
	@State private var searchText = ""

	var body: some View {
		ZStack {
			LibraryBackgroundView()
			VStack {
				Spacer()
				VStack {
					Picker("Search", selection: self.$searchType) {
						ForEach(SearchType.allCases) { type in
							Text(type.rawValue)
						}
					}
					.pickerStyle(.segmented)
					TextField("ISBN", text: self.$searchText)
						.textFieldStyle(.roundedBorder)
						.border(Color.accentColor, width: 1.0)
				}
				.bookGroupStyle()
				Button {

				} label: {
					Label("Search", systemImage: "magnifyingglass.circle.fill")
				}
				.bookButtonStyle()
			}
			.padding()
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Search")
	}
}

private enum SearchType: String, CaseIterable, Identifiable {
	case ISBN
	case Author
	case Title
	
	var id: Self { self }
}

#Preview {
	NavigationStack {
		SearchScreen()
	}
}
