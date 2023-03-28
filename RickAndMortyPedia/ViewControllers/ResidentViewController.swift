//
//  ResidentViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 28.03.2023.
//

import UIKit

final class ResidentViewController: UIViewController {
    
    @IBOutlet var residentDetailsTextView: UITextView!
    @IBOutlet var residentImageView: UIImageView!
    
    let networkManager = NetworkManager.shared
    
    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
        residentDetailsTextView.text = getDetails()
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
}

// MARK: - Networking
extension ResidentViewController {
    private func getImage() {
        networkManager.fetchImage(from: character.image) { [weak self] result in
            switch result {
            case .success(let image):
                self?.residentImageView.image = UIImage(data: image)
            case .failure(let error):
                print(error)
            }
        }
    }
}

