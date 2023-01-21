//
//  Post.swift
//  TryCarTask
//
//  Created by mohamed dorgham on 20/01/2023.
//

import Foundation

struct Post: Codable,Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    let isFavourite: Bool?
    var isSynced: Bool?
}

