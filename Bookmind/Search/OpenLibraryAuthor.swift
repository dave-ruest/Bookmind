//
//  OpenLibraryAuthor.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/20/24.
//

import Combine
import Foundation

/// OpenLibraryAuthor decodes itself from an openlibrary author.
/// We really just need the name so we can show one string to the
/// user with all the author names.
struct OpenLibraryAuthor: Decodable {
	let name: String
	let photos: [Int]?
	let birth_date: String?
	let death_date: String?

	static func url(authorKey: String) -> URL? {
		// key includes "/authors/" prefix
		URL(string: "https://openlibrary.org\(authorKey).json")
	}
}
