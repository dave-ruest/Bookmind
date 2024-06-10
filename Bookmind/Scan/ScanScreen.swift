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
	@StateObject var scanModel = ScanModel()
	@StateObject var searchModel = SearchModel()
	
	@State var edition: Edition? = nil
	@State var book: Book? = nil
	@State var authors: [Author] = []

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
				if self.searchModel.result == nil {
					Text(self.scanModel.description)
						.bookGroupStyle()
				}
				if self.edition == nil {
					SearchProgressView(result: self.$searchModel.result)
				}
				EditBookButton(edition: $edition, book: $book, authors: $authors)
				CancelButton()
			}
			.padding()
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Scan Book")
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbarBackground(.background.opacity(BookStyle.opacity), for: .navigationBar)
		.environmentObject(self.scanModel)
		.onChange(of: self.scanModel.state, initial: false) {
			self.scanModelChanged()
		}
		.onChange(of: self.searchModel.result, initial: true) {
			self.searchModelChanged()
		}
	}
	
	private func scanModelChanged() {
		if case .found(let results) = self.scanModel.state {
			self.searchModel.search(results: results)
		}
	}
	
	private func searchModelChanged() {
		if case .found(let edition, let book, let authors) = self.searchModel.result {
			self.edition = edition
			self.book = book
			self.authors = authors
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
	NavigationStack {
		VStack {
			ScanScreen(searchModel: SearchModel.Preview.searching)
			ScanScreen(searchModel: SearchModel.Preview.quiet)
		}
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}

#Preview {
	NavigationStack {
		VStack {
			ScanScreen(searchModel: SearchModel.Preview.failed)
			ScanScreen(searchModel: SearchModel.Preview.legend)
		}
	}
	.modelContainer(StorageModel.preview.container)
}

#Preview {
	NavigationStack {
		ScanScreen(searchModel: SearchModel.Preview.dorsai)
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}
