//
//  ViewController.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 09.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var dataFetcher = DataFetcher()
    private var dataDecoder = DataJsonDecoder()
    
    private var model: [Model] = []
    
    private var offset: String?
    private var lastUrlQuery: URL?
    
    lazy var resultTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSearch()
        configureTableView()
    }
    
    private func configureUI() {
        title = "tenor.com API"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Check pagination", style: .plain, target: self, action: #selector(checkPagination))
    }
    
    @objc
    func checkPagination() {
        if offset != nil {
            print("it's ok.")
            print("value is \(offset)")
            print("last url = \(lastUrlQuery)")
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
        resultTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.reusableIdentifier)
        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        resultTableView.rowHeight = 110.0
        view.addSubview(resultTableView)
        NSLayoutConstraint.activate([
            resultTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            resultTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            resultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func clearExistsResults() {
        if !model.isEmpty {
            model.removeAll()
            offset = nil
            lastUrlQuery = nil
            resultTableView.reloadData()
        }
    }
    
    private func fetchData(with query: String, and page: String = "") {
        
        if lastUrlQuery == nil {
            let url = URL.with(string: Settings.api + query)
            print(url)
            lastUrlQuery = url
            
            dataFetcher.obtain(from: url, completion: { [weak self] (data) in
                
                guard let self = self else { return }
                
                let response = self.dataDecoder.decode(model: GifObjectResponse.self, from: data)
                
                self.offset = response.next
                print("Pagination: \(self.offset)")
                
                response.results.forEach { (gifData) in
                    
                    gifData.media.forEach { (gifMedia) in
                        let previewImageUrl = gifMedia.tinygif.preview
                        let imageUrl = gifMedia.gif.url
                        let id = gifData.id
                        
                        let newItem = Model(
                            previewImageURL: previewImageUrl,
                            imageURL: imageUrl,
                            imageID: id
                        )
                        
                        self.model.append(newItem)
                    }
                }
                
                DispatchQueue.main.async {
                    self.resultTableView.reloadData()
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        } else {
            let url = URL.with(string: lastUrlQuery!.absoluteString + "&pos=" + page)
            print("New URL Mfacka \(url)")
            
            // зафетчить данные
            // получить данные
            
            dataFetcher.obtain(from: url, completion: { (data) in
                
                let response = self.dataDecoder.decode(model: GifObjectResponse.self, from: data)
                
                // обновить индекс пагинации
                self.offset = response.next
                
                // добавить данные к массиву
                response.results.forEach { (gifData) in
                    
                    gifData.media.forEach { (gifMedia) in
                        let previewImageUrl = gifMedia.tinygif.preview
                        let imageUrl = gifMedia.gif.url
                        let id = gifData.id
                        
                        let newItem = Model(
                            previewImageURL: previewImageUrl,
                            imageURL: imageUrl,
                            imageID: id
                        )
                        
                        self.model.append(newItem)
                    }
                }
                
                // обновить tableView
                DispatchQueue.main.async {
                    self.resultTableView.reloadData()
                }
                
            }) { (error) in
                print(error)
            }
            
            
        }
        
        
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        clearExistsResults()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else { return }
        
        if !searchText.isEmpty {
            clearExistsResults()
            
            fetchData(with: searchText)
            searchBar.text = ""
        }
        
    }
    
    
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension ViewController: UITableViewDataSource {
    
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

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let fullImageURL = model[indexPath.row].imageURL
        
        let detailVC = DetailViewController(with: fullImageURL)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == model.count - 1 {
            print("last cell is seen")
            
            if let url = lastUrlQuery, let page = offset {
                print("у нас есть и прошлый урл, и новая позиция пагинации. продолжаем")
                
                fetchData(with: url.absoluteString, and: page)
            }
            
        }
    }
    
}
