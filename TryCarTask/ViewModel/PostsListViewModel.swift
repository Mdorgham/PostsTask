//
//  PostsListViewModel.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 21/01/2023.
//

import Foundation
import CoreData
import UIKit
import Combine

class PostsListViewModel: ObservableObject {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    @Published var showAlert = false
    @Published var errorMsg = ""
    @Published var posts: [Post] = [Post]()
    private var postsPublisher: AnyCancellable?
    
    private let networkService: NetworkServiceable
    
    init(networkService: NetworkServiceable) {
        
        self.networkService = networkService
    }
    
    func fetchPosts(_ completion: @escaping ()->()) {
        if ConnectionManager.shared().isConnected{
            
            postsPublisher = networkService.getPosts().receive(on: DispatchQueue.main).sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert = true
                    
                }
            } receiveValue: { [weak self] posts in
                
                self?.posts = posts
                CachingServices.shared.savePosts(posts: posts)
                completion()
            }
        } else{
            if let cachedPosts = CachingServices.shared.getPosts(){
                self.posts = cachedPosts
                completion()
            }
        }
    }
    
}

