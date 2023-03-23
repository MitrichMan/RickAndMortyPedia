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

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: URL
    let prev: URL
}



struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: CharacterLocation
    let image: URL
    let episode: [URL]
    let url: URL
    let created: String
}

struct Origin: Decodable {
    let name: String
    let url: URL
}

struct CharacterLocation: Decodable {
    let name: String
    let url: URL
}

struct Location: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [URL]
    let url: URL
    let created: String
}

struct Episode: Decodable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [URL]
    let url: URL
    let created: String
}
