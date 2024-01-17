//
//  OpenLibraryBookSearch.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/17/24.
//

import Combine
import Foundation

/// Searches for book details on a specific ISBN on the openlibrary site.
final class OpenLibraryBookSearch: BookSearch {
	private var tasks: [AnyCancellable] = []
	
	func start() {
		let url = URL(string: "https://openlibrary.org/isbn/\(isbn).json")
		guard let url else {
			print("Invalid URL \(String(describing: url?.absoluteString))")
			self.result = .failed(self.isbn)
			return
		}
		
		tasks.append(
			URLSession.shared.dataTaskPublisher(for: url)
				.tryMap() { return try self.validate($0.data) }
				.decode(type: OpenLibraryBook.self, decoder: JSONDecoder())
				.receive(on: DispatchQueue.main)
				.sink(receiveCompletion: { error in self.completed(error)},
					  receiveValue: { self.received($0) })
		)
	}
	
	private func validate(_ data: Data) throws -> Data {
		print("Validate scan data: \(data.count) bytes")
		guard data.count > 2 else {
			throw URLError(.zeroByteResource)
		}
		return data
	}
	
	private func received(_ result: OpenLibraryBook) {
		print("Scan received book \(result.book)")
		self.result = .found(result.book)
		// TODO: start author and cover searches
	}
	
	private func completed(_ error: Subscribers.Completion<Error>) {
		print("Scan completed with error \(error)")
		switch error {
			case .failure: self.result = .failed(self.isbn)
			case .finished: return
		}
	}
}
