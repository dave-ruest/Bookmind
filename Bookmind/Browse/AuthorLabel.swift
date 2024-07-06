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
	let author: Author
	
	var body: some View {
		HStack {
			Text("\(author.firstName) **\(author.lastName)**")
			Spacer()
			Text("\(author.books.count)")
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
