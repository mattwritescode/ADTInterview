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
        NavigationView {
            List( repository.currentEpisodes) { episode in
                NavigationLink(destination: DetailView(episode: episode)){
                    ListRow(episode: episode)
                        .onAppear(perform: {
                            if self.repository.isEndOfList(episode: episode){
                                // Load Next Page
                                self.repository.getNextPageOfEpisodes()
                            }
                        })
                }
            }
            .navigationBarTitle("Rick and Morty!")
            .alert(isPresented: $repository.shouldShowAlert) {
                Alert(
                    title: Text("Oh No!"),
                    message: Text("That's all the available episode data from Rick and Morty... maybe reopen this next season 😉 "),
                    dismissButton: .default(Text("Ok I'll Wait")){
                        self.repository.hasShownAlert = true
                        self.repository.shouldShowAlert = false
                    } )
            }
        }
    }
}
struct DetailView: View {
    var episode: Episode
    
    var body: some View {
        VStack{
            Text(episode.name)
                .bold()
                .font(Font.largeTitle)
            Text("Created on: " + episode.created)
            Text("Aired on: " + episode.airDate)
        }
    }
}

struct ListRow: View {
    var episode: Episode
    
    var body: some View {
        Text(episode.name)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Repository.shared)
    }
}
