//
//  Users.swift
//  TcaSwiftUI
//
//  Created by Takuya Ando on 2023/06/04.
//

import Foundation

struct Users: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [User]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct User: Codable, Identifiable, Equatable {
    let id = UUID()
    let login: String
    let avatarUrl: String
    let reposUrl: String
    static let mockUser = User(
        login: "div-antk",
        avatarUrl: "https://avatars.githubusercontent.com/u/51283468?v=4",
        reposUrl: "https://api.github.com/users/div-antk/repos"
    )
    private enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
    }
}
