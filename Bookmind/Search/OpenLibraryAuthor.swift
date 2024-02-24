//
//  OpenLibraryAuthor.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/20/24.
//

import Foundation

/// OpenLibraryAuthor decodes itself from an openlibrary author.
/// We need the name to display the author, but we also need a
/// unique id to map the author to all their books. Since author
/// is the intuitive way to group a library.
///
/// The open library data doesn't seem to include first and last
/// names, and we're expecting to sort authors by last name. We'll
/// parse the author name and ask the user to manually fix any
/// errors in received data.
struct OpenLibraryAuthor: Decodable {
	let key: String
	let name: String
	
	/// Map this decoded open library author data to a swift data
	/// model object that may be persisted.
	var entity: Author {
		Author(olid: self.key, name: self.name)
	}

	/// Return the open library url for author data on the specified key.
	static func url(authorKey: String) -> URL? {
		// key includes "/authors/" prefix
		URL(string: "https://openlibrary.org\(authorKey).json")
	}
}
