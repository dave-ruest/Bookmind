//
//  OpenLibraryBookSearch.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/17/24.
//

import Combine
import Foundation
import UIKit

/// Searches for book details on a specific ISBN on the openlibrary site.
///
/// First is finding the book by its ISBN. This gets us the title, subtitle
/// etc. Trickier is the authors, we need to send 1-2 additional requests to
/// get author names. Finally, covers, which are fetched in parallel with
/// author names.
final class OpenLibraryBookSearch: BookSearch {
	private var cancellables: [AnyCancellable] = []
	private var book: Book!
	private var authors = [OpenLibraryAuthor]()
	
	// MARK: - Book Fetch by ISBN
	func start() {
		guard let url = OpenLibraryBook.url(isbn: self.isbn) else {
			self.result = .failed(self.isbn)
			return
		}
		cancellables.append(
			FetchTask(url: url)
				.start<OpenLibraryBook>(found: { [weak self] in
					self?.received(book: $0)
				},
				completed: { [weak self] error in
					self?.completed(with: error)
				})
		)
	}
	
	private func received(book: OpenLibraryBook) {
		self.book = book.entity
		
		if let authors = book.authors {
			self.fetch(authors: authors)
		} else {
			self.fetch(works: book.works)
		}
		self.fetchCover(book)
		
		self.result = .found(self.book, [Author]())
	}
	
	private func completed(with error: Subscribers.Completion<Error>) {
		switch error {
			case .failure: self.result = .failed(self.isbn)
			case .finished: return
		}
	}
	
	// MARK: - Author Fetch
	
	private func fetch(authors: [[String: String]]) {
		for entry in authors {
			if let authorKey = entry["key"] {
				self.fetch(authorKey: authorKey)
			}
		}
	}
	
	private func fetch(authorKey: String) {
		guard let url = OpenLibraryAuthor.url(authorKey: authorKey) else { return }
		cancellables.append(
			FetchTask(url: url)
				.start<OpenLibraryAuthor>(found: { [weak self] in
					self?.received(author: $0)
				})
		)
	}
	
	private func received(author: OpenLibraryAuthor) {
		self.authors.append(author)
		let entities = self.authors.map { $0.entity }
		self.result = .found(self.book, entities)
	}

	// MARK: - Work Fetch
	
	private func fetch(works: [[String: String]]?) {
		// recent entries seem to include the author only in the work
		// if the work is missing as well, we'll have to leave authors blank
		// and allow the user to enter their own value
		guard let works else { return }
		for entry in works {
			if let workKey = entry["key"] {
				self.fetch(workKey: workKey)
				// let's hope we don't need to request multiple works
				return
			}
		}
	}
	
	private func fetch(workKey: String) {
		guard let url = OpenLibraryWork.url(workKey: workKey) else { return }
		cancellables.append(
			FetchTask(url: url)
				.start(found: { [weak self] in
					self?.received(work: $0)
				})
		)
	}
	
	private func received(work: OpenLibraryWork) {
		// if the work is also missing authors, user will have to add
		// this information themselves
		guard let authors = work.authors else { return }
		for author in authors {
			if let authorKey = author["author"]?["key"] {
				self.fetch(authorKey: authorKey)
			}
		}
	}
	
	// MARK: - Cover Fetch
	
	private func fetchCover(_ book: OpenLibraryBook) {
		// recent entries seem to include the author only in the work
		// if the work is missing as well, we'll have to leave authors blank
		// and allow the user to enter their own value
		guard let url = book.coverURL else { return }
		cancellables.append(
			FetchTask(url: url)
				.start(found: { [weak self] image in
					self?.received(cover: image)
				})
		)
	}
	
	private func received(cover: UIImage) {
		self.book.cover = cover
		let entities = self.authors.map { $0.entity }
		self.result = .found(book, entities)
	}
}
