//
//  FavoritesViewController.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/8/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = [ArticleViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constants.cellNibName,
                                 bundle: Bundle.main),
                           forCellReuseIdentifier: Constants.cellReuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource = UserDefaults.standard.bookmarkedArticles ?? []
        tableView.reloadData()
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
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
        cell.changeFavoriteState = { [weak self](viewModel) in
            if viewModel.isFavorite {
                UserDefaults.standard.bookmarkArticle(article: viewModel)
            } else {
                UserDefaults.standard.removeArticle(article: viewModel)
            }
            self?.dataSource = UserDefaults.standard.bookmarkedArticles ?? []
            self?.tableView.reloadData()
            let articles = ArticlesRepository.fetchedArticles
            guard let index = articles.firstIndex(where: {$0.title == viewModel.title}) else { return }
            articles[index].isFavorite = !articles[index].isFavorite
        }
        return cell
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ArticleTableViewCell else { return }
        cell.cellSelected()
    }
}
