//
//  SortingViewController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 25.03.2023.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet var characterStackView: UIStackView!
    
    @IBOutlet var characterNameTextField: UITextField!
    @IBOutlet var characterStatusTextField: UITextField!
    @IBOutlet var characterSpeciesTextField: UITextField!
    @IBOutlet var characterTypeTextField: UITextField!
    @IBOutlet var characterGenderTextField: UITextField!
    
    @IBOutlet var locationStackView: UIStackView!
    
    @IBOutlet var locationNameTextField: UITextField!
    @IBOutlet var locationTypeTextField: UITextField!
    @IBOutlet var locationDimensionTextField: UITextField!
    
    @IBOutlet var episodeStackView: UIStackView!
    
    @IBOutlet var episodeNameTextField: UITextField!
    @IBOutlet var episodeCodeTextField: UITextField!
    
    var url: URL!
    var category: Category!
    
    var characterNameFilter = ""
    var characterStatusFilter = ""
    var characterSpeciesFilter = ""
    var characterTypeFilter = ""
    var characterGenderFilter = ""
    
    var locationNameFilter = ""
    var locationTypeFilter = ""
    var locationDimensionFilter = ""
    
    var episodeNameFilter = ""
    var episodeCodeFilter = ""
    
    private let networkManager = NetworkManager.shared
    
    private var characters: Characters!
    private var locations: Locations!
    private var episodes: Episodes!
    
    private var numberOfRows = 0
    private var numberOfPages = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
        title = category.title
        
        setUpFilters()
        setUpPlaceholders()
    }
    
    // MARK: - IBActions
    @IBAction func clearButtonTapped() {
        switch category {
        case .characters:
            characterNameTextField.text = ""
            characterStatusTextField.text = ""
            characterSpeciesTextField.text = ""
            characterTypeTextField.text = ""
            characterGenderTextField.text = ""
        case .locations:
            locationNameTextField.text = ""
            locationTypeTextField.text = ""
            locationDimensionTextField.text = ""
        default:
            episodeNameTextField.text = ""
            episodeCodeTextField.text = ""
        }
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        switch category {
        case .characters:
            if characterStatusTextField.text != "" &&
                characterStatusTextField.text != "alive" &&
                characterStatusTextField.text != "dead" &&
                characterStatusTextField.text != "unknown" {
                showAlert(withStatus: .wrongStatusInput)
                return
            }
            if characterGenderTextField.text != "" &&
                characterGenderTextField.text != "female" &&
                characterGenderTextField.text != "male" &&
                characterGenderTextField.text != "genderless" &&
                characterGenderTextField.text != "unknown" {
                showAlert(withStatus: .wrongStatusInput)
                return
            }
            filterCharacters()
            fetch(.characters)
        case .locations:
            filterLocations()
            fetch(.locations)
        default:
            filterEpisodes()
            fetch(.episodes)
        }
//        performSegue(withIdentifier: "goToContentList", sender: nil)
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contentListVC = segue.destination as? ContentListViewController else { return }
        contentListVC.category = category
        contentListVC.numberOfRows = numberOfRows
        contentListVC.numberOfPages = numberOfPages
        switch category {
        case .characters:
            contentListVC.characters = characters
        case .locations:
            contentListVC.locations = locations
        default:
            contentListVC.episodes = episodes
        }
        contentListVC.tableView.reloadData()
    }
}

// MARK: - Setup placeholders
private extension FilterViewController {
    func changePlaceholderTextColor(in textField: UITextField, for text: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.6796290874, blue: 0, alpha: 1)]
        )
    }
    func setUpPlaceholders() {
        changePlaceholderTextColor(in: characterNameTextField, for: "Name")
        changePlaceholderTextColor(in: characterStatusTextField, for: "Alive, dead or unknown")
        changePlaceholderTextColor(in: characterSpeciesTextField, for: "Species")
        changePlaceholderTextColor(in: characterTypeTextField, for: "Type")
        changePlaceholderTextColor(in: characterGenderTextField, for: "Female, male, genderless or unknown")
        
        changePlaceholderTextColor(in: locationNameTextField, for: "Name")
        changePlaceholderTextColor(in: locationTypeTextField, for: "Type")
        changePlaceholderTextColor(in: locationDimensionTextField, for: "Dimension")
        
        changePlaceholderTextColor(in: episodeNameTextField, for: "Name")
        changePlaceholderTextColor(in: episodeCodeTextField, for: "S01E01")
    }
}

