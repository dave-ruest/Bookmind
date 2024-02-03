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
/// basic results. Stage 2b fetches authors. Stage 2c fetches covers.
///
/// In stage 3 we've added basic persistence. The "add" button actually
/// saves the book and its authors. The home screen hides its welcome
/// message and instead shows a list of authors.
struct ScanScreen: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var storage: StorageModel
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
			VStack(spacing: 16.0) {
				Spacer()
				if case .found(let book, let authors) = self.searchModel.result {
					SearchResultView(book: book, authors: authors)
				} else {
					Text(self.progressMessage)
						.bookResult()
				}
				VStack(spacing: 16.0) {
					if self.book != nil {
						Button(action: {
							self.add()
						}, label: {
							Label("Add", systemImage: "plus.circle.fill")
								.bookButton()
						})
					}
					Button(action: {
						self.dismiss()
					}, label: {
						Label("Cancel", systemImage: "delete.left.fill")
							.bookButton()
					})
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Add Book")
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbarBackground(.thinMaterial, for: .navigationBar)
		.environmentObject(self.scanModel)
		.onChange(of: self.scanModel.state, initial: false) {
			if case .found(let isbn) = self.scanModel.state {
				self.searchModel.search(isbn: isbn.digitString)
			}
		}
	}
	
	private func add() {
		if case .found(let book, let authors) = self.searchModel.result {
			self.storage.add(book: book, authors: authors)
		}
		self.dismiss()
	}
	
	private var book: Book? {
		if case .found(let book, _) = self.searchModel.result {
			return book
		}
		return nil
	}
	
	private var previewImage: UIImage? {
		switch self.searchModel.result {
			case .found(let book, _): return book.cover
			default: return nil
		}
	}
	
	private var progressMessage: String {
		let result = searchModel.result
		switch result {
			case .searching(let isbn): 
				return "Searching for \(isbn)..."
			case .found(let book, _):
				return book.description
			case .failed(let isbn): 
				return "Could not find book with ISBN \(isbn)"
			case .none: 
				return self.scanModel.description
		}
	}
}

#Preview {
	VStack {
		ScanScreen()
		ScanScreen(scanModel: ScanModel.Preview.failed)
		ScanScreen(scanModel: ScanModel.Preview.found)
	}
}

#Preview {
	VStack {
		ScanScreen(searchModel: SearchModel.Preview.searching)
		ScanScreen(searchModel: SearchModel.Preview.quiet)
	}
	.modelContainer(StorageModel.preview.container)
}

#Preview {
	VStack {
		ScanScreen(searchModel: SearchModel.Preview.failed)
		ScanScreen(searchModel: SearchModel.Preview.legend)
	}
	.modelContainer(StorageModel.preview.container)
}

#Preview {
	NavigationStack {
		ScanScreen(searchModel: SearchModel.Preview.dorsai)
	}
	.modelContainer(StorageModel.preview.container)
}
