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
	@ObservedObject var router: SearchRouter

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
				Text(message)
					.bookGroupStyle()
					.multilineTextAlignment(.center)
			} else {
				EmptyView()
			}
		}
		.onChange(of: self.result, initial: true) {
			self.searchModelChanged()
		}
	}
	
	private func didSelectBook() {
		guard let foundBook else { return }
//		self.router.showInsert(for: self.storage.insert(book: foundBook))
		self.router.isScanning = false
		self.router.path.append(foundBook)
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
			SearchProgressView(result: .constant(BookSearch.Preview.failed), 
							   router: SearchRouter())
			SearchProgressView(result: .constant(BookSearch.Preview.searching),
							   router: SearchRouter())
			SearchProgressView(result: .constant(BookSearch.Preview.quiet),
							   router: SearchRouter())
			SearchProgressView(result: .constant(BookSearch.Preview.legend),
							   router: SearchRouter())
			SearchProgressView(result: .constant(BookSearch.Preview.dorsai),
							   router: SearchRouter())
		}
		.padding()
	}
}
