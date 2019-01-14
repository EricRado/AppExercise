//
//  JSONItemDetailController.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/13/19.
//

import UIKit

class JSONItemDetailController: UIViewController {
    // MARK: - Instance Variables
    private var jsonItem: JSONItem?
    private lazy var jsonItemDetailView: JSONItemDetailView = {
        var detailView = JSONItemDetailView()
        return detailView
    }()
    
    // MARK: - View Controller's lifecyle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupView()
    }
    
    // MARK: - View Controller's view layout methods
    public func setJSONItem(_ item: JSONItem) {
        jsonItem = item
        navigationItem.title = jsonItem?.id
    }
    
    private func setupView() {
        jsonItemDetailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(jsonItemDetailView)
        jsonItemDetailView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // send JSONItem to JSONItemDetailView to populate UIElements with data
        if let item = jsonItem {
            jsonItemDetailView.populate(item)
        }
    }
}
