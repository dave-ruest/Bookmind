//
//  OpenLibraryBookSearch.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/17/24.
//

import Combine
import Foundation

/// Searches for book details on a specific ISBN on the openlibrary site.
///
/// First is finding the book by its ISBN. This gets us the title, subtitle
/// etc. Trickier is the authors, we need to send 1-2 additional requests to
/// get author names. Finally, covers, which are fetched in parallel with
/// author names.
final class OpenLibraryBookSearch: BookSearch {
	private var cancelables: [AnyCancellable] = []
	private var edition: Edition!
	private var work: Work!
	private var authors = [OpenLibraryAuthor]()
	
	// MARK: - Work Fetch by ISBN
	func start() {
		guard let url = OpenLibraryEdition.url(isbn: self.isbn) else {
			self.result = .failed(self.isbn)
			return
		}
		cancelables.append(
			FetchTask(url: url)
				.start<OpenLibraryEdition>(found: { [weak self] in
					self?.received(edition: $0)
				},
				completed: { [weak self] error in
					self?.completed(with: error)
				})
		)
	}
	
	private func received(edition: OpenLibraryEdition) {
		self.edition = edition.entity
		guard let work = edition.work else {
			self.result = .failed("Could not find work for ISBN \(self.edition.isbn)")
			return
		}
		self.work = work
		let book = Book(edition: self.edition, work: work, authors: [Author]())
		self.result = .found(book)

		if let authors = edition.authors {
			print("fetching edition authors")
			self.fetch(authors: authors)
		} else {
			print("fetching work authors")
			self.fetch(works: edition.works)
		}
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
		guard let url = OpenLibraryAuthor.url(authorKey: authorKey) else {
			print("invalid author key \(authorKey)")
			return
		}
		self.cancelables.append(
			FetchTask(url: url)
				.start<OpenLibraryAuthor>(found: { [weak self] in
					self?.received(author: $0)
				})
		)
	}
	
	private func received(author: OpenLibraryAuthor) {
		print("received author \(author.name)")
		self.authors.append(author)
		let entities = self.authors.map { $0.entity }
		let book = Book(edition: self.edition, work: self.work, authors: entities)
		self.result = .found(book)
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
		self.cancelables.append(
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
}
