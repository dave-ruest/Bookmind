//
//  AuthorLabel.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-07-06.
//

import SwiftUI

/// AuthorLabel shows a formatted author name and book count in an
/// hstack. This is used in a couple places, so moving that code here
/// simplifies the calling screens. 
struct AuthorLabel: View {
	private let filter: FilteredAuthor
	
	init(author: Author) {
		self.filter = FilteredAuthor(author)
	}
	
	init(filter: FilteredAuthor) {
		self.filter = filter
	}
	
	var body: some View {
		HStack {
			Text("\(filter.author.firstName) **\(filter.author.lastName)**")
			Spacer()
			if let count = filter.workCount {
				Text("\(count)")
			}
		}
		.bookViewFrame()
	}
}

#Preview {
	VStack {
		AuthorLabel(author: Author.Preview.cain)
		AuthorLabel(author: Author.Preview.dickson)
		AuthorLabel(author: Author.Preview.gemmell)
	}
	.padding()
}
