//
//  ISBN.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/15/24.
//

import Foundation

/// ISBN is used to select valid ISBN numbers from scanned string input.
/// The "better" this check is, the less requests we send to fetch book details,
/// and the less processing we do while the scanner is running. We should probably
/// add that checksum calculation.
struct ISBN: Equatable {
	let displayString: String
	let digitString: String
	
	private static let validISBNCharacters = CharacterSet(charactersIn: "01234567890-xX")
	
	init?(_ string: String) {
		guard let displayString = Self.firstCode(in: string) else {
			return nil
		}

		self.displayString = displayString
		let characters = CharacterSet(charactersIn: displayString)
		guard characters.isSubset(of: Self.validISBNCharacters) else {
			return nil
		}
		
		let components = displayString.components(separatedBy: "-")
		let digits = components.joined()
		guard digits.count == 9 || digits.count == 10 || digits.count == 13 else {
			return nil
		}
		
		self.digitString = digits
	}
	
	private static func firstCode(in string: String) -> String? {
		guard string.count >= 9 else { return nil }
		
		let words = string.components(separatedBy: CharacterSet.whitespacesAndNewlines)
		if let code = words.firstCodeAfterKeyword() {
			return code
		} else if let code = words.firstCodeWithPrefix() {
			return code
		}
		
		return nil
	}
	
	private static func firstPrefix(in words: [String]) -> Int? {
		// yeah this is a bit ridiculous for if/else cases
		for prefix in ["ISBN-13:", "ISBN-10:", "ISBN:", "ISBN", "SBN"] {
			if let index = words.firstIndex(of: prefix) {
				return index
			}
		}
		return nil
	}
	
	struct Preview {
		static let prefix = ISBN("text before isbn number SBN 425-03071-7")
		static let suffix = ISBN("SBN 425-03071-7 text after isbn number")
		static let sbn = ISBN("SBN 425-03071-7")
		static let sbn_ = ISBN("SBN-425-03585-9") // really?
		static let isbnx = ISBN("ISBN 0-00-653192-x")
		static let isbnX = ISBN("ISBN 1-55192-756-X")
		static let isbn10 = ISBN("ISBN 0-441-78754-1")
		static let isbn13 = ISBN("ISBN 978-3-16-148410-0")
		static let isbn_10 = ISBN("ISBN-10: 0-7582-8393-8")
		static let isbn_13 = ISBN("ISBN-13: 978-0-7783-3027-1")
		static let copyright = ISBN("ISBN: 0-441-78754-1")
	}
}

private extension Array where Element == String {
	func firstCodeAfterKeyword() -> String? {
		for keyword in ["ISBN-13:", "ISBN-10:", "ISBN:", "ISBN", "SBN"] {
			if let index = self.firstIndex(of: keyword) {
				if self.count > index + 1 {
					let code = self[index + 1]
					if code.count > 9 || code.count < 20 {
						return code
					}
				}
			}
		}
		return nil
	}
	
	func firstCodeWithPrefix() -> String? {
		for prefix in ["SBN-"] {
			if let word = self.first(where: { $0.hasPrefix(prefix) }) {
				let code = String(word.dropFirst(prefix.count))
				if code.count > 9 || code.count < 20 {
					return code
				}
			}
		}
		return nil
	}
}
