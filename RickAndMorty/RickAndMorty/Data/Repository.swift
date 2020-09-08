//
//  Repository.swift
//  RickAndMorty
//
//  Created by Matthew Tyler on 9/8/20.
//  Copyright © 2020 Matt Tyler. All rights reserved.
//

import Foundation

class Repository:ObservableObject {
    static var shared = Repository()
    
    @Published var currentEpisodes: [Episode] = []
    let networkService = NetworkService()
    var currentPage = 1
    func getNextPageOfEpisodes(){
        //TODO: make sure this isn't dedundant
        // check page number isn't already downloaded.
        
        
        DispatchQueue.global(qos: .background).async{
            Repository.shared.networkService.fetchEpisodes(page: self.currentPage){ result in
                
                switch result {
                case .success(let episodes):
                    let episodes = episodes ?? []
                    print("success")
                    DispatchQueue.main.async {
                        //TODO: make sure this isn't dedundant HERE TOO
//                       if (Repository.shared.currentEpisodes.contains(where: let x  x.id  == episodes[0].id} ){
//                            print("error, redundant episodes downloaded")
//                            return
//                            }

                        Repository.shared.currentEpisodes.append(contentsOf: episodes)
                        
                        //TODO: notify frontend of new data
                    }
                case .failure(let error):
                    print("FAILURE", error)
                }
                
            }
            
            
        }
    }
    
}
