//
//  BookListModifier.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/22/24.
//

import SwiftUI

struct BookListModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.listStyle(.plain)
			.listRowSeparatorTint(.accent)
			.background(Color(.background))
	}
}

extension View {
	func bookList() -> some View {
		modifier(BookListModifier())
	}
}

#Preview {
	List {
		ForEach(Author.Preview.allAuthors) { author in
			Text(author.name)
		}
		.listRowBackground(Color.clear)
	}
	.bookList()
}
