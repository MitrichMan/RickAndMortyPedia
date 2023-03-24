//
//  DetailsViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 23.03.2023.
//

import UIKit

final class DetailsViewController: UIViewController {
    
//    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var contentTextView: UITextView!
    let imageView = UIImageView()
    
    var categoryName: CategoryNames!
    var character: Character!
    var location: Location!
    var episode: Episode!
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
//        contentTextView.backgroundColor.
        contentTextView.text = getDetails()
        
        switch categoryName {
        case .characters:
            title = character.name
        case .locations:
            title = location.name
        default:
            title = episode.name
        }
    }

}

extension DetailsViewController {
    private func getDetails() -> String {
        var details = """
"""
        
        switch categoryName {
        case .characters:
            imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            contentTextView.textContainer.exclusionPaths = [UIBezierPath(rect: imageView.frame)]
            contentTextView.addSubview(imageView)
            networkManager.fetchImage(from: character.image) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.imageView.image = UIImage(data: image)
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
\(character.origin.url)
Последнее известное местоположение: \(character.location.name)
\(character.location.url)
Появлялся в эпизодах: \(character.episode[0])
Дата внесения в базу: \(character.created)
"""
        case .locations:
            details = """
Название: \(location.name)
Тип: \(location.type)
Измерение: \(location.dimension)
Резиденты: \(location.residents[0])
Дата внесения в базу: \(location.created)
"""
        default:
            details = """
Название: \(episode.name)
Дата выхода в эфир: \(episode.air_date)
Код эпизода: \(episode.episode)
Список персонажей, замеченых в эпизоде: \(episode.characters[0])
Дата внесения в базу: \(episode.created)
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [URL]
    let url: URL
    let created: String
"""
        }
        return details
    }
}
