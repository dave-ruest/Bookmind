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
	
	private static let characters = CharacterSet(charactersIn: "ISBN01234567890 -")
	private static let separators = CharacterSet(charactersIn: "ISBN -")
	
	init?(_ string: String) {
		guard string.count >= 9 && string.count <= 22 else { return nil }
		
		self.displayString = string
		let characters = CharacterSet(charactersIn: string)
		guard characters.isSubset(of: Self.characters) else {
			return nil
		}
		
		let components = string.components(separatedBy: Self.separators)
		let digits = components.joined()
		guard digits.count == 9 || digits.count == 10 || digits.count == 13 else {
			return nil
		}
		
		self.digitString = digits
	}
}
