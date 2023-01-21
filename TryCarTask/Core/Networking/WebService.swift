//
//  Networking.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import Foundation
import Combine

protocol NetworkServiceable {
    func getPosts() -> AnyPublisher<[Post], Never>
    func getPostComments(postId: Int) -> AnyPublisher<[Comment], Never>
}

class NetworkService: NetworkServiceable {

    let urlSession: URLSession
    let baseURLString: String = "https://jsonplaceholder.typicode.com/"

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func getPosts() -> AnyPublisher<[Post], Never> {

        let urlString = baseURLString + "posts"

        guard let url = URL(string: urlString) else {
            return Just<[Post]>([]).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func getPostComments(postId: Int) -> AnyPublisher<[Comment], Never> {

        let urlString = baseURLString + "posts/\(postId)/comments"

        guard let url = URL(string: urlString) else {
            return Just<[Comment]>([]).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
