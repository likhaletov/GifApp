//
//  MainScreenViewController.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 09.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    private let mainView = MainScreenView()
    private var model: [Model] = [] {
        didSet {
            if model.isEmpty {
                searchController.searchBar.resignFirstResponder()
                if let cancelButton = searchController.searchBar.value(forKey: "cancelButton") as? UIButton {
                    cancelButton.isEnabled = false
                }
            }
            if !model.isEmpty {
                print("model contains data")
            }
        }
    }
    private var networkManager: NetworkProtocol
    
    // Pagination
    private var isLoading = false
    private var nextPage: String?
    private var currentQuery: String?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func loadView() {
        super.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearch()
        configureTableView()
    }
    
    private func initStart() {
        self.currentQuery = Settings.initSearchQuery
        guard let query = self.currentQuery else { return }
        searchController.searchBar.text = query
        fetchData(with: query)
    }
    
    private func configureUI() {
        title = "tenor.com GIF API"
        view.backgroundColor = .white
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "Check pagination",
//            style: .plain,
//            target: self,
//            action: #selector(checkPagination)
//        )
    }
    
//    @objc private func checkPagination() {
//        guard let nextPage = nextPage, let query = currentQuery else { return }
//        print("Next page is: \(nextPage)")
//        print("Current query is: \(query)")
//        print("Current model count: \(model.count)")
//    }
    
    private func configureSearch() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Type your query"
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func configureTableView() {
        mainView.resultTableView.delegate = self
        mainView.resultTableView.dataSource = self
    }
    
    private func clearExistsResults() {
        if !model.isEmpty {
            model.removeAll()
            nextPage = nil
            currentQuery = nil
            mainView.resultTableView.reloadData()
        }
    }
    
    private func fetchData(with query: String, and page: String = "") {
        let url = URL.with(string: Settings.api + query, page: page)
        
        networkManager.obtainData(from: url, completion: { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(GifObjectResponse.self, from: data)
                    self.nextPage = response.next
                    
                    self.isLoading = false
                    if !response.results.isEmpty {
                        let id = response.results.map { $0.id }
                        let previews = response.results.flatMap { $0.media.map { $0.tinygif.preview } }
                        let images = response.results.flatMap { $0.media.map { $0.gif.url } }
                        
                        for item in 0..<id.count {
                            let newItem = Model(
                                previewImageURL: previews[item],
                                imageURL: images[item],
                                imageID: id[item]
                            )
                            self.model.append(newItem)
                        }
                        
                        DispatchQueue.main.async {
                            self.mainView.resultTableView.reloadData()
                        }
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    init(networkManager: NetworkProtocol) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoading && mainView.resultTableView.contentOffset.y >= (mainView.resultTableView.contentSize.height - mainView.resultTableView.frame.height) {
            self.isLoading = true
            guard let nextPage = self.nextPage, let currentQuery = self.currentQuery else { return }
            fetchData(with: currentQuery, and: nextPage)
        }
    }
}

extension MainScreenViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearExistsResults()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            clearExistsResults()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if !searchText.isEmpty {
            clearExistsResults()
            self.currentQuery = searchText
            fetchData(with: searchText)
        }
    }
}

extension MainScreenViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {  }
}

extension MainScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = model[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: GifPreviewTableViewCell.reusableID, for: indexPath) as? GifPreviewTableViewCell {
            cell.configure(with: dataSource)
            return cell
        }
        return UITableViewCell()
    }
}

extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let fullImageURL = model[indexPath.row].imageURL
        let imageID = model[indexPath.row].imageID
        let detailVC = DetailViewController(with: fullImageURL, and: imageID)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
