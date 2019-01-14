//
//  SearchFooterCollectionReusableView.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/13/19.
//

import UIKit

class SearchFooter: UIView {
    // MARK: - Instance Variables
    static let identifier = "SearchFooter"
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = Constants.pinkColor
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Constants.pinkColor
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
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

extension SearchFooter {
    public func setNotFiltering() {
        label.text = ""
        hideFooter()
    }
    
    public func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
        if (filteredItemCount == totalItemCount) {
            setNotFiltering()
        } else if (filteredItemCount == 0) {
            label.text = "No items match your query"
            showFooter()
        } else {
            label.text = "Filtering \(filteredItemCount) of \(totalItemCount)"
            showFooter()
        }
    }
}
