//
//  JSONItemDetailView.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/13/19.
//

import UIKit

class JSONItemDetailView: UIView {
    // MARK: - Instance Variables
    private let idView: HeaderAndFieldTextView = {
        let view = HeaderAndFieldTextView()
        return view
    }()
    
    private let typeView: HeaderAndFieldTextView = {
        let view = HeaderAndFieldTextView()
        return view
    }()
    
    private let dateView: HeaderAndFieldTextView = {
        let view = HeaderAndFieldTextView()
        return view
    }()
    
    private let itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let dataTextView: UITextView = {
        let tv = UITextView()
        tv.setupTextView(size: 24)
        tv.textAlignment = .center
        return tv
    }()
    
    private let statckViewHeightMultiplier: CGFloat = 0.22
    private let imageViewHeightMultiplier: CGFloat = 0.25
    
    // MARK: - View's initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method Injection Methods
    public func populate(_ item: JSONItem) {
        idView.populate(header: Constants.idLabelTitle, field: item.id)
        typeView.populate(header: Constants.typeLabelTitle, field: item.type)
        
        if let date = item.date, !date.isEmpty {
            dateView.populate(header: Constants.dateLabelTitle, field: date)
        } else {
            dateView.populate(header: Constants.dateLabelTitle, field: "No Date")
        }
        
        // if JSONItem's type is 'text' or 'other' show a textView
        if item.type == Constants.typeText || item.type == Constants.typeOther {
            if let data = item.data, !data.isEmpty {
                dataTextView.text = data
            } else {
                dataTextView.text = "No Data"
            }
            
            dataTextView.isHidden = false
        }
        
        if item.type == Constants.typeImage, let path = item.data {
            do {
                let url = try path.asURL()
                itemImageView.downloadFrom(url: url)
            } catch let error {
                itemImageView.image = UIImage(named: Constants.imageNotFound)
                print(error.localizedDescription)
            }
            itemImageView.isHidden = false
        }
    }
    
    public func setImage(_ image: UIImage?) {
        itemImageView.image = image
        itemImageView.isHidden = false
    }
    
    // MARK: - View layout method
    private func setupView() {
        backgroundColor = UIColor.white
        
        // setup stack view with id, type and date properties
        let arr = [idView, typeView, dateView]
        let sv = UIStackView(arrangedSubviews: arr)
        sv.backgroundColor = UIColor.yellow
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.spacing = 16
        
        addSubview(sv)
        addSubview(dataTextView)
        addSubview(itemImageView)
        
        sv.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(24)
            make.centerX.equalTo(self.snp.centerX)
            make.height.width.equalTo(Constants.screenHeight * statckViewHeightMultiplier)
        }
        
        dataTextView.isHidden = true
        dataTextView.snp.makeConstraints { (make) in
            make.top.equalTo(sv.snp.bottom).offset(24)
            make.leading.equalTo(self.snp.leading).offset(24)
            make.trailing.equalTo(self.snp.trailing).offset(-24)
        }
        
        itemImageView.isHidden = true
        itemImageView.snp.makeConstraints { (make) in
            make.top.equalTo(sv.snp.bottom).offset(24)
            make.centerX.equalTo(self)
            make.height.width.equalTo(Constants.screenHeight * imageViewHeightMultiplier)
        }
    }
}
