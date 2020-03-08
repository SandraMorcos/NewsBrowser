//
//  ArticlesRequest.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/5/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import Foundation

enum Endpoint: String {
    case headlines = "top-headlines"
    case sources
}

enum RequestParameter: String {
    case category
    case language
    case country
    case sources
    case query = "q"
    case pageSize
    case page
    case apiKey
    case sortBy
}

struct ArticlesRequest {
    
    let apiKey = "f21ce6f8bf994dc6b7f8f456d92bcbe3"
    let scheme = "http"
    let host = "newsapi.org"
    var endpoint: Endpoint
    var params: [RequestParameter: String]
    
    var requestURL: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "/v2/\(endpoint.rawValue)"
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: RequestParameter.apiKey.rawValue, value: apiKey))
        for param in params {
            let queryItem = URLQueryItem(name: param.key.rawValue, value: param.value)
            queryItems.append(queryItem)
        }
        components.queryItems = queryItems
        return components.url
    }
    
    init(endpoint: Endpoint, params: [RequestParameter: String]) {
        self.endpoint = endpoint
        self.params = params
    }
    
    static func search(matching query: String, sources: [String]) -> ArticlesRequest {
        var params = [RequestParameter: String]()
        params[.query] = query
        params[.country] = Constants.favoriteCountry
        var sourcesString = ""
        for source in sources {
            sourcesString += "\(source),"
        }
        return ArticlesRequest(endpoint: .headlines, params: params)
    }
    
    static func headlines(pageNumber: Int, pageSize: Int) -> ArticlesRequest {
        var params = [RequestParameter: String]()
        params[.country] = Constants.favoriteCountry
        params[.pageSize] = "\(pageSize)"
        params[.page] = "\(pageNumber)"
        return ArticlesRequest(endpoint: .headlines, params: params)
    }
    
    static func sources() -> ArticlesRequest {
        var params = [RequestParameter: String]()
        params[.country] = Constants.favoriteCountry
        return ArticlesRequest(endpoint: .sources, params: params)
    }
    
    
}
