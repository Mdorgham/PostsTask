//
//  CachingServices.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import Foundation
import Combine
import UIKit
import CoreData


class CachingServices {
    
    static let shared = CachingServices()
    static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save<T: Encodable>(to path: String,
                            _ object: T,
                            folder: String? = nil,
                            _ encoder: JSONEncoder = JSONEncoder.init(),
                            ext: String = "json"){
        if let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            var fileURL: URL!
            if let folder = folder{
                let nestedFolderURL = cacheURL.appendingPathComponent(folder)
                if  !FileManager.default.fileExists(atPath: nestedFolderURL.path){
                    do {
                        try FileManager.default.createDirectory(at: nestedFolderURL, withIntermediateDirectories: false, attributes: nil)
                        fileURL = nestedFolderURL.appendingPathComponent("\(path).json")
                    } catch let error {
                        print(error.localizedDescription)
                        return
                    }
                }else{
                    fileURL = cacheURL.appendingPathComponent(folder + "\(path).json")
                }
            }else{
                fileURL = cacheURL.appendingPathComponent("\(path).\(ext)")
            }
            
            print("fileUrl", fileURL.absoluteString)
            
            let jsonData = try! encoder.encode(object)
            guard let text = String(data: jsonData, encoding: .utf8) else{ return }
            
            do {
                try text.write(to: fileURL, atomically: true, encoding: .utf8)
            }
            catch {}
        }
    }
    
    func read<T: Decodable>(from path: String,
                            _ object: T.Type,
                            _ decoder: JSONDecoder = JSONDecoder(),
                            ext: String = "json") -> T?{
        let file = "\(path).\(ext)"
        if let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                print("here cached data",text)
                return try decoder.decode(T.self, from: text.data(using: .utf8)!)
            }
            catch let error{
                print(error)
                return nil
            }
        }
        return nil
    }
    
    func remove(from path: String,
                ext: String = "json"){
        let file = "\(path).\(ext)"
        if let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                try FileManager.default.removeItem(at: fileURL)
            }
            catch let error{
                print(error)
            }
        }
    }
    
    @discardableResult func clearAll() -> AnyPublisher<(),Error>{
        Future{ promise in
            do {
                UserDefaults.standard.removeObject(forKey: "recent_queries")
                UserDefaults.standard.removeObject(forKey: "additional_info_skipped")
                let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let cachesUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                let documentUrls = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                               includingPropertiesForKeys: nil,
                                                                               options: .skipsHiddenFiles)
                for documentUrl in documentUrls{
                    try FileManager.default.removeItem(at: documentUrl)
                }
                let cachesUrls = try FileManager.default.contentsOfDirectory(at: cachesUrl,
                                                                             includingPropertiesForKeys: nil,
                                                                             options: .skipsHiddenFiles)
                for cachesUrl in cachesUrls{
                    try FileManager.default.removeItem(at: cachesUrl)
                }
                promise(.success(()))
            } catch  {
                print(error)
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    func getPosts() -> [Post]?{
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        do{
            let localPosts = try CachingServices.managedObjectContext.fetch(fetchRequest)
            var posts: [Post] = []
            localPosts.forEach { post in
                posts.append(Post(userId: Int(post.userId), id: Int(post.id), title: post.title ?? "", body: post.body ?? "", isFavourite: post.isFavourite))
            }
            return posts
        }catch{
            print(error)
            return nil
        }
    }
    
    func savePosts(posts: [Post]){
        deletePosts()
        posts.forEach { post in
            let postEntity = PostEntity(context: CachingServices.managedObjectContext)
            postEntity.id = Int16(post.id)
            postEntity.body = post.body
            postEntity.title = post.title
            postEntity.userId = Int16(post.userId)
            postEntity.isFavourite = post.isFavourite ?? false
        }
        do{
            try CachingServices.managedObjectContext.save()
        }catch{
            print(error)
            
        }
    }
    func deletePosts(){
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        do{
            let posts = try CachingServices.managedObjectContext.fetch(fetchRequest)
            posts.forEach { post in
                CachingServices.managedObjectContext.delete(post)
            }
            try CachingServices.managedObjectContext.save()
            print("posts deleted")
        }catch{
            print("posts deletetion failed", error)
            
        }
    }
    func saveComments(comments: [Comment]){
        deleteComments()
        comments.forEach { comment in
            let commentEntity = CommentEntity(context: CachingServices.managedObjectContext)
            commentEntity.id = Int16(comment.id)
            commentEntity.body = comment.body
            commentEntity.email = comment.email
            commentEntity.postId = Int16(comment.postId)
            commentEntity.name = comment.name
        }
        do{
            try CachingServices.managedObjectContext.save()
        }catch{
            print(error)
            
        }
    }
    
    func getComments() -> [Comment]?{
        let fetchRequest: NSFetchRequest<CommentEntity> = CommentEntity.fetchRequest()
        do{
            let localComments = try CachingServices.managedObjectContext.fetch(fetchRequest)
            var comments: [Comment] = []
            localComments.forEach { comment in
                comments.append(Comment(postId: Int(comment.postId), id: Int(comment.id), email: comment.email ?? "", name: comment.name ?? "", body: comment.body ?? ""))
            }
            return comments
        }catch{
            print(error)
            return nil
        }
    }
    
    func deleteComments(){
        let fetchRequest: NSFetchRequest<CommentEntity> = CommentEntity.fetchRequest()
        do{
            let comments = try CachingServices.managedObjectContext.fetch(fetchRequest)
            comments.forEach { comment in
                CachingServices.managedObjectContext.delete(comment)
            }
            try CachingServices.managedObjectContext.save()
            print("comments deleted")
        }catch{
            print("comments deletetion failed", error)
            
        }
    }
    
    func getFavourites() -> [Post]?{
        let fetchRequest: NSFetchRequest<FavEntity> = FavEntity.fetchRequest()
        do{
            let localFavs = try CachingServices.managedObjectContext.fetch(fetchRequest)
            var favs: [Post] = []
            localFavs.forEach { post in
                favs.append(Post(userId: Int(post.userId), id: Int(post.id), title: post.title ?? "", body: post.body ?? "", isFavourite: post.isFavourite))
            }
            return favs
        }catch{
            print(error)
            return nil
        }
    }
    
    func addPostToFav(post: Post){
        let FavEntity = FavEntity(context: CachingServices.managedObjectContext)
        FavEntity.id = Int16(post.id)
        FavEntity.body = post.body
        FavEntity.title = post.title
        FavEntity.userId = Int16(post.userId)
        FavEntity.isFavourite = true
        do{
            try CachingServices.managedObjectContext.save()
        }catch{
            print(error)
            
        }
    }
    
    func removePostFromFav(postId: Int16) {
        let fetchRequest: NSFetchRequest<FavEntity> = FavEntity.fetchRequest()
        do{
            let favs = try CachingServices.managedObjectContext.fetch(fetchRequest)
            if let postToDelete = favs.first(where: {$0.id == postId}) {
                CachingServices.managedObjectContext.delete(postToDelete)
            }
            try CachingServices.managedObjectContext.save()
            print("post removed")
        }catch{
            print("post removal failed", error)
            
        }
    }
    
   
}
