//
//  InsertBookScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-05.
//

import SwiftData
import SwiftUI

/// InsertBookScreen displays a book found by search or scan.
struct InsertBookScreen: View {
	/// A binding used to navigate between search screens. When the user
	/// selects a book search result, we set the "inserting" book and the
	/// home screen will push the insert book screen.
	@ObservedObject var router: SearchRouter
	/// The book to display. The user may edit rating and read state.
	@State var book: Book
	/// The height class environment variable, used in screen layout.
	@Environment(\.verticalSizeClass) private var heightClass

	var body: some View {
		// should be easy to ifdef a different case for ipad
		let AStack = heightClass == .compact
			? AnyLayout(HStackLayout())
			: AnyLayout(VStackLayout())
		
		ZStack {
			CoverBackgroundView(edition: self.$book.edition)
			AStack {
				CoverView(book: self.book)
				VStack() {
					OwnStateView(state: self.$book.edition.ownState)
					ReadStateView(state: self.$book.work.readState)
					RatingView(rating: self.$book.work.rating)
					Button(action: {
						self.router.path.removeLast(self.router.path.count)
					}, label: {
						Label("Done", systemImage: "arrowshape.backward.fill")
							.bookButtonStyle()
					})
				}
			}
			.padding()
			.dynamicTypeSize(.small ... .accessibility3)
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.quiet)
	return InsertBookScreen(router: SearchRouter(), book: book)
		.modelContainer(storage.container)
		.environmentObject(CoverModel())
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.legend)
	return InsertBookScreen(router: SearchRouter(), book: book)
		.modelContainer(storage.container)
		.environmentObject(CoverModel())
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.dorsai)
	return InsertBookScreen(router: SearchRouter(), book: book)
		.modelContainer(storage.container)
		.environmentObject(CoverModel())
}
