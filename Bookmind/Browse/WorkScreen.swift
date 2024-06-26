//
//  WorkScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/4/24.
//

import SwiftData
import SwiftUI

/// WorkScreen displays a book: rating, read state, and all editions.
/// Each edition is shown in a list with own state and cover art, or
/// just the ISBN if no cover is available.
struct WorkScreen: View {
	/// The book whose properties and editions we'll display.
	/// Variable and observable because the user may edit rating and
	/// read state. Editions may be deleted but that is a core data storage
	/// operation. 
	@State var work: Work
	/// The editions page view uses a binding to this state to communicate
	/// its selected edition. The work screen uses the selected edition for
	/// its background cover art and its own state picker.
	@State private var selectedEdition: Edition
	/// Updated by the editable modifier when edit mode changes.
	@State private var isEditing = false
	/// The height class environment variable, used in screen layout.
	@Environment(\.verticalSizeClass) private var heightClass
	/// Core data storage, used to delete editions.
	@EnvironmentObject private var storage: StorageModel
	/// The dismiss environment variable, used to close the screen if
	/// we delete the last edition of a work and the work.
	@Environment(\.dismiss) private var dismiss

	init(work: Work) {
		self.work = work
		self.selectedEdition = work.editions.first ?? Edition(isbn: "")
	}

	var body: some View {
		// should be easy to ifdef a different case for ipad
		let AStack = heightClass == .compact
			? AnyLayout(HStackLayout())
			: AnyLayout(VStackLayout())
		
		ZStack {
			CoverBackgroundView(edition: self.$selectedEdition)
			AStack {
				EditionPageView(work: self.work, selectedEdition: self.$selectedEdition)
				VStack() {
					if self.isEditing {
						DeleteButton { self.delete() }
					} else {
						OwnStateView(state: self.$selectedEdition.ownState)
						ReadStateView(state: self.$work.readState)
						RatingView(rating: self.$work.rating)
					}
				}
			}
			.animation(.smooth, value: self.isEditing)
			.editable(self.$isEditing)
			.padding()
			.dynamicTypeSize(.small ... .accessibility3)
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			EditButton()
		}
	}
	
	private func delete() {
		self.storage.delete([self.selectedEdition])
		self.work.editions.removeAll(where: { $0 == self.selectedEdition })
		
		if self.work.editions.isEmpty {
			self.dismiss()
			
			let authors = self.work.authors
			self.storage.delete([self.work])
			for author in authors {
				author.books.removeAll(where: { $0 == self.work })
			}
		}

		// let the user decide if they want to keep the author or not
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.quiet)
	return NavigationStack {
		WorkScreen(work: book.work)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}


#Preview {
	let storage = StorageModel(preview: true)
	var book = storage.insert(book: Book.Preview.dune1986)
	book = storage.insert(book: Book.Preview.dune1987)
	return NavigationStack {
		WorkScreen(work: book.work)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}


#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.legend)
	return NavigationStack {
		WorkScreen(work: book.work)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
