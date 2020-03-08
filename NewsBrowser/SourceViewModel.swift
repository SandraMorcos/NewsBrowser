//
//  SourceViewModel.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/8/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import Foundation

struct SourceViewModel {
    let name: String?
    let id: String?
    var isSelected = false
    init(model: Source) {
        name = model.name
        id = model.id
    }
}

