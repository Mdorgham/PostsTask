//
//  PostDetailsViewModel.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import Foundation
import Combine
import UIKit
import CoreData

class PostDetailsViewModel: ObservableObject {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    @Published var showAlert = false
    @Published var errorMsg = ""
    @Published var comments: [Comment] = [Comment]()
    private var commentsPublisher: AnyCancellable?
    
    private let networkService: NetworkServiceable
    
    init(networkService: NetworkServiceable) {
        
        self.networkService = networkService
    }
    
    func fetchComments(postId: Int,_ completion: @escaping ()->()) {
        if ConnectionManager.shared().isConnected{
            
            commentsPublisher = networkService.getPostComments(postId: postId).receive(on: DispatchQueue.main).sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert = true
                    
                }
            } receiveValue: { [weak self] comments in
                
                self?.comments = comments
                CachingServices.shared.saveComments(comments: comments)
                completion()
            }
        } else{
            if let cachedComments = CachingServices.shared.getComments(){
                self.comments = cachedComments.filter({$0.postId == postId})
                completion()
            }
        }
    }
    
}
