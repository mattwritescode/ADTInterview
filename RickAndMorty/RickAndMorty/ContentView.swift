//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Matthew Tyler on 9/8/20.
//  Copyright © 2020 Matt Tyler. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var repository: Repository
    
    var body: some View {
       
        VStack {
            Text("HWY HYW")
        
            
            ForEach( repository.currentEpisodes) { episode in
                Text(episode.name)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Repository.shared)
    }
}
