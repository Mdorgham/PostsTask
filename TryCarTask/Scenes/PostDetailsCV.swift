//
//  PostDetailsCV.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import SwiftUI

struct PostDetailsCV: View {
    @State var post: Post
    @State var isFavourite: Bool
    @State var comments: [Comment] = [Comment]()
    @State var viewModel: PostDetailsViewModel = PostDetailsViewModel(networkService: NetworkService())
    @State var favViewModel: FavListViewModel = FavListViewModel()
    @State var completion: () -> Void
    @State var favPosts: [Post] = [Post]()
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 16){
            VStack (alignment: .leading, spacing: 16) {
                Text(post.title)
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundColor(.indigo)
                
                ZStack (alignment: .trailingLastTextBaseline) {
                    Text(post.body)
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundColor(.gray)
                    Spacer()
                    Button {
                        completion()
                        favViewModel.fetchFavourites {
                            favPosts = favViewModel.favourites
                            if favPosts.contains(where: {$0.id == post.id}) {
                                isFavourite = true
                            }
                        }
                    } label: {
                        if isFavourite {
                            Image(systemName: "heart.fill")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.red)
                        }else {
                            Image(systemName: "heart")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            Divider()
            Text("Comments")
                .font(.system(size: 17, weight: .bold, design: .default))
                .foregroundColor(.black)
            
            List {
                ForEach(comments , id: \.self) { comment in
                    VStack (alignment: .leading,spacing: 8){
                        HStack {
                            Text(comment.name)
                                .font(.system(size: 15, weight: .semibold, design: .default))
                                .foregroundColor(.red)
                            Spacer()
                            Text(comment.email)
                                .font(.system(size: 13, weight: .light, design: .default))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                        }
                        Text(comment.body)
                            .font(.system(size: 11, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                    }
                    
                    
                }
            }.listStyle(.plain)
        }
        .padding()
        .onAppear(perform: {
            viewModel.fetchComments(postId: post.id) {
                comments = viewModel.comments
            }
    
        })
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

