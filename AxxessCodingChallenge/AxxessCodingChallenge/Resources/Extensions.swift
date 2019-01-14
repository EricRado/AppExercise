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
    func setupTextView(size: CGFloat) {
        self.font = UIFont.systemFont(ofSize: size)
        setupCommonProperties()
    }
    
    private func setupCommonProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.isSelectable = true
        self.isEditable = false
        self.isScrollEnabled = false
        self.removePadding()
    }
    
    private func removePadding() {
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = .zero
    }
}

extension UIImageView {
    func downloadFrom(url: URL) {
        // download image asynchronously 
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self.image = UIImage(named: Constants.imageNotFound)
                    }
                    return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
