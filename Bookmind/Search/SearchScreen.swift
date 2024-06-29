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
	/// A binding used to tell the home screen to show the "insert book"
	/// screen. We'll set this property when the user selects a book result.
	@Binding var insertBook: Book?
	@StateObject var searchModel = SearchModel()

	@State private var foundBook: Book?
	@State private var searchType: SearchType = .ISBN
	@State private var searchText = ""
	@FocusState private var showKeyboard

	var body: some View {
		ZStack {
			LibraryBackgroundView()
			VStack {
				if self.searchModel.result != nil {
					SearchProgressView(result: self.$searchModel.result,
									   foundBook: self.$foundBook,
									   selectedBook: self.$insertBook)
				}
				Spacer()
				VStack {
					Picker("Search", selection: self.$searchType) {
						ForEach(SearchType.allCases) { type in
							Text(type.rawValue)
						}
					}
					.bookPickerStyle()
					TextField(self.searchType.rawValue, text: self.$searchText)
						.keyboardType(self.searchType.keyboardType)
						.submitLabel(.search)
						.focused(self.$showKeyboard)
						.textFieldStyle(.roundedBorder)
						.border(Color.accentColor, width: 1.0)
						.onSubmit {
							self.searchTapped()
						}
				}
				.bookGroupStyle()
			}
			.padding()
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Search")
		.onAppear() {
			self.showKeyboard = true
		}
		.onChange(of: self.searchModel.result, initial: true) {
			self.searchModelChanged()
		}
	}
	
	private func searchModelChanged() {
		if case .found(let book) = self.searchModel.result {
			self.foundBook = book
		}
	}

	private func isSearchDisabled() -> Bool {
		switch self.searchType {
		case .ISBN: return ISBN("ISBN " + self.searchText) == nil
		default: return true
		}
	}
	
	private func searchTapped() {
		if let isbn = ISBN("ISBN " + self.searchText) {
			self.searchModel.search(isbn)
		}
	}
}

private enum SearchType: String, CaseIterable, Identifiable {
	case ISBN
	case Author
	case Title
	
	var id: Self { self }
	
	var keyboardType: UIKeyboardType {
		self == .ISBN ? .numbersAndPunctuation : .namePhonePad
	}
}

#Preview {
	NavigationStack {
		SearchScreen(insertBook: .constant(nil), searchModel: SearchModel.Preview.searching)
	}
}

#Preview {
	NavigationStack {
		SearchScreen(insertBook: .constant(nil), searchModel: SearchModel.Preview.failed)
	}
}

#Preview {
	NavigationStack {
		SearchScreen(insertBook: .constant(nil), searchModel: SearchModel.Preview.quiet)
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}

#Preview {
	NavigationStack {
		SearchScreen(insertBook: .constant(nil), searchModel: SearchModel.Preview.legend)
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}
