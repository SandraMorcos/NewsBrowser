//
//  UserDefaults+Keys.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/8/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import Foundation

extension UserDefaults {
    private enum Keys: String {
        case favoriteCountry
        case favoritesSources
        case bookmarkedArticles
        
    }
    var favoriteCountry: String? {
        set {
            set(newValue, forKey: Keys.favoriteCountry.rawValue)
        }
        get {
            return string(forKey: Keys.favoriteCountry.rawValue)
        }
        
    }
    var favoriteSources: [String]? {
        set {
            set(newValue, forKey: Keys.favoritesSources.rawValue)
        }
        get {
            return object(forKey: Keys.favoritesSources.rawValue) as? [String]
        }
    }
    
    var bookmarkedArticles: [ArticleViewModel]? {
        set {
            guard let value = newValue else {
                removeObject(forKey: Keys.bookmarkedArticles.rawValue)
                return
            }
            save(item: value, forKey: Keys.bookmarkedArticles.rawValue)
        }
        get {
            return read(forKey: Keys.bookmarkedArticles.rawValue)
        }
    }
    
    func bookmarkArticle(article: ArticleViewModel) {
        guard var articles = UserDefaults.standard.bookmarkedArticles else {
            UserDefaults.standard.bookmarkedArticles = [article]
            return
        }
        articles.append(article)
        UserDefaults.standard.bookmarkedArticles = articles
    }
    
    func removeArticle(article: ArticleViewModel) {
        guard var articles = UserDefaults.standard.bookmarkedArticles,
            let index = articles.firstIndex(where: {$0.title == article.title}) else {
            return
        }
        articles.remove(at: index)
        UserDefaults.standard.bookmarkedArticles = articles
    }
    
    
    
    func save<T: Codable>(item: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(item)
            set(data, forKey: key)
        } catch let error {
            assertionFailure("Failed to encode with error \(error)")
        }
    }

    func read<T: Codable>(forKey key: String) -> (T?) {
        if let savedObj = object(forKey: key) as? Data {
            do {
                let restoredItem = try JSONDecoder().decode(T.self, from: savedObj)
                return restoredItem
            } catch let error {
                assertionFailure("Failed to decode with error \(error)")
                return nil
            }
        }
        return nil
    }
}
