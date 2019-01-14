//
//  JSONItemView.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/12/19.
//

import UIKit

class JSONItemCell: UICollectionViewCell {
    private let typeHeader: UITextView = {
        let tv = UITextView()
        tv.text = Constants.typeLabelTitle
        tv.setupJSONItemTV()
        return tv
    }()
    
    private let dateHeader: UITextView = {
        let tv = UITextView()
        tv.text = Constants.dateLabelTitle
        tv.setupJSONItemTV()
        return tv
    }()
    
    private let dataHeader: UITextView = {
        let tv = UITextView()
        tv.text = Constants.dataLabelTitle
        tv.setupJSONItemTV()
        return tv
    }()
    
    private let idTextView: UITextView = {
        let tv = UITextView()
        tv.setupJSONItemTV()
        return tv
    }()
    
    private let typeTextView: UITextView = {
        let tv = UITextView()
        tv.setupJSONItemTV()
        return tv
    }()
    
    private let dateTextView: UITextView = {
        let tv = UITextView()
        tv.setupJSONItemTV()
        return tv
    }()
    
    private let dataTextView: UITextView = {
        let tv = UITextView()
        tv.setupJSONItemTV()
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
        dataTextView.text.removeAll()
    }
    
    func populate(item: JSONItem) {
        idTextView.text = item.id
        typeTextView.text = item.type
        
        if let date = item.date, !date.isEmpty {
            dateTextView.text = date
        } else {
            dateTextView.text = "No Date"
        }
        
        if let data = item.data, !data.isEmpty {
            dataTextView.text = data
        } else {
            dataTextView.text = "No Data"
        }
    }
    
    private func setupView() {
        contentView.backgroundColor = UIColor.white
        
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 2.0
        contentView.clipsToBounds = true
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        contentView.layer.shadowRadius = 4.0
        contentView.layer.shadowOpacity = 0.7
        contentView.layer.cornerRadius = 5.0
        
        contentView.addSubview(typeHeader)
        contentView.addSubview(dateHeader)
        contentView.addSubview(dataHeader)
        
        contentView.addSubview(idTextView)
        contentView.addSubview(typeTextView)
        contentView.addSubview(dateTextView)
        contentView.addSubview(dataTextView)
        
        idTextView.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView.snp.trailing).offset(-8)
            make.top.equalTo(contentView.snp.top).offset(8)
        }
        
        typeTextView.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView.snp.trailing).offset(-8)
            make.top.equalTo(idTextView.snp.bottom).offset(8)
        }
        
        typeHeader.snp.makeConstraints { (make) in
            make.trailing.equalTo(typeTextView.snp.leading).offset(-8)
            make.top.equalTo(idTextView.snp.bottom).offset(8)
        }
        
        dateHeader.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.top.equalTo(idTextView.snp.bottom).offset(8)
        }
        
        dateTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(dateHeader.snp.trailing).offset(8)
            make.top.equalTo(idTextView.snp.bottom).offset(8)
        }
        
        dataHeader.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.top.equalTo(dateHeader.snp.bottom).offset(8)
        }
        
        dataTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).offset(-8)
            make.top.equalTo(dataHeader.snp.bottom).offset(8)
        }
    }
}
