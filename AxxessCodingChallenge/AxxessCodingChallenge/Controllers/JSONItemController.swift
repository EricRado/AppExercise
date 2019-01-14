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
    // MARK: - Instance Variables
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
    
    private lazy var searchFooter: SearchFooter = {
        var footer = SearchFooter()
        footer.translatesAutoresizingMaskIntoConstraints = false
        return footer
    }()
    
    private let searchFooterHeightMultipler: CGFloat = 0.06
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.register(JSONItemCell.self,
                    forCellWithReuseIdentifier: JSONItemCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private var collectionViewBottomConstraint: Constraint?
    
    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search by Id"
        return sc
    }()
    
    // MARK: - View Controller's lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // setup search controller
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // setup the scope bar
        searchController.searchBar.scopeButtonTitles = [
            Constants.categoryAll,
            Constants.category1,
            Constants.category2,
            Constants.category3]
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
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            self.collectionViewBottomConstraint = make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                .constraint
        }
        navigationItem.title = "Data"
    }
    
    private func showProgressView() {
        view.addSubview(downloadInProgressView)
        downloadInProgressView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(view.safeAreaInsets)
        }
    }

    private func downloadJSON(completion: @escaping (([JSONItem]?) -> Void)) {
        Alamofire.request(Router.master(Constants.jsonFileName)).responseJSON { (response) in
            guard response.result.isSuccess, let data = response.data else {
                print("Unable to retrieve json file")
                completion(nil)
                return
            }
            
            // parse the json to JSONItem objects
            do {
                let items = try JSONDecoder().decode([JSONItem].self, from: data)
                completion(items)
            } catch (let error) {
                print(error.localizedDescription)
                completion(nil)
            }
            
        }
    }
    
    // MARK: - Search bar and scope methods
    private func filterContentForSearchText(_ searchText: String,
        scope: String=Constants.categoryAll) {
        // apply the selected scope filter to JSONItem array
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
        // if the selected scope is not 'all' display searchFooter
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        if searchBarScopeIsFiltering {
            showSearchFooter()
        }
        
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension JSONItemController {
    private func showSearchFooter() {
        view.addSubview(searchFooter)
        searchFooter.snp.makeConstraints { [unowned self] (make) in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(Constants.screenHeight * searchFooterHeightMultipler)
        }
    }
}

extension JSONItemController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: JSONItem
        
        if isFiltering() {
            item = filteredJsonItems[indexPath.item]
        } else {
            item = jsonItems[indexPath.item]
        }
        
        // transfer selected object to Detail Controller through method injection
        let vc = JSONItemDetailController()
        vc.setJSONItem(item)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JSONItemController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredJsonItems.count, of: jsonItems.count)
            return filteredJsonItems.count
        }
        
        searchFooter.setNotFiltering()
        return jsonItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: JSONItemCell.identifier, for: indexPath) as? JSONItemCell else {
            return UICollectionViewCell()
        }
        
        let item: JSONItem
        if isFiltering() {
            item = filteredJsonItems[indexPath.item]
        } else {
            item = jsonItems[indexPath.item]
        }
        
        cell.populate(item: item)
        
        return cell
    }
}

extension JSONItemController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.screenWidth - 16, height: collectionView.frame.size.height / 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
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

