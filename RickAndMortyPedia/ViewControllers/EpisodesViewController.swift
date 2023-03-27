//
//  EpisodesViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 27.03.2023.
//

import UIKit

class EpisodesViewController: UITableViewController {
    
    let networkManager = NetworkManager.shared
    
    var episodeLinks: [String]!
    var episodes: [Episode]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension EpisodesViewController {
//        private func fetchEpisodes(from link: URL) {
//            networkManager.fetch(Episode.self, from: link) { [weak self] result in
//                switch result {
//                case .success(let episode):
//                    self?.episodes.append(episode)
//                    self?.tableView.reloadData()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    self?.showAlert(withStatus: .failed)
//                }
//            }
//        }
//
//    private func getEpisodes(from links: [String]) {
//        for link in links {
//            guard let url = URL(string: link) else { return }
//            fetchEpisodes(from: url)
//        }
//    }
}

