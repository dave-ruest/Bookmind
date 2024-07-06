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
	@State private var author: Author
	/// Updated by the editable modifier when edit mode changes.
	/// Public to enable edit layout previews.
	@State private var isEditing = false
	/// A model providing swift data entity specific convenience methods.
	@EnvironmentObject private var storage: StorageModel
	/// The dismiss environment variable, used to close the screen if
	/// we delete the last edition of a work and the work.
	@Environment(\.dismiss) private var dismiss

	init(author: Author, isEditing: Bool = false) {
		self.author = author
		self.isEditing = isEditing
	}
	
	var body: some View {
		ZStack {
			Color(.background)
				.ignoresSafeArea()
			VStack(alignment: .leading, spacing: 8.0) {
				Group {
					if self.isEditing {
						TextField("First Name", text: self.$author.firstName, axis: .vertical)
							.bookTextFieldStyle()
						TextField("Last Name", text: self.$author.lastName, axis: .vertical)
							.bookTextFieldStyle()
							.fontWeight(.bold)
					} else {
						Text("\(self.author.firstName) **\(self.author.lastName)**")
							.frame(alignment: .leading)
					}
				}
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
				if isEditing {
					Spacer()
					DeleteButton {
						self.deleteAuthor()
					}
				}
			}
			.padding()
			.animation(.smooth, value: self.isEditing)
		}
		.navigationBarTitleDisplayMode(.inline)
		.editable(self.$isEditing)
		.toolbar {
			EditButton()
		}
		.onAppear() {
			if self.author.books.isEmpty {
				self.dismiss()
			}
		}
	}
	
	private func delete(at offsets: IndexSet) {
		let books = offsets.map { self.author.books[$0] }
		self.storage.delete(books)
		self.author.books.remove(atOffsets: offsets)
		
		if self.author.books.isEmpty {
			self.dismiss()
			self.storage.delete([self.author])
		}
	}
	
	private func deleteAuthor() {
		self.dismiss()
		
		let works = self.author.books
		for work in works {
			work.authors.removeAll(where: { $0 == self.author } )
		}
		self.storage.delete([self.author])
		
		let authorlessWorks = works.filter { $0.authors.isEmpty }
		self.storage.delete(authorlessWorks)
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.quiet)
	return NavigationStack {
		AuthorScreen(author: book.authors.first!, isEditing: true)
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
