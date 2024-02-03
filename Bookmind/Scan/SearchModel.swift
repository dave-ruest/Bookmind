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
		static let searching = SearchModel(result: .searching("9781841498584"))
		static let failed = SearchModel(result: .failed("9781841498584"))
		static let quiet = SearchModel(result: .found(Book.Preview.quiet, [Author.Preview.cain]))
		static let legend = SearchModel(result: .found(Book.Preview.legend, [Author.Preview.gemmell]))
		static let dorsai = SearchModel(result: .found(Book.Preview.dorsai, [Author.Preview.dickson]))
	}
}
