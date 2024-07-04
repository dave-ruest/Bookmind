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
/// book we use the router to show the insert screen.
struct ScanScreen: View {
	/// A model tracking the scanner. We use its published state to
	/// provide feedback on scan progress.
	@StateObject var scanModel = ScanModel()
	/// A model used to search for editions by ISBN. Shared by the scan
	/// and search screens. We *could* make this an environment object
	/// but as with the scanner it's safer and simpler to start fresh.
	@StateObject var searchModel = SearchModel()
	/// An environment object used to navigate between search screens.
	@EnvironmentObject private var router: SearchRouter
	/// A model providing swift data entity specific convenience methods.
	@EnvironmentObject private var storage: StorageModel

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
					SearchProgressView(result: self.$searchModel.result)
				} else {
					Text(self.scanModel.description)
						.bookGroupStyle()
						.multilineTextAlignment(.center)
				}
				if self.scanModel.state == .foundText {
					Button(action: {
						self.router.isScanning = false
						self.router.path.append(SearchRouter.Search())
					}, label: {
						Label("Search", systemImage: "magnifyingglass.circle.fill")
							.bookButtonStyle()
					})
				}
				CancelButton()
			}
			.padding()
		}
		.environmentObject(self.scanModel)
		.onChange(of: self.scanModel.state, initial: false) {
			self.scanModelChanged()
		}
	}
	
	private func scanModelChanged() {
		guard case .found(let isbn) = self.scanModel.state else {
			return
		}
		
		if let stored = Book.fetch(isbn: isbn, storage: self.storage) {
			self.searchModel.result = .found(stored)
			return
		}

		self.searchModel.search(for: isbn)
	}
}

#Preview {
	VStack() {
		ScanScreen()
	}
}

#Preview {
	VStack {
		ScanScreen(scanModel: ScanModel.Preview.foundText)
	}
}

#Preview {
	VStack() {
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
	.environmentObject(CoverModel())
}

#Preview {
	NavigationStack {
		VStack {
			ScanScreen(searchModel: SearchModel.Preview.failed)
			ScanScreen(searchModel: SearchModel.Preview.legend)
		}
	}
	.environmentObject(CoverModel())
}
