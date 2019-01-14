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
    
    private lazy var filteredJsonItems: [JSONItem] = {
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
    
    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search by Id"
        return sc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // setup search controller
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // setup the scope bar
        searchController.searchBar.scopeButtonTitles = [Constants.categoryAll, Constants.category1, Constants.category2, Constants.category3]
        searchController.searchBar.delegate = self
        
        // retrieve json data from url
        showProgressView()
        downloadJSON { [unowned self] (items) in
            self.downloadInProgressView.hideLoadingIndicator()
            self.downloadInProgressView.removeFromSuperview()
            guard let items = items else {
                return
            }
            
            self.jsonItems = items
            self.collectionView.reloadData()
            print(items)
        }
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        view.backgroundColor = UIColor.white
        navigationItem.title = "Data"
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
    
    private func filterContentForSearchText(_ searchText: String,
        scope: String=Constants.categoryAll) {
        filteredJsonItems = jsonItems.filter({ (item: JSONItem) -> Bool in
            let doesCategoryMatch = (scope == Constants.categoryAll) ||
                (item.type == scope.lowercased())
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && item.id.lowercased().contains(searchText.lowercased())
            }
        })
        
        collectionView.reloadData()
    }
    
    // returns true if the text is empty or nil
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension JSONItemController: UICollectionViewDelegate {
    
}

extension JSONItemController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredJsonItems.count
        }
        return jsonItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JSONItemCell.identifier, for: indexPath) as? JSONItemCell else {
            return UICollectionViewCell()
        }
        
        let item: JSONItem
        if isFiltering() {
            item = filteredJsonItems[indexPath.row]
        } else {
            item = jsonItems[indexPath.row]
        }
        
        cell.populate(item: item)
        
        return cell
    }
}

extension JSONItemController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.screenWidth, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

extension JSONItemController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension JSONItemController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(
            searchBar.text!,
            scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

