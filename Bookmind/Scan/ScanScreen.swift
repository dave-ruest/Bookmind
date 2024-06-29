//
//  ScanScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/7/24.
//

import SwiftUI

/// ScanScreen presents an overlay above a wrapped data scanner controller.
/// The scan and search process is surprisingly complex, so the behavior is
/// distributed to several subviews.
///
/// First, scanning. The scan screen has a scan model, which is updated by
/// the wrapped scan controller in the ScanView. The scan screen shows
/// status messages for the scan model in a simple text view. When an ISBN
/// is found, we move to search.
///
/// The scan screen also has a search model. When we detect something we're
/// reasonably sure is an ISBN, we start a search. The search result is shown
/// in our search progress view, including a found book. If the user taps the
/// book we pass that back to the home screen via our selected book binding.
struct ScanScreen: View {
	/// A binding used to tell the home screen to show the "insert book"
	/// screen. We'll set this property when the user selects a book result.
	@Binding var insertBook: Book?
	@StateObject var scanModel = ScanModel()
	@StateObject var searchModel = SearchModel()
	
	@State private var foundBook: Book?
	
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var storage: StorageModel

	var body: some View {
		ZStack {
			#if targetEnvironment(simulator)
			Color(.systemIndigo)
				.ignoresSafeArea(.all)
			#else
			ScanView()
				.ignoresSafeArea(.all)
			#endif
			VStack() {
				Spacer()
				if self.searchModel.result != nil {
					SearchProgressView(result: self.$searchModel.result,
									   foundBook: self.$foundBook,
									   selectedBook: self.$insertBook)
				} else {
					Text(self.scanModel.description)
						.bookGroupStyle()
						.multilineTextAlignment(.center)
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
			self.foundBook = book
		}
	}
}

#Preview {
	VStack() {
		ScanScreen(insertBook: .constant(nil))
	}
}

#Preview {
	VStack {
		ScanScreen(insertBook: .constant(nil), scanModel: ScanModel.Preview.foundText)
	}
}

#Preview {
	VStack() {
		ScanScreen(insertBook: .constant(nil), scanModel: ScanModel.Preview.failed)
		ScanScreen(insertBook: .constant(nil), scanModel: ScanModel.Preview.found)
	}
}

#Preview {
	NavigationStack {
		VStack {
			ScanScreen(insertBook: .constant(nil), searchModel: SearchModel.Preview.searching)
			ScanScreen(insertBook: .constant(nil), searchModel: SearchModel.Preview.quiet)
		}
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}

#Preview {
	NavigationStack {
		VStack {
			ScanScreen(insertBook: .constant(nil), searchModel: SearchModel.Preview.failed)
			ScanScreen(insertBook: .constant(nil), searchModel: SearchModel.Preview.legend)
		}
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}
