//
//  ResidentsTableViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 27.03.2023.
//

import UIKit
import Alamofire

final class ResidentsTableViewController: UITableViewController {
    
    @IBOutlet var episodeDetailsLabel: UILabel!
    
    let networkManager = NetworkManager.shared
    
    var episode: Episode!
    var characters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
        title = episode.name
        episodeDetailsLabel.text = getEpisodeDetails()
        fetchCharacter(from: episode.characters)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "residentsCell", for: indexPath)
        guard let cell = cell as? ResidentsCell else { return UITableViewCell() }
        cell.residentNameLabel.text = characters[indexPath.row].name
        networkManager.fetchImage(from: characters[indexPath.row].image) { result in
            switch result {
            case .success(let image):
                cell.residentImageView.image = UIImage(data: image)
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToResident", sender: characters[indexPath.row])
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let residentVC = segue.destination as? ResidentViewController else { return }
        residentVC.character = sender as? Character
    }

    // MARK: - Private Methods
    private func getEpisodeDetails() -> String {
        let episodeDetails = """
Episode code: \(episode.episode)
Date: \(episode.airDate)
Residents:
"""
        
        return episodeDetails
    }
}

// MARK: - Networking
extension ResidentsTableViewController {
    private func fetchCharacter(from links: [URL]) {
        for link in links {
        AF.request(link)
            .responseJSON { [weak self] dataResponse in
                guard let statusCode = dataResponse.response?.statusCode else { return }
                if (200..<300).contains(statusCode) {
                    guard let characterData = dataResponse.value as? [String: Any] else { return }
                    guard let characterOrigin = characterData["origin"] as? [String: Any] else { return }
                    guard let characterLocation = characterData["location"] as? [String: Any] else { return }
                    
                    
                    let origin = CharacterLocation(
                        name: characterOrigin["name"] as? String ?? "",
                        url: characterOrigin["url"] as? String ?? ""
                    )
                    
                    let location = CharacterLocation(
                        name: characterLocation["name"] as? String ?? "",
                        url: characterLocation["url"] as? String ?? ""
                    )
                    
                    let character = Character(
                        name: characterData["name"] as? String ?? "",
                        status: characterData["status"] as? String ?? "",
                        species: characterData["species"] as? String ?? "",
                        type: characterData["type"] as? String ?? "",
                        gender: characterData["gender"] as? String ?? "",
                        origin: origin,
                        location: location,
                        image: characterData["image"] as? String ?? "",
                        episode: characterData["episode"] as? [String] ?? [],
                        url: characterData["url"] as? String ?? "",
                        created: characterData["created"] as? String ?? ""
                    )
                    self?.characters.append(character)
                    self?.tableView.reloadData()
                }
                guard let error = dataResponse.error else { return }
                    print(error.localizedDescription)
            }
        }
    }
}

