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
	/// Updated by the editable modifier when edit mode changes.
	@State private var isEditing = false

    var body: some View {
		// should be easy to ifdef a different case for ipad
		let AStack = heightClass == .compact
			? AnyLayout(HStackLayout())
			: AnyLayout(VStackLayout())
		
		ZStack {
			Color(.background)
				.ignoresSafeArea()
			AStack {
				if self.authors.isEmpty {
					ScrollView {
						Text("Bookmind remembers your books.\n\nThe books you own, the books you want, the books you didn't like...\n\nBookmind remembers them all.")
							.bookGroupStyle()
							.padding()
					}
				} else {
					LibraryScreen()
				}
				if !self.isEditing {
					VStack {
						Button {
							self.router.path.append(SearchRouter.Search())
						} label: {
							Label("Search", systemImage: "magnifyingglass.circle.fill")
								.bookButtonStyle()
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
			}
			.animation(.smooth, value: self.isEditing)
			.editable(self.$isEditing)
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
    }
}

#Preview {
	NavigationStack {
		HomeScreen()
			.modelContainer(StorageModel().container)
	}
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
