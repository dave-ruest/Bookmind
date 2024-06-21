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
	/// A binding to a found book, updated when the search model
	/// finds results for a scanned ISBN.
	@Binding var foundBook: Book?
	/// A binding to tell the parent view that the user selected
	/// the found book. 
	@Binding var selectedBook: Book?

	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var storage: StorageModel

	var body: some View {
		if self.foundBook != nil {
			Button {
				self.didSelectBook()
			} label: {
				BookButtonLabel(book: Binding($foundBook)!)
			}
		} else if let message = self.message {
			Text(message)
				.bookGroupStyle()
				.multilineTextAlignment(.center)
		} else {
			EmptyView()
		}
	}
	
	private func didSelectBook() {
		self.dismiss()
		guard let foundBook else { return }
		self.selectedBook = self.storage.insert(book: foundBook)
	}

	private var message: String? {
		return switch self.result {
		case .searching(let isbn):
			"Searching for ISBN \(isbn)"
		case .failed(let isbn):
			"Could not find ISBN \(isbn)"
		default:
			nil
		}
	}
}

#Preview {
	ZStack {
		Color(.systemIndigo)
			.ignoresSafeArea()
		VStack(spacing: 16.0) {
			SearchProgressView(result: .constant(BookSearch.Preview.failed), 
							   foundBook: .constant(nil),
							   selectedBook: .constant(nil))
			SearchProgressView(result: .constant(BookSearch.Preview.searching),
							   foundBook: .constant(nil),
							   selectedBook: .constant(nil))
			SearchProgressView(result: .constant(BookSearch.Preview.quiet),
							   foundBook: .constant(nil),
							   selectedBook: .constant(nil))
			SearchProgressView(result: .constant(BookSearch.Preview.legend),
							   foundBook: .constant(nil),
							   selectedBook: .constant(nil))
			SearchProgressView(result: .constant(BookSearch.Preview.dorsai),
							   foundBook: .constant(nil),
							   selectedBook: .constant(nil))
		}
		.padding()
	}
}
