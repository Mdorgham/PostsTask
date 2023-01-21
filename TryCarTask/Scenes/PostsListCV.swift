//
//  PostsListCV.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 21/01/2023.
//

import SwiftUI

struct PostsListCV: View {
    
    @State var viewModel: PostsListViewModel = PostsListViewModel(networkService: NetworkService())
    @State var favViewModel: FavListViewModel = FavListViewModel()
    @State var posts: [Post] = [Post]()
    @State var favPosts: [Post] = [Post]()
    
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(posts , id: \.self) { post in
                        let favourite = favPosts.contains(where: {$0.id == post.id })
                        NavigationLink {
                            
                            PostDetailsCV(post: post,isFavourite: favourite) {
                                if favourite {
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
                                
                                PostCardView(title: post.title, type: post.body, isFavourite: favourite) {
                                    if favourite {
                                        favViewModel.removePostFromFav(postId: post.id, {
                                            self.favPosts = favViewModel.favourites
                                        })
                                        
                                    }else {
                                        favViewModel.addPostToFav(postToAdd: post, {
                                            self.favPosts = favViewModel.favourites
                                            
                                        })
                                    }
                                }
                            }
                        }
                        
                        
                    }
                }
            }
            
            .onAppear(perform: {
                viewModel.fetchPosts {
                    posts = viewModel.posts
                }
                favViewModel.fetchFavourites {
                    favPosts = favViewModel.favourites
                }
            })
            
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

