//
//  DataLoader.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/5/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import Foundation

enum NewsApiError: String {
    case invalidURL
    case noDataAvailable
    case parsingError
}

class DataLoader {
    func request(_ request: ArticlesRequest,
                 then completion: @escaping (Response?, NewsApiError?)->Void) {
        guard let url = request.requestURL else {
            completion(nil, .invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil, .noDataAvailable)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, .parsingError)
            }
        }
        dataTask.resume()
    }
}
