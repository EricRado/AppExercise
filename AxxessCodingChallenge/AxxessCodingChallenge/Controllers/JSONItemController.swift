//
//  ViewController.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/12/19.
//

import UIKit
import Alamofire
import SnapKit

class JSONItemController: UIViewController {
    private let jsonFileName = "challenge.json"
    private let downloadInProgressView: DownloadInProgressView = {
        let dipView = DownloadInProgressView()
        dipView.translatesAutoresizingMaskIntoConstraints = false
        return dipView
    }()
    
    private lazy var jsonItems: [JSONItem] = {
        var arr = [JSONItem]()
        return arr
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(JSONItemCell.self,
                    forCellWithReuseIdentifier: JSONItemCell.identifier)
        cv.backgroundColor = UIColor.green
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "Data"
        
        showProgressView()
        downloadJSON { [unowned self] (items) in
            self.downloadInProgressView.hideLoadingIndicator()
            guard let items = items else {
                return
            }
            
            self.jsonItems = items
            self.collectionView.reloadData()
            print(items)
        }
    }
    
    private func showProgressView() {
        view.addSubview(downloadInProgressView)
        downloadInProgressView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(view.safeAreaInsets)
        }
    }

    private func downloadJSON(completion: @escaping (([JSONItem]?) -> Void)) {
        Alamofire.request(Router.master(jsonFileName)).responseJSON { (response) in
            guard response.result.isSuccess, let data = response.data else {
                print("Unable to retrieve json file")
                completion(nil)
                return
            }
            print(response)
            do {
                let items = try JSONDecoder().decode([JSONItem].self, from: data)
                completion(items)
            } catch (let error) {
                print(error.localizedDescription)
                completion(nil)
            }
            
        }
    }
}

extension JSONItemController: UICollectionViewDelegate {
    
}

extension JSONItemController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return jsonItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JSONItemCell.identifier, for: indexPath)
        
        return cell
    }
    
    
}

