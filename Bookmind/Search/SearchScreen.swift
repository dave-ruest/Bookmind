//
//  SearchScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-21.
//

import SwiftUI

/// SearchScreen provides a text search for a book by IBSN, title or author.
/// Currently only ISBN is supported - the screen may be reorganized and will
/// definitely at least be refactored for consistency with the scan screen.
///
/// We *should* do some validation on typed ISBNs to prevent less productive
/// searches. As implemented and stolen from the scan screen, the search
/// expects an exact ISBN match and does not support partials. So we should
/// fix that one way or another.
///
/// As with the scan screen, the search screen has a search model. When the
/// user taps search on the keyboard, we start an ISBN search for the typed
/// text. We display the result of the search in a progress view, whether
/// in progress, failed or a found book. If the user selects a found book
/// we set our binding - this tells the home page to push the "confirm
/// book details" screen.
///
/// Well, currently named the scanned book screen. If both search and scan
/// will use the same screen to edit and save book details, a rename is
/// probably in order. Also currently we insert the book into core data
/// before opening the detail screen. We probably want a save button on
/// the book detail screen, and to only insert then. 
struct SearchScreen: View {
	/// A binding used to navigate between search screens. When the user
	/// selects a book search result, we set the "inserting" book and the
	/// home screen will push the insert book screen.
	@ObservedObject var router: SearchRouter
	/// A model used to search for editions by ISBN. Shared by the scan
	/// and search screens. We *could* make this an environment object
	/// but as with the scanner it's safer and simpler to start fresh.
	@StateObject var searchModel = SearchModel()

	@State private var searchText = ""
	@FocusState private var showKeyboard

	var body: some View {
		ZStack {
			LibraryBackgroundView()
			VStack {
				Spacer()
				if self.searchModel.result != nil {
					SearchProgressView(result: self.$searchModel.result,
									   router: self.router)
				}
				TextField("ISBN", text: self.$searchText)
					.bookTextFieldStyle()
					.keyboardType(.numbersAndPunctuation)
					.autocorrectionDisabled()
					.submitLabel(.search)
					.focused(self.$showKeyboard)
					.onSubmit {
						self.searchTapped()
					}
			}
			.padding()
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Search")
		.onAppear() {
			self.showKeyboard = true
		}
	}
	
	private func searchTapped() {
		if let isbn = ISBN("ISBN " + self.searchText) {
			self.searchModel.search(for: isbn)
		}
	}
}

#Preview {
	NavigationStack {
		SearchScreen(router: SearchRouter(), searchModel: SearchModel.Preview.searching)
	}
}

#Preview {
	NavigationStack {
		SearchScreen(router: SearchRouter(), searchModel: SearchModel.Preview.failed)
	}
}

#Preview {
	NavigationStack {
		SearchScreen(router: SearchRouter(), searchModel: SearchModel.Preview.quiet)
	}
	.environmentObject(CoverModel())
}

#Preview {
	NavigationStack {
		SearchScreen(router: SearchRouter(), searchModel: SearchModel.Preview.legend)
	}
	.environmentObject(CoverModel())
}
