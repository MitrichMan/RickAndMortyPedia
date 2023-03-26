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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "rick-and-morty-season-6-episode-1.jpeg")!)
        title = category.title
        
        setUpPlaceholders()
        setUpFilters()
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
                break
            }
            if characterGenderTextField.text != "" &&
                characterGenderTextField.text != "female" &&
                characterGenderTextField.text != "male" &&
                characterGenderTextField.text != "genderless" &&
                characterGenderTextField.text != "unknown" {
                showAlert(withStatus: .wrongStatusInput)
                break
            }
            filterCharacters()
        case .locations:
            filterLocations()
        default:
            filterEpisodes()
        }
    }
    deinit {
        print("123321")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contentListVC = segue.destination as? ContentListViewController else { return }
        contentListVC.category = category
        contentListVC.url = url
        contentListVC.fetch(category)
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
            locationStackView.isHidden = true
            episodeStackView.isHidden = true
        case .locations:
            characterStackView.isHidden = true
            episodeStackView.isHidden = true
        default:
            characterStackView.isHidden = true
            locationStackView.isHidden = true
        }
    }
    
    func filter(by query: String, with textField: UITextField, url urlWithFilters: inout String, count filtersCount: inout Int) {
        if textField.text != "" {
            if filtersCount == 0 {
                urlWithFilters = "\(urlWithFilters)/?\(query)=\(textField.text ?? "")"
                filtersCount += 1
            } else {
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


