//
//  EpisodesViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 27.03.2023.
//

import UIKit

final class EpisodesViewController: UITableViewController {
    
    let networkManager = NetworkManager.shared
    
    var episodeLinks: [String]!
    var episodes: [Episode]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
        title = "Эпизоды" 
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        guard let cell = cell as? ContentCell else { return UITableViewCell() }
        cell.nameLabel.text = episodes[indexPath.row].name
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToResidents", sender: episodes[indexPath.row])
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard let residentsVC = segue.destination as? ResidentsTableViewController else { return }
         residentsVC.episode = sender as? Episode 
     }
}
