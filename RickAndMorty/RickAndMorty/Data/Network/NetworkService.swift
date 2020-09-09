//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Matthew Tyler on 9/8/20.
//  Copyright © 2020 Matt Tyler. All rights reserved.
//

import Foundation

struct NetworkService {
    
    func fetchEpisodes(nextPageURL: String,  onComplete: @escaping (Result<ApiResponse?, NetworkError>) -> Void){
        
        guard let url = URL(string: nextPageURL) else {
            onComplete(.failure(.URL))
            return
        }

        URLSession.shared.dataTask(with: url){ data, response, error  in
            guard let data = data, error == nil else{
                print("Error in network call",error ?? "")
                onComplete(.failure(.server))
                return
            }
            
            guard let apiResponse = self.decodeJson(data: data) else{
                onComplete(.failure(.jsonDecoding ))
                return
            }
            
            guard apiResponse.error == nil else{
                print("Error from server",apiResponse.error ?? "")
                onComplete(.failure(.server ))
                return
                
            }
            onComplete(.success(apiResponse))
            return
            
        }.resume()
    }
    
    func decodeJson(data: Data) -> ApiResponse? {
        do {
            
            let jsonDecoder = JSONDecoder()
            let apiResponse = try jsonDecoder.decode(ApiResponse.self, from: data)
            return apiResponse
            
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
