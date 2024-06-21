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
/// The scan screen also has a search model. 
struct ScanScreen: View {
	@Binding var selectedBook: Book?

	@StateObject var scanModel = ScanModel()
	@StateObject var searchModel = SearchModel()
	@State private var foundBook: Book?
	
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
				} else {
					SearchProgressView(result: self.$searchModel.result,
									   foundBook: self.$foundBook,
									   selectedBook: self.$selectedBook)
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
