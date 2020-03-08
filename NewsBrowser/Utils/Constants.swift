//
//  Constants.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/5/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import UIKit

struct Constants {
    static let apiKey = "f21ce6f8bf994dc6b7f8f456d92bcbe3"
    static let displayDateFormat = "MMM d, yyyy"
    static let apiDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let cellNibName = "ArticleTableViewCell"
    static let cellReuseID = "articleTableviewCellID"
    static var favoriteCountry: String? {
        return UserDefaults.standard.favoriteCountry
    }
    static var favoriteSources: [String]? {
        return UserDefaults.standard.favoriteSources
    }
}

enum ViewControllers: String {
    case headlines = "HeadlinesViewController"
    case onboarding = "OnboardingViewController"
    case sources = "SourcesViewController"
    case filters = "FiltersViewController"
    case favorites = "FavoritesViewController"
}

enum Storyboards: String {
    case main = "Main"
    case onboarding = "Onboarding"
}

extension UIColor {
    static func maroon(alpha: CGFloat) -> UIColor {
        return UIColor(red: 148.0/255, green: 17.0/255, blue: 0, alpha: alpha)
    }
}
