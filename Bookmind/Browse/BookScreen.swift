//
//  BookScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/27/24.
//

import SwiftUI

struct BookScreen: View {
	@EnvironmentObject var bookModel: BookModel

	var body: some View {
		List(self.bookModel.books) {
			BookRow(book: $0)
		}
		.listStyle(.plain)
		.background(Color.background)
	}
}

#Preview {
	BookScreen()
		.environmentObject(BookModel.preview)
}
