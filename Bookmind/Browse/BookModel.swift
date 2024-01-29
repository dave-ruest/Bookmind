//
//  BookModel.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/28/24.
//

import Foundation

final class BookModel: ObservableObject {
	@Published var books: [Book]
	
	init(books: [Book] = [Book]()) {
		self.books = books
	}

	static let preview = BookModel(books: Book.Preview.allBooks)
}
