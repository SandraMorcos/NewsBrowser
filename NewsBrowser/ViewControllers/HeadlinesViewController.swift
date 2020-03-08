//
//  HeadlinesViewController.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/5/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import UIKit

class HeadlinesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let cellNibName = "ArticleTableViewCell"
    let cellReuseID = "articleTableviewCellID"
    var dataSource: [Article] = []
    var fetchedArticles: [Article] = []
    var pageNumber = 1
    var selectedFilters = [SourceViewModel]()
    let dataLoader = DataLoader()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellNibName, bundle: Bundle.main), forCellReuseIdentifier: cellReuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .darkGray
        fetchData()
    }
    
    func fetchData(){
        dataLoader.request(.headlines(pageNumber: pageNumber, pageSize: 3)) { [weak self](response, _) in
            guard let self = self,
                let articles = response?.articles else {
                    return
            }
            self.fetchedArticles.append(contentsOf: articles)
            self.dataSource = self.fetchedArticles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func showFilters(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboards.main.rawValue, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllers.filters.rawValue) as? FiltersViewController else {
            return
        }
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }

}

extension HeadlinesViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        let viewModel = ArticleViewModel(model: dataSource[indexPath.row])
        cell.setup(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == fetchedArticles.count - 1 else { return }
        pageNumber += 1
        fetchData()
    }
    
}

extension HeadlinesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ArticleTableViewCell else { return }
        cell.cellSelected()
    }
}

extension HeadlinesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
            !text.isEmpty else { return }
        let sources = Constants.favoriteSources ?? []
        dataLoader.request(.search(matching: text, sources: sources)) { [weak self] (response, error) in
            guard let self = self,
                let articles = response?.articles else { return }
            self.dataSource = articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        dataSource = fetchedArticles
        tableView.reloadData()
    }
}

extension HeadlinesViewController: FilteredSearchDelegate {
    func addFilter(source: SourceViewModel) {
        selectedFilters.append(source)
    }
    
    func removeFilter(source: SourceViewModel) {
        guard let index = selectedFilters.firstIndex(where: {$0.id == source.id}) else { return }
        selectedFilters.remove(at: index)
    }
}

