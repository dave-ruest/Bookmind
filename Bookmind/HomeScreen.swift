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
/// screen shows a list of authors. With basic persistence implemented
/// that list will remain populated on next launch. 
struct HomeScreen: View {
	@Query var authors: [Author]
	@State private var isScanning = false
	@State private var selectedScannedBook: Book? = nil
	
    var body: some View {
		ZStack {
			Color(.background)
				.ignoresSafeArea()
			VStack {
				if self.authors.isEmpty {
					ScrollView {
						Text("\nBookmind remembers your books.\n\nThe books you own, the books you want, the books you didn't like...\n\nBookmind remembers them all.\n\n")
					}
				} else {
					LibraryScreen()
				}
				// TODO: search button to match scan button
				Button {
					self.isScanning.toggle()
				} label: {
					Label("Scan Book", systemImage: "camera.fill")
						.bookButtonStyle()
				}
			}
			.padding()
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
