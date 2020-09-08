//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Matthew Tyler on 9/8/20.
//  Copyright © 2020 Matt Tyler. All rights reserved.
//

import Foundation

struct NetworkService {
    let baseUrl = "https://rickandmortyapi.com/api/episode?page=" //page=
    
    func fetchEpisodes(page: Int,  onComplete: @escaping (Result<[Episode]?, NetworkError>) -> Void){
        let pageStr = String(page)
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else { // baseUrl + pageStr) else {
            onComplete(.failure(.URL))
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, response, error  in
            print(data,response,error)
            guard let response = response, let data = data else{
                print("Error in network call",error ?? "")
                onComplete(.failure(.server))
                return
            }
            print("response",response)
            
            let episodes = self.decodeJson(data: data)
            onComplete(.success(episodes))
        }.resume()
    }
    
    func decodeJson(data: Data) -> [Episode]? {
        do {
            let jsonDecoder = JSONDecoder()
            let apiResponse = try jsonDecoder.decode(ApiResponse.self, from: data)
            let episodes = apiResponse.results
            print(episodes)
            
            return episodes
        } catch let error {
            print ("Error decoding json", error)
            return nil
        }
    }
    
}

enum NetworkError: Error{
    case URL
    case server
    case jsonDecoding
}
