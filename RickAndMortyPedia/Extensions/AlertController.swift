//
//  AlertController.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 25.03.2023.
//

import UIKit

extension UIViewController {
    enum Alert {
        case failed
        case wrongStatusInput
        case wrongGenderInput
        case noContent
        
        var title: String {
            switch self {
            case .failed:
                return "Failed"
            case .wrongStatusInput:
                return  "Wrong status"
            case .wrongGenderInput:
                return "Wrong gender"
            case .noContent:
                return "No results"
            }
        }
        
        var message: String {
            switch self {
            case .failed:
                return "You can see error in the Debug area"
            case .wrongStatusInput:
                return "Enter alive, dead or unknown"
            case .wrongGenderInput:
                return "Enter female, male, genderless or unknown"
            case .noContent:
                return "Try another to enter another data"
            }
        }
    }
    
    func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(
            title: status.title,
            message: status.message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}
