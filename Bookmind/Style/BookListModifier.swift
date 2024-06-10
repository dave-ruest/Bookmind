//
//  BookListModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/22/24.
//

import SwiftUI

/// BookListModifier defines an app specific list appearance.
/// Currently a light touch to plain style and separator color
/// but might do more later.
struct BookListModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.listStyle(.plain)
			.listRowSeparatorTint(.accent)
	}
}

extension View {
	/// Apply the "bookmind list" appearance.
	func bookListStyle() -> some View {
		modifier(BookListModifier())
	}
	
	/// Apply the "bookmind list row" appearance.
	func bookListRowStyle() -> some View {
		listRowBackground(Color.background.opacity(BookStyle.opacity))
	}
}

#Preview {
	List {
		ForEach(Author.Preview.allAuthors) { author in
			Text(author.name)
		}
		.bookListRowStyle()
	}
	.bookListStyle()
	.background(.indigo)
}
