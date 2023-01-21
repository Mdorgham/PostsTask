//
//  Comment.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import Foundation

struct Comment: Decodable, Hashable {
    let postId: Int
    let id: Int
    let email: String
    let name: String
    let body: String
}

