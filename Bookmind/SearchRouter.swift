//
//  SearchRouter.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-29.
//

import SwiftUI

/// SearchRouter specifies navigation between scan, search and insert screens.
final class SearchRouter: ObservableObject {	
	@Published var isScanning = false
	@Published var isSearching = false
	@Published var inserting: Book? = nil
	
	func showInsert(for book: Book) {
		self.isScanning = false
		self.isSearching = false
		self.inserting = book
	}
}
