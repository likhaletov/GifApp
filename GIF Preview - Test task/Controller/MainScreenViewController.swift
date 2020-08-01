//
//  MainScreenViewController.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 09.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    let mainView = MainScreenView()
    
    private var networkManager: NetworkProtocol
    
    private var model: [Model] = []
    
    private var offset: String?
    private var lastQuery: String?
    
    override func loadView() {
        super.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearch()
        configureTableView()
    }
    
    private func configureUI() {
        title = "tenor.com GIF API"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Check pagination",
            style: .plain,
            target: self,
            action: #selector(checkPagination)
        )
    }
    
    @objc func checkPagination() {
        if offset != nil {
            print("it's ok.")
            print("value is \(offset ?? "")")
            print("last url = \(lastQuery ?? "damn")")
        }
    }
    
    private func configureSearch() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Type your query"
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.showsSearchResultsButton = true
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        mainView.resultTableView.delegate = self
        mainView.resultTableView.dataSource = self
    }
    
    private func clearExistsResults() {
        if !model.isEmpty {
            model.removeAll()
            offset = nil
            mainView.resultTableView.reloadData()
        }
    }
    
    private func fetchData(with query: String, and page: String = "") {
//        let url = URL.with(string: Settings.api + query)
        let url = URL.with(string: Settings.api + query, page: page)
        print("URL::: \(url.absoluteString)")
        
        networkManager.obtainData(from: url, completion: { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(GifObjectResponse.self, from: data)
                    self.offset = response.next
                    print("Pagination: \(self.offset ?? "pagination offset error")")
                    
                    _ = response.results.map { (lolka) in
                        lolka.media.map { (lolych) in
                            let newDamnIt = Model(previewImageURL: lolych.tinygif.preview,
                                                  imageURL: lolych.gif.url,
                                                  imageID: lolka.id
                            )
                            self.model.append(newDamnIt)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.mainView.resultTableView.reloadData()
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
    
}

extension MainScreenViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearExistsResults()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if !searchText.isEmpty {
            clearExistsResults()
            self.lastQuery = searchText
            fetchData(with: searchText)
            searchBar.text = ""
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reusableIdentifier, for: indexPath) as! CustomTableViewCell
        let dataSource = model[indexPath.row]
        cell.configure(with: dataSource)
        return cell
    }
}

extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fullImageURL = model[indexPath.row].imageURL
        let detailVC = DetailViewController(with: fullImageURL)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == model.count - 1 {
            print("saw the last cell")
            guard let offset = self.offset, let lastQuery = self.lastQuery else { return }
            print("OFFSET \(offset)")
            print("Last Query \(lastQuery)")
            fetchData(with: lastQuery, and: offset)
        }
    }
    
}
