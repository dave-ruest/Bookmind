//
//  SearchProgressView.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/25/24.
//

import SwiftUI

/// SearchResultView displays progress messages for a book search.
struct SearchProgressView: View {
	@Binding var result: BookSearch.Result?

	var body: some View {
		if self.message == nil {
			EmptyView()
		} else {
			Text(self.message!)
				.bookGroupStyle()
		}
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
			SearchProgressView(result: .constant(BookSearch.Preview.failed))
			SearchProgressView(result: .constant(BookSearch.Preview.searching))
			SearchProgressView(result: .constant(BookSearch.Preview.quiet))
			SearchProgressView(result: .constant(BookSearch.Preview.legend))
			SearchProgressView(result: .constant(BookSearch.Preview.dorsai))
		}
		.padding()
	}
}
