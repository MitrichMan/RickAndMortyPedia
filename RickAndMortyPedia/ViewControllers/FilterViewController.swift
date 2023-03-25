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
        guard let url else { return }
        var urlWithFilters = String(describing: url)
        if characterNameTextField.text != "" {
            let url = urlWithFilters
            urlWithFilters = "\(url)/?name=\(characterNameTextField.text ?? "")"
            print(urlWithFilters)
        }
//        You can also include filters in the URL by including additional query parameters.
//        To start filtering add a ? followed by the query <query>=<value>. If you want to chain
//        several queries in the same call, use & followed by the query.
        
        //name: filter by the given name.
        //status: filter by the given status (alive, dead or unknown).
        //species: filter by the given species.
        //type: filter by the given type.
        //gender: filter by the given gender (female, male, genderless or unknown).
        //GET https://rickandmortyapi.com/api/character/?name=rick&status=alive
    }
    
    // MARK: - PrivateMethods
    private func setUpFilters() {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




//Locations
//name: filter by the given name.
//type: filter by the given type.
//dimension: filter by the given dimension.
//If you want to know how to use queries, check here

//Filter episodes
//
//Available parameters:
//
//name: filter by the given name.
//episode: filter by the given episode code.
//If you want to know how to use queries, check here.
//



