//
//  HomeScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/1/24.
//

import SwiftData
import SwiftUI

/// HomeScreen is Bookmind's first screen. It shows a friendly welcome
/// message on first launch. Once the user has scanned a book, the home
/// screen shows a list of authors.
struct HomeScreen: View {
	/// A query used to decide if we should show the welcome text.
	@Query var authors: [Author]
	/// An environment object used to navigate between search screens.
	@EnvironmentObject private var router: SearchRouter
	/// The height class environment variable, used in screen layout.
	@Environment(\.verticalSizeClass) private var heightClass
	/// The selection in the library filter menu. Hides authors based
	/// on own or read state of the authors works and editions. 
	@State private var filter = LibraryFilter()

    var body: some View {
		// should be easy to ifdef a different case for ipad
		let AStack = heightClass == .compact
			? AnyLayout(HStackLayout())
			: AnyLayout(VStackLayout())
		
		ZStack {
			LibraryBackgroundView()
			AStack {
				if self.authors.isEmpty {
					ScrollView {
						Text("Bookmind remembers your books.\n\nThe books you've read, the books you own, the books you want...\n\nBookmind remembers them.")
							.bookGroupStyle()
							.padding()
					}
					// hack to prevent the list being visible under the safe area
					// breaks the large title going inline, but better overall
					.padding(.top, 1)
				} else {
					LibraryScreen(filter: self.$filter)
				}
				VStack {
					if !self.authors.isEmpty {
						Button {
							self.router.path.append(SearchRouter.Search())
						} label: {
							Label("Search", systemImage: "magnifyingglass.circle.fill")
								.bookButtonStyle()
						}
					}
					Button {
						self.router.isScanning = true
					} label: {
						Label("Scan ISBN", systemImage: "camera.fill")
							.bookButtonStyle()
					}
				}
				.padding()
			}
			.fullScreenCover(isPresented: self.$router.isScanning) {
				ScanScreen()
			}
			.navigationDestination(for: SearchRouter.Search.self) { _ in 
				SearchScreen()
			}
			.navigationDestination(for: Book.self) { book in
				InsertBookScreen(book: book)
			}
		}
		.navigationBarTitleDisplayMode(.large)
		.navigationTitle("Bookmind")
		.toolbar {
			if !self.authors.isEmpty {
				ToolbarItem(placement: .topBarTrailing) {
					LibraryFilterMenu(filter: self.$filter)
				}
			}
		}
    }
}

#Preview {
	NavigationStack {
		HomeScreen()
	}
	.modelContainer(StorageModel().container)
	.environmentObject(SearchRouter())
}

#Preview {
	NavigationStack {
		HomeScreen()
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
	.environmentObject(SearchRouter())
}
