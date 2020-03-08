//
//  ArticlesRepository.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/8/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import Foundation

class ArticlesRepository {
    static var fetchedArticles = [ArticleViewModel]()
    func loadArticles(from dataLoader: DataLoader,
                      pageNumber: Int,
                      pageSize: Int,
                      then completion: @escaping (NewsApiError?) -> Void) {
        dataLoader.request(.headlines(pageNumber: pageNumber, pageSize: 3)) { (response, _) in
            guard let articles = response?.articles else {
                    return
            }
            var viewModels = [ArticleViewModel]()
            for article in articles {
                let viewModel = ArticleViewModel(model: article)
                viewModels.append(viewModel)
            }
            ArticlesRepository.fetchedArticles.append(contentsOf: viewModels)
            completion(nil)
        }
    }
    
}
