//
//  Response.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/5/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import Foundation

struct Response: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
    let sources: [Source]?
}

