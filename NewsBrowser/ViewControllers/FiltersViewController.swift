//
//  FiltersViewController.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/8/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import UIKit

protocol FilteredSearchDelegate: AnyObject {
    func addFilter(source: SourceViewModel)
    func removeFilter(source: SourceViewModel)
}

class FiltersViewController: UIViewController {

    let cellID = "filterCellID"
    var dataSource = [SourceViewModel]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: FilteredSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        guard let list = SourcesRepository.sourcesList else {
            fetchData()
            return
        }
        dataSource = list
        collectionView.reloadData()
    }
    
    func fetchData() {
        SourcesRepository().retrieveSources { [weak self] (sources, _) in
            guard let sources = sources else {
                    return
            }
            guard let self = self else { return }
            self.dataSource = sources
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            
            }
        }
    }
    
    func setupUI() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = view.frame.width - 20
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: screenWidth/2, height: 50)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        collectionView.collectionViewLayout = layout
        doneButton.layer.cornerRadius = 4
        doneButton.layer.borderColor = UIColor.maroon(alpha: 1).cgColor
        doneButton.layer.borderWidth = 2
    }
    
    @IBAction func returnToSearch(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension FiltersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.sourceName.text = dataSource[indexPath.row].name
        if dataSource[indexPath.row].isSelected {
            cell.backgroundColor = .maroon(alpha: 1)
            cell.sourceName.textColor = .white
        } else {
            cell.backgroundColor = .white
            cell.sourceName.textColor = .black
        }
        return cell
        
        
    }
    
    
}

extension FiltersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource[indexPath.row].isSelected = !dataSource[indexPath.row].isSelected
        let source = dataSource[indexPath.row]
        if source.isSelected {
            delegate?.addFilter(source: source)
        } else {
            delegate?.removeFilter(source: source)
        }
        collectionView.reloadItems(at: [indexPath])
        SourcesRepository.sourcesList?[indexPath.row].isSelected = source.isSelected
    }
}
