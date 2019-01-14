//
//  JSONItemView.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/12/19.
//

import UIKit

class JSONItemCell: UICollectionViewCell {
    private let idTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isSelectable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let typeTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isSelectable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let dateTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isSelectable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        idTextView.text.removeAll()
        typeTextView.text.removeAll()
        dateTextView.text.removeAll()
    }
    
    func populate(item: JSONItem) {
        idTextView.text = item.id
        typeTextView.text = item.type
        
        if let date = item.date, !date.isEmpty {
            dateTextView.text = date
        } else {
            dateTextView.text = "No Date"
        }
    }
    
    private func setupView() {
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 2.0
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowRadius = 2.0
        contentView.layer.cornerRadius = 5.0
        
        contentView.addSubview(idTextView)
        contentView.addSubview(typeTextView)
        contentView.addSubview(dateTextView)
        
        idTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(8)
            make.top.equalTo(contentView).offset(8)
        }
        
        typeTextView.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-8)
            make.top.equalTo(contentView).offset(8)
        }
        
        dateTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(8)
            make.top.equalTo(idTextView.snp.bottom).offset(8)
        }
    }
}
