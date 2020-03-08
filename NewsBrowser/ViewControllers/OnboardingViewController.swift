//
//  OnboardingViewController.swift
//  NewsApp
//
//  Created by Sandra Morcos on 3/7/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var countriesPickerView: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    
    var countries = [String]()
    var selectedCountry = ""
    let repository = CountriesRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        countries = repository.countryNames()
        selectedCountry = countries[0]
        nextButton.layer.cornerRadius = 6
        nextButton.layer.borderWidth = 2
        nextButton.layer.borderColor = UIColor.maroon(alpha: 1).cgColor
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func countrySelected(_ sender: UIButton) {
        UserDefaults.standard.favoriteCountry = repository.countryCodes[selectedCountry]
    }
    

}

extension OnboardingViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
}

extension OnboardingViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countries[row]
    }
}
