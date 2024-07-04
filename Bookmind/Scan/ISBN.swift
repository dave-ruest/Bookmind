//
//  ISBN.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/15/24.
//

import Foundation

/// ISBN is used to select valid ISBN numbers from scanned string input.
/// The "better" this check is, the less requests we send to fetch book details,
/// and the less processing we do while the scanner is running.
struct ISBN: Equatable {
	/// The ISBN number as scanned, including -'s but not a prefix.
	/// Mostly for debug purposes.
	let displayString: String
	/// The ISBN digits only, i.e. -'s and prefix removed. Used for
	/// openlibrary edition lookups. We convert 9 digit SBN's to 10
	/// digit ISBN's as some lookups can fail if we don't.
	let digitString: String
	/// The digits in ISBN13 format, used as a unique identifier to
	/// store editions.
	var digitString13: String? {
		if self.digitString.count == 13 { return self.digitString }
		
		var sbn: String
		if self.digitString.count == 9 {
			sbn = "9780" + self.digitString
		} else if self.digitString.count == 10 {
			sbn = "978" + self.digitString
		} else {
			return nil
		}
		// remove check digit
		sbn.removeLast()
		
		// calculate new check digit
		let multipliers = [1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3]
		let digits: [Int] = sbn.compactMap { $0.wholeNumberValue }
		guard digits.count == 12 else { return nil }
		
		var checkSum = 0
		for index in 0..<digits.count {
			checkSum += digits[index] * multipliers[index]
		}
		let remainder = checkSum % 10
		let checkDigit = remainder == 0 ? 0 : 10 - remainder
		
		return sbn + String(checkDigit)
	 }

	private static let validISBN10Characters = CharacterSet(charactersIn: "01234567890xX")
	private static let validISBN13Characters = CharacterSet(charactersIn: "01234567890")

	init?(_ string: String) {
		guard let displayString = Self.firstCode(in: string) else {
			return nil
		}

		self.displayString = displayString
		let components = displayString.components(separatedBy: "-")
		var digits = components.joined()
		guard digits.count == 9 || digits.count == 10 || digits.count == 13 else { return nil }

		let validDigits = digits.count == 10 ? Self.validISBN10Characters : Self.validISBN13Characters
		let characters = CharacterSet(charactersIn: digits)
		guard characters.isSubset(of: validDigits) else {
			return nil
		}

		if digits.count == 9 {
			digits = "0" + digits
		}
		self.digitString = digits
	}

	/// Return the first ISBN code found in string.
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
	
	struct Preview {
		static let prefix = ISBN("text before isbn number SBN 425-03071-7")
		static let suffix = ISBN("SBN 425-03071-7 text after isbn number")
		static let sbn = ISBN("SBN 425-03071-7")
		static let sbn_ = ISBN("SBN-425-03585-9") // really?
		static let isbnx = ISBN("ISBN 0-00-653192-x")
		static let isbnX = ISBN("ISBN 1-55192-756-X")
		static let isbn10 = ISBN("ISBN 0-441-78754-1")
		static let isbn13 = ISBN("ISBN 978-3-16-148410-0")
		static let isbnDash10 = ISBN("ISBN-10 0-7582-8393-8")
		static let isbnDash13 = ISBN("ISBN-13 978-0-7783-3027-1")
		static let isbnDash10Colon = ISBN("ISBN-10: 0-7582-8393-8")
		static let isbnDash13Colon = ISBN("ISBN-13: 978-0-7783-3027-1")
		static let isbnSpace10 = ISBN("ISBN 10 0-7582-8393-8")
		static let isbnSpace13 = ISBN("ISBN 13 978-0-7783-3027-1")
		static let isbnSpace10Colon = ISBN("ISBN 10: 0-7582-8393-8")
		static let isbnSpace13Colon = ISBN("ISBN 13: 978-0-7783-3027-1")
		static let copyright = ISBN("ISBN: 0-441-78754-1")
	}
}

private extension Array where Element == String {
	/// Return the first code (digits and dashes) in the array. Here we check for
	/// a keyword with a space between it and the code, i.e ISBN: 0-441-78754-1
	/// or even the sneakier "ISBN 10: 0-7582-8393-8" with two spaces.
	func firstCodeAfterKeyword() -> String? {
		guard self.count > 1 else { return nil }
		
		if let index = self.firstIndex(of: "ISBN") {
			var code = self[index + 1]
			if ["13", "10", "13:", "10:"].contains(code) && self.count > 2 {
				code = self[index + 2]
			}
			return code
		}
		
		for keyword in ["ISBN-13:", "ISBN-10:", "ISBN-13", "ISBN-10", "ISBN:", "SBN"] {
			if let index = self.firstIndex(of: keyword) {
				return self[index + 1]
			}
		}
		
		return nil
	}
	
	/// Return the first code (digits and dashes) in the array. Here we check for a
	/// prefix stuck to the code without spaces e.g. SBN-425-03585-9.
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
