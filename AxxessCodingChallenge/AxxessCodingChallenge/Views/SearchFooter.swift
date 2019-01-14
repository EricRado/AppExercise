//
//  SearchFooterCollectionReusableView.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/13/19.
//

import UIKit

class SearchFooter: UICollectionReusableView {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = Constants.pinkColor
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func hideFooter() {
        UIView.animate(withDuration: 0.7) { [unowned self] in
            self.alpha = 0.0
        }
    }
    
    private func showFooter() {
        UIView.animate(withDuration: 0.7) { [unowned self] in
            self.alpha = 1.0
        }
    }
}
