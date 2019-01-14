//
//  Extensions.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/13/19.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITextView {
    func setupJSONItemTV() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.systemFont(ofSize: 16)
        self.isSelectable = false
        self.isScrollEnabled = false
        self.removePadding()
    }
    func removePadding() {
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = .zero
    }
}
