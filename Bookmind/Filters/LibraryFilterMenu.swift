//
//  LibraryFilterMenu.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-07-10.
//

import SwiftUI

/// LibraryFilterMenu displays the available library filters and
/// updates a binding with the currently selected filter. 
struct LibraryFilterMenu: View {
	@Binding var filter: LibraryFilter
	@State private var filters = [
		LibraryFilter(),
		LibraryFilter(title: "Owned Books", ownState: .own),
		LibraryFilter(title: "Wish List", ownState: .want),
		LibraryFilter(title: "Read Books", readState: .read),
		LibraryFilter(title: "Reading List", readState: .want)
	]
	
	var body: some View {
		Menu {
			ForEach(self.$filters) { aFilter in
				Button {
					self.filter = aFilter.wrappedValue
				} label: {
					if aFilter.wrappedValue == self.filter {
						Label(aFilter.wrappedValue.title, systemImage: "checkmark")
					} else {
						Text(aFilter.wrappedValue.title)
					}
				}
			}
		} label: {
			Label(self.filter.title, systemImage: "books.vertical.fill")
				.bookButtonStyle()
		}
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			LibraryFilterMenu(filter: .constant(LibraryFilter.Preview.authors))
			LibraryFilterMenu(filter: .constant(LibraryFilter.Preview.own))
			LibraryFilterMenu(filter: .constant(LibraryFilter.Preview.read))
		}
		.padding()
	}
}
