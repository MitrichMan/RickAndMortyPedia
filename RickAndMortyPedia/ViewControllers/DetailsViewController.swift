//
//  DetailsViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 23.03.2023.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var characterImageView: UIImageView!
    
    var category: Category!
    var character: Character!
    var location: Location!
    var episode: Episode!
    var episodes: [Episode] = []
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
        contentTextView.text = getDetails()
        getImage()
        title = character.name
    }
    
    // MARK: - private methods
    private func getDetails() -> String {
        let details = """
Имя: \(character.name)
Статус: \(character.status)
Вид: \(character.species)
Тип: \(character.type)
Пол: \(character.gender)
Происхождение: \(character.origin.name)
Последнее известное местоположение: \(character.location.name)
Дата внесения в базу: \(character.created)
"""
        
        return details
    }
    
    private func getImage() {
        networkManager.fetchImage(from: character.image) { [weak self] result in
            switch result {
            case .success(let image):
                self?.characterImageView.image = UIImage(data: image)
            case .failure(let error):
                print(error)
            }
        }
    }
}




