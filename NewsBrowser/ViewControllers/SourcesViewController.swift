//
//  SourcesViewController.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/7/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import UIKit

class SourcesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var browseHeadlinesButton: UIButton!

    var sources = [SourceViewModel]()
    let cellID = "sourceTableViewCellID"
    var selectedSources = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SourcesRepository().retrieveSources { [weak self] (sources, _) in
            guard let sources = sources else {
                    return
            }
            guard let self = self else { return }
            self.sources = sources
            DispatchQueue.main.async {
                self.tableView.reloadData()
            
            }
        }
        browseHeadlinesButton.layer.cornerRadius = 4
        browseHeadlinesButton.layer.borderWidth = 2
        browseHeadlinesButton.layer.borderColor = UIColor.maroon(alpha: 1).cgColor
    }

    @IBAction func selectionCompleted(_ sender: UIButton) {
        UserDefaults.standard.favoriteSources = selectedSources
        for source in selectedSources {
            guard let sources = SourcesRepository.sourcesList,
                let index = sources.firstIndex(where: {$0.id == source}) else { continue }
            SourcesRepository.sourcesList?[index].isSelected = true
        }
        let storyboard = UIStoryboard(name: Storyboards.main.rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }
        let window = UIApplication.shared.windows.first
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
extension SourcesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) else { return UITableViewCell() }
        let source = sources[indexPath.row]
        cell.textLabel?.text = source.name
        cell.accessoryType = source.isSelected ? .checkmark : .none
        cell.accessoryView?.backgroundColor = .maroon(alpha: 1)
        return cell
    }
}

extension SourcesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let source = sources[indexPath.row]
        guard selectedSources.count < 3 || source.isSelected else {
            let alert = UIAlertController(title: "You have already selected three sources",
                                          message: "You can unselect one of the previously selected sources by clicking on it once more",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        guard let sourceID = source.id else { return }
        sources[indexPath.row].isSelected = !source.isSelected
        tableView.reloadRows(at: [indexPath], with: .none)
        if sources[indexPath.row].isSelected {
            selectedSources.append(sourceID)
        } else {
            guard let index = selectedSources.firstIndex(of: sourceID) else { return }
            selectedSources.remove(at: index)
        }
    }
}
