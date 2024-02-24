//
//  CoverModel.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/22/24.
//

import Combine
import Foundation
import UIKit

final class CoverModel: ObservableObject {
	private var cache = NSCache<NSString, UIImage>()
	private var cancelables = [AnyCancellable]()
	
	func getCover(_ coverId: Int) -> UIImage? {
		self.cache.object(forKey: coverId.asKey())
	}
	
	private func setCover(_ coverId: Int, image: UIImage) {
		self.cache.setObject(image, forKey: coverId.asKey())
	}
	
	func fetch(coverId: Int, found: @escaping ((UIImage?) -> Void)) {
		let string = "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"
		guard let url = URL(string: string) else { return }

		self.cancelables.append(
			FetchTask(url: url)
				.start(found: { [weak self] image in
					self?.setCover(coverId, image: image)
					found(image)
				}
			)
		)
	}
}

private extension Int {
	func asKey() -> NSString {
		NSString(format: "%d", self)
	}
}
