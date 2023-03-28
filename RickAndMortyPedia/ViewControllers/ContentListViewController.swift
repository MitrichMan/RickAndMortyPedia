//
//  ContentListViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 23.03.2023.
//

import UIKit
import Alamofire

final class ContentListViewController: UITableViewController {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    
    var url: URL!
        
    var characters: Characters!
    
    var numberOfRows = 0
    
    private let networkManager = NetworkManager.shared
    
    private var characterNameFilter = ""
    private var characterStatusFilter = ""
    private var characterSpeciesFilter = ""
    private var characterTypeFilter = ""
    private var characterGenderFilter = ""
    
    private var locationNameFilter = ""
    private var locationTypeFilter = ""
    private var locationDimensionFilter = ""
    
    private var episodeNameFilter = ""
    private var episodeCodeFilter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
        title = "Characters"
        fetchCharacters(from: Link.characters.url)
    }
    
    
    // MARK: - IBActions
    @IBAction func filterButtonTapped(_ sender: Any) {
        url = Link.characters.url
        performSegue(withIdentifier: "goToFilter", sender: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        guard let prevLink = characters.info.prev, let prevLinkUrl = URL(string: prevLink) else { return }
        fetchCharacters(from: prevLinkUrl)
    }

    @IBAction func forwardButtonTapped(_ sender: Any) {
        guard let nextLink = characters.info.next, let nextLinkUrl = URL(string: nextLink) else { return }
        fetchCharacters(from: nextLinkUrl)
    }
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard let filterVC = segue.source as? FilterViewController else { return }
        characterNameFilter = filterVC.characterNameTextField.text ?? ""
        characterStatusFilter = filterVC.characterStatusTextField.text ?? ""
        characterSpeciesFilter = filterVC.characterSpeciesTextField.text ?? ""
        characterTypeFilter = filterVC.characterTypeTextField.text ?? ""
        characterGenderFilter = filterVC.characterGenderTextField.text ?? ""
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        guard let cell = cell as? CharacterCell else { return UITableViewCell() }
        cell.characterNameLabel.text = characters.results[indexPath.row].name
        networkManager.fetchImage(from: characters.results[indexPath.row].image) { result in
            switch result {
            case .success(let image):
                cell.characterImageView.image = UIImage(data: image)
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetails", sender: characters.results[indexPath.row])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            guard let detailsVC = segue.destination as? DetailsViewController else { return }
            detailsVC.character = sender as? Character
        } else {
            guard let filterVC = segue.destination as? FilterViewController else { return }
            filterVC.url = url
            filterVC.characterNameFilter = characterNameFilter
            filterVC.characterSpeciesFilter = characterSpeciesFilter
            filterVC.characterStatusFilter = characterStatusFilter
            filterVC.characterTypeFilter = characterTypeFilter
            filterVC.characterGenderFilter = characterGenderFilter
        }
    }
}
    
    // MARK: - Networking
extension ContentListViewController {
private func fetchCharacters(from link: URL) {
    AF.request(link)
        .responseJSON { [weak self] dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return }
            if (200..<300).contains(statusCode) {
                guard let charactersData = dataResponse.value as? [String: Any] else { return }
                guard let charactersInfo = charactersData["info"] as? [String: Any] else { return }
                guard let charactersResults = charactersData["results"] as? [[String: Any]] else { return }
                
                var results: [Character] = []
                
                for charactersResult in charactersResults {
                    guard let characterOrigin = charactersResult["origin"] as? [String: Any] else { return }
                    guard let characterLocation = charactersResult["location"] as? [String: Any] else { return }
                    
                    let origin = CharacterLocation(
                        name: characterOrigin["name"] as? String ?? "",
                        url: characterOrigin["url"] as? String ?? ""
                    )
                    
                    let location = CharacterLocation(
                        name: characterLocation["name"] as? String ?? "",
                        url: characterLocation["url"] as? String ?? ""
                    )
                    
                    let result = Character(
                        name: charactersResult["name"] as? String ?? "",
                        status: charactersResult["status"] as? String ?? "",
                        species: charactersResult["species"] as? String ?? "",
                        type: charactersResult["type"] as? String ?? "",
                        gender: charactersResult["gender"] as? String ?? "",
                        origin: origin,
                        location: location,
                        image: charactersResult["image"] as? String ?? "",
                        episode: charactersResult["episode"] as? [String] ?? [],
                        url: charactersResult["url"] as? String ?? "",
                        created: charactersResult["created"] as? String ?? ""
                    )
                    
                    results.append(result)
                }
                let characters = Characters(
                    info: Info(
                        count: charactersInfo["count"] as? Int ?? 0,
                        pages: charactersInfo["pages"] as? Int ?? 0,
                        next: charactersInfo["next"] as? String ?? "",
                        prev: charactersInfo["prev"] as? String ?? ""
                    ),
                    results: results
                )
                self?.characters = characters
                self?.numberOfRows = characters.results.count
                self?.tableView.reloadData()
            }
            guard let error = dataResponse.error else { return }
            print(error.localizedDescription)
            
        }
}
        
        //        private func fetchCharacters(from link: URL) {
        //            networkManager.fetch(Characters.self, from: link) { [weak self] result in
        //                switch result {
        //                case .success(let characters):
        //                    self?.characters = characters
        //                    self?.numberOfRows = characters.results.count
        //                    self?.tableView.reloadData()
        //                case .failure(let error):
        //                    print(error.localizedDescription)
        //                    self?.showAlert(withStatus: .failed)
        //                }
        //            }
        //        }
        //    private func fetchEpisodes(from link: URL) {
        //        networkManager.fetch(Episodes.self, from: link) { [weak self] result in
        //            switch result {
        //            case .success(let episodes):
        //                self?.episodes = episodes
        //                self?.numberOfRows = episodes.results.count
        //                self?.numberOfPages = episodes.info.pages
        //                self?.tableView.reloadData()
        //            case .failure(let error):
        //                print(error.localizedDescription)
        //                self?.showAlert(withStatus: .failed)
        //            }
        //        }
        //    }
    }
