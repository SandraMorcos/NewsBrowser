//
//  Article.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/8/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import Foundation

struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
