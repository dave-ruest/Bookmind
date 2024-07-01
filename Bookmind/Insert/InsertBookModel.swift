//
//  InsertBookModel.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-07-01.
//

import Foundation

/// First pass version for the basic search screen. This
/// restores the basic persistence we had where we merge
/// network search results with stored data and save.
///
/// To support cancel, where we don't save changes, we'll
/// need a method to de-duplicate without saving. We'll also
/// want to update the search model so it queries local
/// storage first, possibly only that if phone is offline.
///
/// Point is, expect drastic changes to this model. 
final class InsertBookModel: ObservableObject {
	let storage: StorageModel
	@Published var book: Book

	@MainActor init(storage: StorageModel, book: Book) {
		self.storage = storage
		self.book = storage.insert(book: book)
	}
}

extension InsertBookModel: Equatable {
	static func == (lhs: InsertBookModel, rhs: InsertBookModel) -> Bool {
		lhs.book == rhs.book
	}
}

extension InsertBookModel: Hashable {
	func hash(into hasher: inout Hasher) {
		self.book.hash(into: &hasher)
	}
}
