//
//  ArticleViewModel.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/5/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import Foundation

class ArticleViewModel: Codable {
    let title: String
    var date: String?
    let imageURL: String
    let sourceName: String
    let articleURL: String
    let description: String
    var isFavorite = false
    
    init(model: Article) {
        title = model.title ?? ""
        if let date = model.publishedAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.apiDateFormat
            self.date = dateFormatter.date(from: date)?.toString(dateFormat: Constants.displayDateFormat)
        }
        imageURL = model.urlToImage ?? ""
        sourceName = model.source?.name ?? ""
        articleURL = model.url ?? ""
        description = model.description ?? ""
    }
}
