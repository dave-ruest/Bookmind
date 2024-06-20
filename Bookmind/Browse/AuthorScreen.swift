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
	/// A helper flag used by the editable modifier to forward edit mode
	/// changes in a simpler fashion.
	@State private var isEditing = false

	var body: some View {
		ZStack {
			Color(.background)
				.ignoresSafeArea()
			VStack(alignment: .leading, spacing: 8.0) {
				Group {
					if self.isEditing {
						TextField("Name", text: self.$author.name, axis: .vertical)
							.textFieldStyle(.roundedBorder)
							.border(Color.accentColor, width: 1.0)
					} else {
						Text("\(self.author.firstName) **\(self.author.lastName)**")
							.frame(alignment: .leading)
					}
				}
				.padding(.horizontal)
				.animation(.smooth, value: self.isEditing)
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
							WorkListLabel(work: book)
						}
						.listRowBackground(Color(.clear))
					}.onDelete(perform: delete)
				}
				.listStyle(.plain)
				.listRowSeparatorTint(.accent)
				.background(Color(.background))
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.editable(self.$isEditing) {
			self.editModeChanged()
		}
		.toolbar {
			EditButton()
		}
	}
	
	private func editModeChanged() {
		if !self.isEditing {
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

#Preview {
	let storage = StorageModel(preview: true)
	var book = storage.insert(book: Book.Preview.dune1986)
	book = storage.insert(book: Book.Preview.dune1987)
	return NavigationStack {
		AuthorScreen(author: book.authors.first!)
	}
	.modelContainer(storage.container)
	.environmentObject(CoverModel())
}
