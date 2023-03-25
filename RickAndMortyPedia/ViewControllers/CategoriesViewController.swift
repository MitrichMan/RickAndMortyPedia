//
//  CategoriesViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 23.03.2023.
//

import UIKit

final class CategoriesViewController: UICollectionViewController {
    
    private let networkManager = NetworkManager.shared
    private let categoryNames = Category.allCases
    private var categories: Categories!
    
    private var contentUrl: URL!
    private var contentCategory: Category!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
        fetchCategories()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contentListVC = segue.destination as? ContentListViewController
        contentListVC?.url = contentUrl
        contentListVC?.fetch(contentCategory)
        contentListVC?.categories = categories
        contentListVC?.category = contentCategory
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        guard let cell = cell as? CategoryCell else { return UICollectionViewCell() }
        cell.nameLabel.text = categoryNames[indexPath.item].title
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryButton = categoryNames[indexPath.item]
        
        switch categoryButton {
        case .characters:
            contentUrl = categories.characters
            contentCategory = Category.characters
        case .locations:
            contentUrl = categories.locations
            contentCategory = Category.locations
        case .episodes:
            contentUrl = categories.episodes
            contentCategory = Category.episodes
        }
        performSegue(withIdentifier: "goToContentList", sender: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: UIScreen.main.bounds.width - 80, height: 130)
    }
}

// MARK: - Networking
extension CategoriesViewController {
    private func fetchCategories() {
        networkManager.fetch(Categories.self, from: Link.base.url) { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
}
