//
//  ScanScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/7/24.
//

import SwiftUI

/// ScanScreen presents an overlay above a wrapped data scanner controller.
///
/// In stage one (prove we can scan an ISBN), it identified and displayed
/// a scanned ISBN number. In stage two (fetch book details), on finding a
/// suspected ISBN, we send a book details request to openlibrary and display
/// basic results. Next we'll fetch authors and cover preview.
///
/// When we add persistence in stage ?, the "add" button will save the book,
/// close the screen, and update some kind of book list ui. But for stage two
/// we'll still just close the screen.
struct ScanScreen: View {
	@Environment(\.dismiss) var dismiss
	@StateObject var scanModel = ScanModel()
	@StateObject var searchModel = SearchModel()

	var body: some View {
		ZStack {
			#if targetEnvironment(simulator)
			Color(.background)
				.ignoresSafeArea(.all)
			#else
			ScanView()
				.ignoresSafeArea(.all)
			#endif
			VStack {
				Spacer()
				Text(self.progressMessage)
					.bookText()
				Button(action: {
					self.dismiss()
				}, label: {
					Text(self.buttonTitle)
						.bookButton()
				})
			}
		}
		.environmentObject(self.scanModel)
		.onChange(of: self.scanModel.state) { state in
			if case .found(let isbn) = state {
				self.searchModel.search(isbn: isbn.digitString)
			}
		}
	}
	
	private var buttonTitle: String {
		if case .found(_) = self.searchModel.result {
			return "Add"
		}
		return "Cancel"
	}
	
	private var progressMessage: String {
		let result = searchModel.result
		switch result {
			case .searching(let isbn): return "Searching for \(isbn)..."
			case .found(let book): return book.description
			case .failed(let isbn): return "Could not find book with ISBN \(isbn)"
			case .none: return "Scanning..."
		}
	}
}

#Preview {
	ScanScreen()
}
