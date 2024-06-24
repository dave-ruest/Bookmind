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
	/// A flag used to present the scan screen. The scan button toggles
	/// this flag, and the scanner remains open while the flag is true.
	@State private var isScanning = false
	/// A property used to present the "scanned book" screen. If the user
	/// taps a valid search result, the book is saved and a screen opened
	/// so the user can edit the new book.
	@State private var selectedScannedBook: Book? = nil
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
						// room for maybe 1-2 more
						// disable for now, continue in a dedicated ticket
						// need to try
//						NavigationLink {
//							SearchScreen(selectedBook: self.$selectedScannedBook)
//						} label: {
//							Label("Search", systemImage: "magnifyingglass.circle.fill")
//								.bookButtonStyle()
//						}
						Button {
							self.isScanning.toggle()
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
			.fullScreenCover(isPresented: self.$isScanning, content: {
				ScanScreen(selectedBook: self.$selectedScannedBook)
			})
			.fullScreenCover(item: self.$selectedScannedBook) { book in
				ScannedBookScreen(book: book)
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
}

#Preview {
	NavigationStack {
		HomeScreen()
	}
	.modelContainer(StorageModel.preview.container)
	.environmentObject(CoverModel())
}
