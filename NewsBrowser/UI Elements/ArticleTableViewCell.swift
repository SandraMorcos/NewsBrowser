//
//  ArticleTableViewCell.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/5/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var datePublished: UILabel!
    
    var articleURL: String?
    
    func setup(with article: ArticleViewModel) {
        title.text = article.title
        source.text = article.sourceName
        articleDescription.text = article.description
        datePublished.text = article.date
        articleImageView.sd_setImage(with: URL(string: article.imageURL), placeholderImage: UIImage(named: "placeholder.png"))
        articleURL = article.articleURL
    }

    func cellSelected() {
        guard let url = URL(string: articleURL ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
}
