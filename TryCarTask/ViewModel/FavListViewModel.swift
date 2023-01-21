//
//  FavListViewModel.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import Foundation
import Combine
import UIKit
import CoreData

class FavListViewModel: ObservableObject {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
 
    @Published var favourites: [Post] = [Post]()
   
    func fetchFavourites(_ completion: @escaping ()->()) {
        
        if let cachedFavs = CachingServices.shared.getFavourites(){
            self.favourites = cachedFavs
            completion()
        }
    }
    
    func addPostToFav(postToAdd: Post,_ completion: @escaping ()->()) {
        CachingServices.shared.addPostToFav(post: postToAdd)
        if let cachedFavs = CachingServices.shared.getFavourites(){
            self.favourites = cachedFavs
            print(favourites)
            completion()
    }
    }
    
    func removePostFromFav(postId: Int,_ completion: @escaping ()->()) {
        CachingServices.shared.removePostFromFav(postId: Int16(postId))
        if let cachedFavs = CachingServices.shared.getFavourites(){
            self.favourites = cachedFavs
            print(favourites)
            completion()
    }
    }
    
   
    
}
