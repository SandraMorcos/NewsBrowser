//
//  SourcesRepository.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/8/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import Foundation

class SourcesRepository {
    static var sourcesList: [SourceViewModel]?
    func retrieveSources(then completion: @escaping ([SourceViewModel]?, NewsApiError?) -> Void ) {
        DataLoader().request(.sources()) { (response, error) in
            guard let response = response,
                let sources = response.sources else {
                    completion(nil, error) 
                    return
            }
            var sourcesList = [SourceViewModel]()
            for source in sources {
                sourcesList.append(SourceViewModel(model: source))
            }
            SourcesRepository.sourcesList = sourcesList
            completion(sourcesList, error)
        }
    }
}
