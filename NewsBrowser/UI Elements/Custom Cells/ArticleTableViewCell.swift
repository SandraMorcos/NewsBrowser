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
    @IBOutlet weak var addFavoriteButton: UIButton!
    
    var viewModel: ArticleViewModel?
    var articleURL: String?
    var changeFavoriteState: ((ArticleViewModel)->Void)?
    
    func setup(with article: ArticleViewModel) {
        title.text = article.title
        source.text = article.sourceName
        articleDescription.text = article.description
        datePublished.text = article.date
        articleImageView.sd_setImage(with: URL(string: article.imageURL), placeholderImage: UIImage(named: "placeholder.png"))
        articleURL = article.articleURL
        viewModel = article
        setButtonImage(isFavorite: viewModel?.isFavorite ?? false)
    }

    @IBAction func changeFavoriteState(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        viewModel.isFavorite = !viewModel.isFavorite
        setButtonImage(isFavorite: viewModel.isFavorite)
        changeFavoriteState?(viewModel)
    }
    
    private func setButtonImage(isFavorite: Bool) {
        var image: UIImage?
        if isFavorite {
            image = UIImage(named: "favorite")
        } else {
            image = UIImage(named: "unfavorite")
        }
        addFavoriteButton.setImage(image, for: .normal)
    }
    
    func cellSelected() {
        guard let url = URL(string: articleURL ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
}
