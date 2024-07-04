//
//  SearchProgressView.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/25/24.
//

import SwiftUI

/// SearchProgressView displays progress messages for a book search.
/// We want one summary view showing at all times, but sometimes we
/// are not yet searching, sometimes we waiting for an isbn search,
/// sometimes that search fails and sometimes that search works.
///
/// In the happy case the user taps some found book data and adds
/// it to their library. The progress view handles it all. 
struct SearchProgressView: View {
	/// A binding to a search model result, shown when we are searching
	/// for or failed to find a scanned ISBN.
	@Binding var result: BookSearch.Result?
	/// A binding used to navigate between search screens. When the user
	/// selects a book search result, we set the "inserting" book and the
	/// home screen will push the insert book screen.
	@EnvironmentObject private var router: SearchRouter

	/// A binding for a found book, updated when the search model
	/// finds results for a scanned ISBN. Used to show or hide the
	/// book button label.
	@State private var foundBook: Book?

	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var storage: StorageModel

	var body: some View {
		Group {
			if self.foundBook != nil {
				Button {
					self.didSelectBook()
				} label: {
					BookButtonLabel(book: Binding($foundBook)!)
				}
			} else if let message = self.message {
				Text(.init(message))
					.bookGroupStyle()
					.multilineTextAlignment(.center)
			} else {
				// now necessary for images to appear in preview?
				Text("")
			}
		}
		.onChange(of: self.result, initial: true) {
			self.searchModelChanged()
		}
	}
	
	private func didSelectBook() {
		guard let foundBook else { return }
		self.router.isScanning = false
		self.router.path.append(foundBook)
	}

	private var message: String? {
		return switch self.result {
		case .searching(let isbn):
			"Searching for ISBN \(isbn)"
		case .invalid:
			"Please type a valid ISBN 10 or 13 code such as 0-5555-5555-X or 978-0-5555-5555-1"
		case .failed(let isbn):
			"Could not find ISBN \(isbn) on **[Open Library](https://openlibrary.org)**. You can sign up and add it! Or, soon, tap Add to type in the details for that book."
		default:
			nil
		}
	}
	
	private func searchModelChanged() {
		if case .found(let book) = self.result {
			self.foundBook = book
		}
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			SearchProgressView(result: .constant(nil))
			SearchProgressView(result: .constant(BookSearch.Preview.failed))
			SearchProgressView(result: .constant(BookSearch.Preview.searching))
			SearchProgressView(result: .constant(BookSearch.Preview.quiet))
			SearchProgressView(result: .constant(BookSearch.Preview.legend))
			SearchProgressView(result: .constant(BookSearch.Preview.dorsai))
		}
		.padding()
	}
	.environmentObject(CoverModel())
}
