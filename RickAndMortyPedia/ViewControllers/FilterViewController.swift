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
    
    var url: URL!
    var filteredUrl: URL!
    var category: Category!
    
    var characterNameFilter = ""
    var characterStatusFilter = ""
    var characterSpeciesFilter = ""
    var characterTypeFilter = ""
    var characterGenderFilter = ""
    
    private let networkManager = NetworkManager.shared
    
    private var characters: Characters!
    private var locations: Locations!
    private var episodes: Episodes!
    
    private var numberOfRows = 0    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
        title = "Сортировать"
        
        setUpFilters()
        setUpPlaceholders()
    }
    
    // MARK: - IBActions
    @IBAction func clearButtonTapped() {
        
        characterNameTextField.text = ""
        characterStatusTextField.text = ""
        characterSpeciesTextField.text = ""
        characterTypeTextField.text = ""
        characterGenderTextField.text = ""
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
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
        fetchCharacters(from: filteredUrl)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contentListVC = segue.destination as? ContentListViewController else { return }
        contentListVC.category = category
        contentListVC.numberOfRows = numberOfRows
//        contentListVC.numberOfPages = numberOfPages
        contentListVC.characters = characters
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
    }
}

// MARK: - Filters
private extension FilterViewController {
    func setUpFilters() {
        characterNameTextField.text = characterNameFilter
        characterStatusTextField.text = characterStatusFilter
        characterSpeciesTextField.text = characterSpeciesFilter
        characterTypeTextField.text = characterTypeFilter
        characterGenderTextField.text = characterGenderFilter
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
        
        filteredUrl = URL(string: urlWithFilters)
    }
}

// MARK: - Networking
extension FilterViewController {
    private func fetchCharacters(from link: URL) {
        networkManager.fetch(Characters.self, from: link) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
                self?.numberOfRows = characters.results.count
                self?.performSegue(withIdentifier: "goToContentList", sender: nil)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(withStatus: .noContent)
                break
            }
        }
    }
}


