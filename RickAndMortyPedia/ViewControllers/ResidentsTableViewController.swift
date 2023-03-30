//
//  ResidentsTableViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 27.03.2023.
//

import UIKit

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
        fetchResidents(from: episode.characters)
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
    private func fetchResidents(from links: [String]) {
        networkManager.fetchResidents(from: links) { [weak self] result in
            switch result {
            case .success(let residents):
                self?.characters = residents
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showAlert(withStatus: .noContent)
                print(error.localizedDescription)
            }
        }
    }
}

