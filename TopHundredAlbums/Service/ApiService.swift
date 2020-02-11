//
//  ApiService.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/8/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

enum ApiServiceError: String, Error {
    case dataFetchError = "data fetch error"
}

protocol ApiServiceProtocol {
    func fetchTopHundredAlbums(_ completion: @escaping (_ fetchSuccess: Bool, _ albums: [Album], _ error: ApiServiceError?)->())
}

class ApiService: ApiServiceProtocol {
    func fetchTopHundredAlbums(_ completion: @escaping (_ fetchSuccess: Bool, _ albums: [Album], _ error: ApiServiceError?) -> ()) {
        guard let url = URL(string: Constants.RSSURL) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data else {return}
            
            if error != nil{
                completion(false, [Album](), ApiServiceError.dataFetchError)
            }
            
            do {
                let obj = try JSONDecoder().decode(TopHundredAlbums.self, from: dataResponse)
                let albums = obj.feed.albums
                completion(true, albums, nil)
            }catch let error {
                print(error.localizedDescription)
                completion(true, [Album](), ApiServiceError.dataFetchError)
            }
            
        }
        task.resume()
    }
}

struct TopHundredAlbums: Codable {
    let feed: Feed
}

struct Feed: Codable {
    let albums: [Album]
    
    enum CodingKeys: String, CodingKey {
        case albums = "results"
    }
}

struct Album: Codable {
    let albumName: String
    let artistName: String
    let albumArt: String
    let genres: [Genre]
    let releaseDate: String
    let copyright: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case albumName = "name"
        case artistName
        case albumArt = "artworkUrl100"
        case genres
        case releaseDate
        case copyright
        case url
    }
}

struct Genre: Codable {
    let name: String
}
