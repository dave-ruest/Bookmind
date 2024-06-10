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
	private var searches: [OpenLibraryBookSearch] = []
	private var cancellables: [Cancellable] = []
	
	init(result: BookSearch.Result? = nil) {
		self.result = result
	}
	
	func search(results: [ISBN]) {
		let newSearches = results.map { $0.digitString }
		for isbn in newSearches {
			self.search(isbn: isbn)
		}
	}
	
	private func search(isbn: String) {
		// don't seach again for an isbn we've already checked
		if searches.contains(where: { $0.isbn == isbn } ) {
			return
		}
		
		let search = OpenLibraryBookSearch(isbn: isbn)
		self.searches.append(search)
		self.cancellables.append(
			search.$result
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] result in
				withAnimation {
					self?.update(result: result)
				}
			})
		)
		search.start()
	}
	
	private func update(result: BookSearch.Result) {
		if case .found(_, _, _) = result {
			// a new success result, update
			self.result = result
		} else if case .found(_, _, _) = self.result {
			// otherwise, a failed or searching result, when we already had a success
			// ignore the fail and keep showing the match
			return
		} else  {
			self.result = result
		}
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
