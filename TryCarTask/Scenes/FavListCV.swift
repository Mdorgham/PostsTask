//
//  FavListCV.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import SwiftUI
import UIKit
import CoreData
import Combine


struct FavListCV: View {
    
    @State var postsViewModel: PostsListViewModel = PostsListViewModel(networkService: NetworkService())
    @State var favViewModel: FavListViewModel = FavListViewModel()
    @State var posts: [Post]?
    @State var favPosts: [Post] = [Post]()
    @State var connection = ConnectionManager.shared().$isConnected
    @State var showAlert = true
    var bag: Set<AnyCancellable> = []
    
    var body: some View {
        NavigationView {
            VStack {
                if let posts = favPosts, (posts.count ?? 0) > 0{
                    ScrollView {
                        ForEach(posts , id: \.self) { post in
                            NavigationLink {
                                
                                PostDetailsCV(post: post,isFavourite: post.isFavourite ?? false) {
                                    if (post.isFavourite ?? false) {
                                        favViewModel.removePostFromFav(postId: post.id, {
                                            self.favPosts = favViewModel.favourites
                                        })
                                    }else {
                                        favViewModel.addPostToFav(postToAdd: post, {
                                            self.favPosts = favViewModel.favourites
                                            
                                        })
                                    }
                                }
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    PostCardView(title: post.title, type: post.body, isFavourite: true) {
                                        favViewModel.removePostFromFav(postId: post.id, {
                                            self.favPosts = favViewModel.favourites
                                        })
                                    }
                                }
                            }
                        }
                        
                    }
                }else {
                    Text("No Favourites !")
                        .font(.title2)
                }
            }
            
            .onAppear(perform: {
                favViewModel.fetchFavourites {
                    favPosts = favViewModel.favourites
                }
                postsViewModel.fetchPosts {
                    posts = postsViewModel.posts
                }
            })
            
            .onReceive(connection) { connected in
                if connected && showAlert {
                   
                    showAlert = false
                
                }else if connected && showAlert == false {
                    // online
                   showAlert = true
                    syncFavourites()
                    
                }else {
                    
                    showAlert = false
                }
            }
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Connection"),message: Text("Connection back Online !"),dismissButton: .default(Text("Ok")))
            }
            
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
  
    func syncFavourites() {
        
        for favPost in favPosts {
            
            if !(favPost.isSynced ?? false) {
                
                // add post to favourite remote here
               var post = posts?.first(where: {$0.id == favPost.id})
               post?.isSynced = true
                
            }
        }
    }
  
  
}

