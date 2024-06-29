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
	/// A binding used to navigate between search screens. When the user
	/// selects a book search result, we set the "inserting" book and the
	/// home screen will push the insert book screen.
	@ObservedObject var router: SearchRouter
	/// A model tracking the scanner. We use its published state to
	/// provide feedback on scan progress.
	@StateObject var scanModel = ScanModel()
	/// A model used to search for editions by ISBN. Shared by the scan
	/// and search screens. We *could* make this an environment object
	/// but as with the scanner it's safer and simpler to start fresh.
	@StateObject var searchModel = SearchModel()
	
	@Environment(\.dismiss) private var dismiss

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
									   router: self.router)
				} else {
					Text(self.scanModel.description)
						.bookGroupStyle()
						.multilineTextAlignment(.center)
				}
				if self.scanModel.state == .foundText {
					Button(action: {
						self.router.isScanning = false
						self.router.isSearching = true
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
		if case .found(let isbn) = self.scanModel.state {
			self.searchModel.search(for: isbn)
		}
	}
}

#Preview {
	VStack() {
		ScanScreen(router: SearchRouter())
	}
}

#Preview {
	VStack {
		ScanScreen(router: SearchRouter(), scanModel: ScanModel.Preview.foundText)
	}
}

#Preview {
	VStack() {
		ScanScreen(router: SearchRouter(), scanModel: ScanModel.Preview.failed)
		ScanScreen(router: SearchRouter(), scanModel: ScanModel.Preview.found)
	}
}

#Preview {
	NavigationStack {
		VStack {
			ScanScreen(router: SearchRouter(), searchModel: SearchModel.Preview.searching)
			ScanScreen(router: SearchRouter(), searchModel: SearchModel.Preview.quiet)
		}
	}
	.environmentObject(CoverModel())
}

#Preview {
	NavigationStack {
		VStack {
			ScanScreen(router: SearchRouter(), searchModel: SearchModel.Preview.failed)
			ScanScreen(router: SearchRouter(), searchModel: SearchModel.Preview.legend)
		}
	}
	.environmentObject(CoverModel())
}
