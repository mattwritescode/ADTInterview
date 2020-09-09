//
//  Repository.swift
//  RickAndMorty
//
//  Created by Matthew Tyler on 9/8/20.
//  Copyright © 2020 Matt Tyler. All rights reserved.
//

import Foundation

class Repository: ObservableObject {
    static var shared = Repository()
    
    @Published var currentEpisodes: [Episode] = []
    @Published var shouldShowAlert = false
    var hasShownAlert = false

    private let networkService = NetworkService()
    
    /// Initialized with value for first page, will update with new value after every successful network request
    private var nextPageURL: String? = "https://rickandmortyapi.com/api/episode?page=1"
    
    
    /// Triggers a GET request from server. If there is no value for nextPageURL, then we've already downloaded all the data currently available.
    func getNextPageOfEpisodes(){
        guard let nextPageURL = self.nextPageURL else {
            if (!hasShownAlert){
                shouldShowAlert = true
            }
            print("That's all the available episode data from Rick and Morty... maybe reopen this next season 😉 ")
            return
        }
        
        getEpisodes(nextPageURL: nextPageURL)
    }
    
    
    /// Downloads metadata for Rick and Morty episodes.
    /// - Parameter nextPageURL: url endpoint for GET request
    private func getEpisodes(nextPageURL: String){
        
        
        DispatchQueue.global(qos: .background).async{
            self.networkService.fetchEpisodes(nextPageURL: nextPageURL){ result in
                
                switch result {
                case .success(let apiResponse):
                    
                    guard let apiResponse = apiResponse,
                        let episodes = apiResponse.results,
                        let info = apiResponse.info
                        else {
                            print("Error: episodes in network response was nil." )
                            return
                    }
                    
                    // save nextPageURL from server
                    self.nextPageURL = info.next
 
                    // Prevent redundant episodes from being added to our currentEpisodes. This is being handled here in case of race conditions from hyperactive users.
                    guard (!Repository.shared.currentEpisodes.contains {$0.id  == episodes[0].id || $0.id == episodes[episodes.count-1].id} ) else{
                        print("error, redundant episodes downloaded")
                        return
                    }
                    
                    print("completed successful network request")
                    
                    DispatchQueue.main.async {
                        // Since the Repository is an ObservableObject and connected as an environment variable, the frontend will be notified of changes reactively.
                        Repository.shared.currentEpisodes.append(contentsOf: episodes)
                    }
                case .failure(let error):
                    print("FAILURE", error)
                }
            }
        }
    }
    
    func isEndOfList(episode : Episode) -> Bool{
        if Repository.shared.currentEpisodes.last?.id == episode.id {
            return true
        }
        return false
    }
}
