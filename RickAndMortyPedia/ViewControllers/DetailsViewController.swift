//
//  DetailsViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 23.03.2023.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet var contentTextView: UITextView!
    let characterImageView = UIImageView()
    
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
        
        switch category {
        case .characters:
            title = character.name
        case .locations:
            title = location.name
        default:
            title = episode.name
        }
    }

    // MARK: - private methods
    private func getDetails() -> String {
        var details = """
"""
        
        switch category {
        case .characters:
            characterImageView.frame = CGRect(x: 0, y: 0, width: 145, height: 145)
            contentTextView.textContainer.exclusionPaths = [UIBezierPath(rect: characterImageView.frame)]
            contentTextView.addSubview(characterImageView)
            networkManager.fetchImage(from: character.image) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.characterImageView.image = UIImage(data: image)
                case .failure(let error):
                    print(error)
                }
            }
            details = """
Имя: \(character.name)
Статус: \(character.status)
Вид: \(character.species)
Тип: \(character.type)
Пол: \(character.gender)
Происхождение: \(character.origin.name)
Последнее известное местоположение: \(character.location.name)
Дата внесения в базу: \(character.created)
"""
        case .locations:
            details = """
Название: \(location.name)
Тип: \(location.type)
Измерение: \(location.dimension)
Дата внесения в базу: \(location.created)
"""
        default:
            details = """
Название: \(episode.name)
Дата выхода в эфир: \(episode.airDate)
Код эпизода: \(episode.episode)
Дата внесения в базу: \(episode.created)
"""
        }
        return details
    }

}


