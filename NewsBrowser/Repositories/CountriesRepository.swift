//
//  CountriesRepository.swift
//  NewsApp
//
//  Created by Sandra Morcos on 3/7/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import Foundation

class CountriesRepository {
    
    var countryCodes = [String: String]()
    
    private let url = Bundle.main.url(forResource: "CountryCodes", withExtension: "json")
    
    func countryNames() -> [String] {
        loadCountries()
        guard !countryCodes.isEmpty else { return [] }
        var countries = [String]()
        for country in countryCodes {
            countries.append(country.key)
        }
        countries.sort()
        return countries
    }
    
    private func loadCountries() {
        guard let url = url,
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: String] else { return }
        countryCodes = dictionary
    }
    
}
