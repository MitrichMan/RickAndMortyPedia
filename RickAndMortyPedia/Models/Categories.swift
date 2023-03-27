//
//  Categories.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 23.03.2023.
//

import Foundation

struct Categories: Decodable {
    let characters: URL
    let locations: URL
    let episodes: URL
}

// MARK: - Characters
struct Characters: Decodable {
    let info: Info
    let results: [Character]
}

// MARK: - Locations
struct Locations: Decodable {
    let info: Info
    let results: [Location]
}

// MARK: - Episodes
struct Episodes: Decodable {
    let info: Info
    let results: [Episode]
}

// MARK: - Info
struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Character
struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterLocation
    let location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct Location: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [URL]
    let url: URL
    let created: String
}

// MARK: - Episode
struct Episode: Decodable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [URL]
    let url: URL
    let created: String
}

extension Episode {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case airDate = "air_date"
        case episode = "episode"
        case characters = "characters"
        case url = "url"
        case created = "created"
    }
}

// MARK: - CharacterLocation
struct CharacterLocation: Decodable {
    let name: String
    let url: String
}

// MARK: - CategoryNames
enum Category: CaseIterable {
    case characters
    case locations
    case episodes
    
    var title: String {
        switch self {
        case .characters:
            return "Персонажи"
        case .locations:
            return "Локации"
        case .episodes:
            return "Эпизоды"
        }
    }
}

