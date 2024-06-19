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
	@Binding var selectedBook: Book?

	@StateObject var scanModel = ScanModel()
	@StateObject var searchModel = SearchModel()
	@State private var scannedBook: Book?
	
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var storage: StorageModel

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
				if self.scannedBook == nil {
					SearchProgressView(result: self.$searchModel.result)
				} else {
					Button {
						self.didSelectBook()
					} label: {
						BookButtonLabel(book: self.scannedBook!)
					}
				}
				CancelButton()
			}
			.padding()
		}
		.environmentObject(self.scanModel)
		.onChange(of: self.scanModel.state, initial: false) {
			self.scanModelChanged()
		}
		.onChange(of: self.searchModel.result, initial: true) {
			self.searchModelChanged()
		}
	}
	
	private func scanModelChanged() {
		if case .found(let isbn) = self.scanModel.state {
			self.searchModel.search(isbn)
		}
	}
	
	private func searchModelChanged() {
		if case .found(let book) = self.searchModel.result {
			print("ScanScreen searchModelChanged, found result \(String(describing: self.searchModel.result))")
			self.scannedBook = book
		} else {
			print("ScanScreen searchModelChanged, not found result \(String(describing: self.searchModel.result))")
		}
	}
	
	private func didSelectBook() {
		self.dismiss()
		guard let scannedBook else { return }
		self.selectedBook = self.storage.insert(book: scannedBook)
	}
}

#Preview {
	VStack {
		ScanScreen(selectedBook: .constant(nil))
		ScanScreen(selectedBook: .constant(nil), scanModel: ScanModel.Preview.failed)
		ScanScreen(selectedBook: .constant(nil), scanModel: ScanModel.Preview.found)
	}
}

#Preview {
	NavigationStack {
		VStack {
			ScanScreen(selectedBook: .constant(nil), searchModel: SearchModel.Preview.searching)
			ScanScreen(selectedBook: .constant(nil), searchModel: SearchModel.Preview.quiet)
		}
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}

#Preview {
	NavigationStack {
		VStack {
			ScanScreen(selectedBook: .constant(nil), searchModel: SearchModel.Preview.failed)
			ScanScreen(selectedBook: .constant(nil), searchModel: SearchModel.Preview.legend)
		}
	}
	.modelContainer(StorageModel.preview.container)
}

#Preview {
	NavigationStack {
		ScanScreen(selectedBook: .constant(nil), searchModel: SearchModel.Preview.dorsai)
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}
