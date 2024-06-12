//
//  EditionView.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/22/24.
//

import SwiftData
import SwiftUI

/// This layout to be replaced one way or another with something much
/// more like the snazzy new scanned book screen. 
struct EditionView: View {
	@ObservedObject var edition: Edition
	@State var cover: UIImage?
	@EnvironmentObject var covers: CoverModel

	var body: some View {
		VStack(spacing: 16.0) {
			if self.cover != nil {
				Image(uiImage: self.cover!)
			} else {
				Text(edition.isbn)
			}
			Picker("Ownership", selection: self.$edition.ownState) {
				ForEach(OwnState.allCases) { owned in
					Text(owned.description)
				}
			}
			.pickerStyle(.menu)
			.labelsHidden()
			.bookButtonStyle()
		}.onAppear() {
			self.fetchCover()
		}
		.listRowBackground(Color.clear)
	}
	
	private func fetchCover() {
		guard let coverId = edition.coverIds.first else { return }
		
		if let cover = self.covers.getCover(coverId) {
			self.cover = cover
			return
		}
		
		self.covers.fetch(coverId: coverId) { image in
			self.cover = image
		}
	}
}

#Preview {
	let storage = StorageModel(preview: true)
	let book = storage.insert(book: Book.Preview.quiet)
	return List {
		EditionView(edition: book.edition)
			.modelContainer(storage.container)
	}
	.bookListStyle()
	.environmentObject(CoverModel())
}
