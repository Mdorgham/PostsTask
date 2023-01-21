//
//  TabbarCV.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import SwiftUI

struct TabbarCV: View {
    var body: some View {
        TabView {
            PostsListCV()
                .tabItem {
                    Label("Home", systemImage: "list.dash")
                }
                
            FavListCV()
                .tabItem {
                    Label("Favourites", systemImage: "heart")
                }
                
        }
    }
}