// MARK: - Filters
private extension FilterViewController {
    func setUpFilters() {
        switch category {
        case .characters:
            characterNameTextField.text = characterNameFilter
            characterStatusTextField.text = characterStatusFilter
            characterSpeciesTextField.text = characterSpeciesFilter
            characterTypeTextField.text = characterTypeFilter
            characterGenderTextField.text = characterGenderFilter
            
            locationStackView.isHidden = true
            episodeStackView.isHidden = true
        case .locations:
            locationNameTextField.text = locationNameFilter
            locationTypeTextField.text = locationTypeFilter
            locationDimensionTextField.text = locationDimensionFilter
            
            characterStackView.isHidden = true
            episodeStackView.isHidden = true
        default:
            episodeNameTextField.text = episodeNameFilter
            episodeCodeTextField.text = episodeCodeFilter
            
            characterStackView.isHidden = true
            locationStackView.isHidden = true
        }
    }
    
    func filter(by query: String, with textField: UITextField, url urlWithFilters: inout String, count filtersCount: inout Int) {
        if textField.text != "" {
            if filtersCount == 0 {
                urlWithFilters = "\(urlWithFilters)/?\(query)=\(textField.text ?? "")"
                filtersCount += 1
            } else if filtersCount != 0 {
                urlWithFilters = "\(urlWithFilters)&\(query)=\(textField.text ?? "")"
                filtersCount += 1
            }
        }
    }
    
    func filterCharacters() {
        guard let temporaryUrl = url else { return }
        var urlWithFilters = String(describing: temporaryUrl)
        var filtersCount = 0
        
        filter(by: "name", with: characterNameTextField, url: &urlWithFilters, count: &filtersCount)
        filter(by: "status", with: characterStatusTextField, url: &urlWithFilters, count: &filtersCount)
        filter(by: "species", with: characterSpeciesTextField, url: &urlWithFilters, count: &filtersCount)
        filter(by: "type", with: characterTypeTextField, url: &urlWithFilters, count: &filtersCount)
        filter(by: "gender", with: characterGenderTextField, url: &urlWithFilters, count: &filtersCount)
        
        url = URL(string: urlWithFilters)
    }
    
    func filterLocations() {
        guard let temporaryUrl = url else { return }
        var urlWithFilters = String(describing: temporaryUrl)
        var filtersCount = 0
        
        filter(by: "name", with: locationNameTextField, url: &urlWithFilters, count: &filtersCount)
        filter(by: "type", with: locationTypeTextField, url: &urlWithFilters, count: &filtersCount)
        filter(by: "dimension", with: locationDimensionTextField, url: &urlWithFilters, count: &filtersCount)
        
        url = URL(string: urlWithFilters)
    }
    
    func filterEpisodes() {
        guard let temporaryUrl = url else { return }
        var urlWithFilters = String(describing: temporaryUrl)
        var filtersCount = 0
        
        filter(by: "name", with: episodeNameTextField, url: &urlWithFilters, count: &filtersCount)
        filter(by: "episode", with: episodeCodeTextField, url: &urlWithFilters, count: &filtersCount)
        
        url = URL(string: urlWithFilters)
    }
}

// MARK: - Networking
extension FilterViewController {
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
                self?.performSegue(withIdentifier: "goToContentList", sender: nil)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(withStatus: .noContent)
                break
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
                self?.performSegue(withIdentifier: "goToContentList", sender: nil)
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
                self?.performSegue(withIdentifier: "goToContentList", sender: nil)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
}


