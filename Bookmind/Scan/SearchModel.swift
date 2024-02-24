//
//  SearchModel.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/14/24.
//

import Combine
import Foundation
import SwiftUI

/// SearchModel manages searches for all ISBNs found during a scan session.
/// The scanner can hop back and forth between a few ISBN candidates. We
/// want to complete each lookup but be careful not to repeat it.
final class SearchModel: ObservableObject {
	@Published var result: BookSearch.Result?
	private var searches: [BookSearch]
	private var cancellable: Cancellable? = nil
	
	init(result: BookSearch.Result? = nil, searches: [BookSearch] = []) {
		self.result = result
		self.searches = searches
	}
	
	func search(isbn: String) {
		// don't repeat a search
		if let completed = self.searches.first(where: { $0.isbn == isbn }) {
			DispatchQueue.main.async {
				self.result = completed.result
			}
			return
		}
		
		let search = OpenLibraryBookSearch(isbn: isbn)
		self.searches.append(search)
		self.cancellable = search.$result
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] result in
				withAnimation {
					self?.result = result
				}
			}
		)
		search.start()
	}
	
	struct Preview {
		static let none = SearchModel()
		static let failed = SearchModel(result: BookSearch.Preview.failed)
		static let searching = SearchModel(result: BookSearch.Preview.searching)
		static let quiet = SearchModel(result: BookSearch.Preview.quiet)
		static let legend = SearchModel(result: BookSearch.Preview.legend)
		static let dorsai = SearchModel(result: BookSearch.Preview.dorsai)
	}
}
