//
//  ContentListViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 23.03.2023.
//

import UIKit

final class ContentListViewController: UITableViewController {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    
    var url: URL!
    
    var categories: Categories!
    var category: Category!
    
    var characters: Characters!
    var locations: Locations!
    var episodes: Episodes!
    
     var numberOfRows = 0
     var numberOfPages = 0
    
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
        title = category.title
        setUpNavigationBar()
    }

    
    // MARK: - IBActions
    @IBAction func filterButtonTapped(_ sender: Any) {
        switch category {
        case .characters:
            url = categories.characters
        case .locations:
            url = categories.locations
        default:
            url = categories.episodes
        }
        performSegue(withIdentifier: "goToFilter", sender: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        switch category {
        case .characters:
            guard let prevLink = characters.info.prev, let prevLinkUrl = URL(string: prevLink) else { return }
            fetchCharacters(from: prevLinkUrl)
        case . locations:
            guard let prevLink = locations.info.prev, let prevLinkUrl = URL(string: prevLink) else { return }
            fetchLocations(from: prevLinkUrl)
        default:
            guard let prevLink = episodes.info.prev, let prevLinkUrl = URL(string: prevLink) else { return }
            fetchEpisodes(from: prevLinkUrl)
        }
    }

    @IBAction func forwardButtonTapped(_ sender: Any) {
        switch category {
        case .characters:
            guard let nextLink = characters.info.next, let nextLinkUrl = URL(string: nextLink) else { return }
            fetchCharacters(from: nextLinkUrl)
        case . locations:
            guard let nextLink = locations.info.next, let nextLinkUrl = URL(string: nextLink) else { return }
            fetchLocations(from: nextLinkUrl)
        default:
            guard let nextLink = episodes.info.next, let nextLinkUrl = URL(string: nextLink) else { return }
            fetchEpisodes(from: nextLinkUrl)
        }
    }
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard let filterVC = segue.source as? FilterViewController else { return }
        switch category {
        case .characters:
            characterNameFilter = filterVC.characterNameTextField.text ?? ""
            characterStatusFilter = filterVC.characterStatusTextField.text ?? ""
            characterSpeciesFilter = filterVC.characterSpeciesTextField.text ?? ""
            characterTypeFilter = filterVC.characterTypeTextField.text ?? ""
            characterGenderFilter = filterVC.characterGenderTextField.text ?? ""
        case .locations:
            locationNameFilter = filterVC.locationNameTextField.text ?? ""
            locationTypeFilter = filterVC.locationTypeTextField.text ?? ""
            locationDimensionFilter = filterVC.episodeNameTextField.text ?? ""
        default:
            episodeNameFilter = filterVC.episodeCodeTextField.text ?? ""
            episodeCodeFilter = filterVC.characterNameTextField.text ?? ""
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows
    }

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         var cell: UITableViewCell
         
         switch category {
         case .characters:
            cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
             guard let cell = cell as? CharacterCell else { return UITableViewCell() }
             cell.characterNameLabel.text = getNameForCell(at: indexPath.row)
             networkManager.fetchImage(from: characters.results[indexPath.row].image) { result in
                 switch result {
                 case .success(let image):
                     cell.characterImageView.image = UIImage(data: image)
                 case .failure(let error):
                     print(error)
                 }
             }
         case .locations:
             cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
             guard let cell = cell as? ContentCell else { return UITableViewCell() }
             cell.contentNameLabel.text = locations.results[indexPath.row].name
         default:
             cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
             guard let cell = cell as? ContentCell else { return UITableViewCell() }
             cell.contentNameLabel.text = episodes.results[indexPath.row].name
         }
         return cell
     }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch category {
        case .characters:
            let character = characters.results[indexPath.row]
            performSegue(withIdentifier: "goToDetails", sender: character)
        case .locations:
            let location = locations.results[indexPath.row]
            performSegue(withIdentifier: "goToDetails", sender: location)
        default:
            let episode = episodes.results[indexPath.row]
            performSegue(withIdentifier: "goToDetails", sender: episode)
        }
    }
    
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            guard let detailsVC = segue.destination as? DetailsViewController else { return }
            detailsVC.category = category
            switch category {
            case .characters:
                detailsVC.character = sender as? Character
            case .locations:
                detailsVC.location = sender as? Location
            default:
                detailsVC.episode = sender as? Episode
            }
        } else {
            guard let filterVC = segue.destination as? FilterViewController else { return }
            filterVC.url = url
            filterVC.category = category
            switch category {
            case .characters:
                filterVC.characterNameFilter = characterNameFilter
                filterVC.characterSpeciesFilter = characterSpeciesFilter
                filterVC.characterStatusFilter = characterStatusFilter
                filterVC.characterTypeFilter = characterTypeFilter
                filterVC.characterGenderFilter = characterGenderFilter
            case .locations:
                filterVC.locationNameFilter = locationNameFilter
                filterVC.locationTypeFilter = locationTypeFilter
                filterVC.locationDimensionFilter = locationDimensionFilter
            default:
                filterVC.episodeNameFilter = episodeNameFilter
                filterVC.episodeCodeFilter = episodeCodeFilter
            }
        }
    }
    
    // MARK: - Private Methods
    private  func setUpNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func getNameForCell(at indexPath: Int) -> String {
        var name = ""
        
        switch category {
        case .characters:
            name = characters.results[indexPath].name
        case .locations:
            name = locations.results[indexPath].name
        default:
            name = episodes.results[indexPath].name
        }
        return name
    }
}

// MARK: - Networking
extension ContentListViewController {
    func fetch(_ category: Category) {
        switch category {
        case .characters:
            fetchCharacters(from: url)
        case .locations:
            fetchLocations(from: url)
        default:
            fetchEpisodes(from: url)
        }
    }
    
    private func fetchCharacters(from link: URL) {
        networkManager.fetch(Characters.self, from: link) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
                self?.numberOfRows = characters.results.count
                self?.numberOfPages = characters.info.pages
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
    
    private func fetchLocations(from link: URL) {
        networkManager.fetch(Locations.self, from: link) { [weak self] result in
            switch result {
            case .success(let locations):
                self?.locations = locations
                self?.numberOfRows = locations.results.count
                self?.numberOfPages = locations.info.pages
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
    
    private func fetchEpisodes(from link: URL) {
        networkManager.fetch(Episodes.self, from: link) { [weak self] result in
            switch result {
            case .success(let episodes):
                self?.episodes = episodes
                self?.numberOfRows = episodes.results.count
                self?.numberOfPages = episodes.info.pages
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
}
