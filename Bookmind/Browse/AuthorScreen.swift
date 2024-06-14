//
//  AuthorScreen.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/30/24.
//

import SwiftData
import SwiftUI

/// AuthorScreen displays the list of books for a specific author.
struct AuthorScreen: View {
	/// The author whose name and works will be shown.
	@State var author: Author
	/// Core data storage, used to delete editions.
	@EnvironmentObject private var storage: StorageModel
	/// The current edit mode, used to decide whether we should
	/// show editable author names or not.
	@Environment(\.editMode) private var editMode

	var body: some View {
		ZStack {
			Color(.background)
				.ignoresSafeArea()
			VStack(alignment: .leading, spacing: 8.0) {
				Group {
					if self.editMode?.wrappedValue.isEditing == true {
						TextField("Name", text: self.$author.name, axis: .vertical)
							.textFieldStyle(.roundedBorder)
							.border(Color.accentColor, width: 1.0)
					} else {
						Text("\(self.author.firstName) **\(self.author.lastName)**")
							.frame(alignment: .leading)
					}
				}
				.animation(.smooth, value: self.editMode?.wrappedValue)
				.font(.title)
				List {
					// The "self.author.books" here lazy loads books
					// from the many to many core data relationship.
					// Adding and deleting are trickier but wow does
					// this ever "just work".
					ForEach(self.author.books.sorted()) { book in
						NavigationLink {
							WorkScreen(work: book)
						} label: {
							Text(book.title)
						}
						.listRowBackground(Color(.clear))
					}.onDelete(perform: delete)
				}
				.listStyle(.plain)
				.listRowSeparatorTint(.accent)
				.background(Color(.background))
			}
			.padding()
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			EditButton()
		}
		.onChange(of: self.editMode?.wrappedValue) {
			self.editModeChanged()
		}
	}
	
	private func editModeChanged() {
		if self.editMode?.wrappedValue == .inactive {
			self.author.nameChanged()
		}
	}
	
	private func delete(at offsets: IndexSet) {
		let books = offsets.map { self.author.books[$0] }
		self.storage.delete(books)
		self.author.books.remove(atOffsets: offsets)
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.quiet)
	return NavigationStack {
		AuthorScreen(author: book.authors.first!)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
