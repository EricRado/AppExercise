//
//  JSONItemView.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/12/19.
//

import UIKit

class JSONItemCell: UICollectionViewCell {
    // MARK: - Instance Variables
    private let typeHeader: UILabel = {
        let label = UILabel()
        label.text = Constants.typeLabelTitle
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let dateHeader: UILabel = {
        let label = UILabel()
        label.text = Constants.dateLabelTitle
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let dataHeader: UILabel = {
        let label = UILabel()
        label.text = Constants.dataLabelTitle
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let idTextView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let typeTextView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let dateTextView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let dataTextView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initilizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        idTextView.text?.removeAll()
        typeTextView.text?.removeAll()
        dateTextView.text?.removeAll()
        dataTextView.text?.removeAll()
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
        contentView.layer.shadowRadius = 6.0
        contentView.layer.shadowOpacity = 0.7
        contentView.layer.cornerRadius = 5.0
        
        contentView.addSubview(typeHeader)
        contentView.addSubview(dateHeader)
        contentView.addSubview(dataHeader)
        
        contentView.addSubview(idTextView)
        contentView.addSubview(typeTextView)
        contentView.addSubview(dateTextView)
        contentView.addSubview(dataTextView)
        
        // constraints for id
        idTextView.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView.snp.trailing).offset(-8)
            make.top.equalTo(contentView.snp.top).offset(8)
        }
        
        // constraints for type
        typeTextView.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView.snp.trailing).offset(-8)
            make.top.equalTo(idTextView.snp.bottom).offset(8)
        }
        
        typeHeader.snp.makeConstraints { (make) in
            make.trailing.equalTo(typeTextView.snp.leading).offset(-8)
            make.top.equalTo(idTextView.snp.bottom).offset(8)
        }
        
        // constraints for date
        dateHeader.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.top.equalTo(idTextView.snp.bottom).offset(8)
        }
        
        dateTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(dateHeader.snp.trailing).offset(8)
            make.top.equalTo(idTextView.snp.bottom).offset(8)
        }
        
        // constraints for data
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
