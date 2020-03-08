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
    var dataSource: [ArticleViewModel] = []
    var fetchedArticles: [ArticleViewModel] = []
    var pageNumber = 1
    var selectedFilters = [SourceViewModel]()
    let dataLoader = DataLoader()
    let articlesRepository = ArticlesRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constants.cellNibName,
                                 bundle: Bundle.main),
                           forCellReuseIdentifier: Constants.cellReuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .darkGray
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource = ArticlesRepository.fetchedArticles
        tableView.reloadData()
    }
    
    func fetchData(){
        articlesRepository.loadArticles(from: dataLoader,
                                        pageNumber: pageNumber,
                                        pageSize: 3) { [weak self](error) in
                                            guard let self = self, error == nil else { return}
                                            self.dataSource = ArticlesRepository.fetchedArticles
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
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.cellReuseID)
            as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(with: dataSource[indexPath.row])
        cell.changeFavoriteState = { (viewModel) in
            if viewModel.isFavorite {
                UserDefaults.standard.bookmarkArticle(article: viewModel)
            } else {
                UserDefaults.standard.removeArticle(article: viewModel)
            }
        }
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
            self.dataSource = []
            for article in articles {
                self.dataSource.append(ArticleViewModel(model: article))
            }
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

