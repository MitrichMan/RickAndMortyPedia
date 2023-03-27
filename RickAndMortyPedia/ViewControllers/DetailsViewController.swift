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
    
    var character: Character!
    var episodes: [Episode] = []
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
        contentTextView.text = getDetails()
        getImage()
        getEpisodes(from: character.episode)
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
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let episodesVC = navigationVC.topViewController as? EpisodesViewController else { return }
        episodesVC.episodes = episodes
    }
}

// MARK: - Networking
extension DetailsViewController {
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
    
    private func fetchEpisodes(from link: URL) {
        networkManager.fetch(Episode.self, from: link) { [weak self] result in
            switch result {
            case .success(let episode):
                self?.episodes.append(episode)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }
    }

private func getEpisodes(from links: [String]) {
    for link in links {
        guard let url = URL(string: link) else { return }
        fetchEpisodes(from: url)
    }
}
    
}


