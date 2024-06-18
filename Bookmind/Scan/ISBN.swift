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
	
	private static let validISBNCharacters = CharacterSet(charactersIn: "01234567890-")
	
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
		var index = words.firstIndex(of: "ISBN:")
		if index == nil {
			index = words.firstIndex(of: "ISBN")
		}
		if index == nil {
			index = words.firstIndex(of: "SBN")
		}
		guard let index else { return nil }
		guard words.count > index + 1 else { return nil }
		
		let code = words[index + 1]
		guard code.count > 9 && code.count < 20 else { return nil }
		
		return code
	}
	
	struct Preview {
		static let prefix = ISBN("text before isbn number SBN 425-03071-7")
		static let suffix = ISBN("SBN 425-03071-7 text after isbn number")
		static let sbn = ISBN("SBN 425-03071-7")
		static let isbn10 = ISBN("ISBN 0-441-78754-1")
		static let isbn13 = ISBN("ISBN 978-3-16-148410-0")
		static let copyright = ISBN("ISBN: 0-441-78754-1")
	}
}
