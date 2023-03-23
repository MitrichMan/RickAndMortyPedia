//
//  NetworkManager.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 23.03.2023.
//

import Foundation

enum Link {
    case base
//    case characters
//    case locations
//    case episodes
    
    var url: URL {
        switch self {
        case .base:
            return URL(string: "https://rickandmortyapi.com/api")!
//        case .characters:
//            return URL(string: "https://rickandmortyapi.com/api/character")!
//        case .locations:
//            return URL(string: "https://rickandmortyapi.com/api/location")!
//        case .episodes:
//            return URL(string: "https://rickandmortyapi.com/api/episode")!
        }
    }
}
