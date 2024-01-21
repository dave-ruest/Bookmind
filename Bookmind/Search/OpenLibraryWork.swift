//
//  OpenLibraryWork.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/20/24.
//

import Combine
import Foundation

/// OpenLibraryWork decodes itself from an openlibrary work.
/// A *work* is a meta type representing all the editions of
/// a book. An edition has an ISBN, a work does not.
///
/// We wouldn't be bothering with this but I noticed in testing
/// that several editions did not include authors. Authors was
/// only available in the work. So if the edition does not
/// include authors, we fetch the work, then the authors.
///
/// The authors for a work includes a "type" but in testing
/// I've only seen one type. May need to handle another case
/// there.
struct OpenLibraryWork: Decodable {
	let authors: [[String: [String: String]]]?
	
	static func url(workKey: String) -> URL? {
		// key includes "/works/" prefix
		URL(string: "https://openlibrary.org\(workKey).json")
	}
}
