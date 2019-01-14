//
//  HeaderAndTextView.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/14/19.
//

import UIKit

class HeaderAndFieldTextView: UIView {
    // MARK: - Instance Variables
    private let headerTextView: UITextView = {
        let tv = UITextView()
        tv.setupTextView(size: 24)
        return tv
    }()
    
    private let fieldTextView: UITextView = {
        let tv = UITextView()
        tv.setupTextView(size: 24)
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func populate(header: String, field: String) {
        headerTextView.text = header
        fieldTextView.text = field
    }
    
    private func setupView() {
        backgroundColor = UIColor.white
        
        addSubview(headerTextView)
        addSubview(fieldTextView)
        
        headerTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        fieldTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(headerTextView.snp.trailing).offset(8)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
}
