//
//  NetworkManager.swift
//  RickAndMortyPedia
//
//  Created by Dmitrii Melnikov on 23.03.2023.
//

import Foundation
import Alamofire

enum Link {
    case characters

    var url: URL {
        switch self {
        case .characters:
            return URL(string: "https://rickandmortyapi.com/api/character")!
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    func fetchCharacters(from link: URL, completion: @escaping(Result<Characters, AFError>) -> Void) {
        AF.request(link)
            .responseJSON { dataResponse in
                var fetchedCharacters: Characters!
                
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
                    fetchedCharacters = characters
                    }
                switch dataResponse.result {
                case .success(_):
                    completion(.success(fetchedCharacters))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchResidents(from links: [String], completion: @escaping(Result<[Character], AFError>) -> Void) {
        var residents: [Character] = []
        for link in links {
            AF.request(link)
                .responseJSON { dataResponse in
                    guard let statusCode = dataResponse.response?.statusCode else { return }
                    if (200..<300).contains(statusCode) {
                        guard let characterData = dataResponse.value as? [String: Any] else { return }
                        guard let characterOrigin = characterData["origin"] as? [String: Any] else { return }
                        guard let characterLocation = characterData["location"] as? [String: Any] else { return }
                        
                        
                        let origin = CharacterLocation(
                            name: characterOrigin["name"] as? String ?? "",
                            url: characterOrigin["url"] as? String ?? ""
                        )
                        
                        let location = CharacterLocation(
                            name: characterLocation["name"] as? String ?? "",
                            url: characterLocation["url"] as? String ?? ""
                        )
                        
                        let character = Character(
                            name: characterData["name"] as? String ?? "",
                            status: characterData["status"] as? String ?? "",
                            species: characterData["species"] as? String ?? "",
                            type: characterData["type"] as? String ?? "",
                            gender: characterData["gender"] as? String ?? "",
                            origin: origin,
                            location: location,
                            image: characterData["image"] as? String ?? "",
                            episode: characterData["episode"] as? [String] ?? [],
                            url: characterData["url"] as? String ?? "",
                            created: characterData["created"] as? String ?? ""
                        )
                        residents.append(character)
                    }
                    switch dataResponse.result {
                    case .success(_):
                        completion(.success(residents))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    }
    
    func fetchEpisodes(from link: String, completion: @escaping(Result<Episode, AFError>) -> Void) {
        AF.request(link)
            .responseJSON { dataResponse in
                var fetchedEpisode: Episode!
                
                guard let statusCode = dataResponse.response?.statusCode else { return }
                if (200..<300).contains(statusCode) {
                    guard let episodeData = dataResponse.value as? [String: Any] else { return }
                    let episode = Episode(
                        name: episodeData["name"] as? String ?? "",
                        airDate: episodeData["air_date"] as? String ?? "",
                        episode: episodeData["episode"] as? String ?? "",
                        characters: episodeData["characters"] as? [String] ?? [],
                        url: episodeData["url"] as? String ?? "",
                        created: episodeData["created"] as? String ?? ""
                    )
                    fetchedEpisode = episode
                }
                switch dataResponse.result {
                case .success(_):
                    completion(.success(fetchedEpisode))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchImage(from link: String, completion: @escaping(Result<Data, AFError>) -> Void) {
        AF.request(link)
            .validate()
            .responseData { dataResponse in
                switch dataResponse.result {
                case .success(let imageData):
                    completion(.success(imageData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

extension NetworkManager {
    enum NetworkError: Error {
        case noData
        case decodingError
    }
}
