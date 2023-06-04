//
//  GitHubApi.swift
//  TcaSwiftUI
//
//  Created by Takuya Ando on 2023/06/04.
//

import Foundation
import ComposableArchitecture

struct GithubApi {
    var users: (String) -> Effect<[User], ModelError>
}

extension GithubApi {
    static let live = GithubApi(
        users: { query in
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.github.com"
            components.path = "/search/users"
            components.queryItems = [URLQueryItem(name: "q", value: query)]

            return URLSession.shared.dataTaskPublisher(for: components.url!)
                .map { data, _ in data }
                .decode(type: Users.self, decoder: JSONDecoder())
                .mapError { error in ModelError.jsonParseError(error.localizedDescription) }
                .map { return $0.items }
                .eraseToEffect()
        }
    )
}

// 非推奨のEffectの代わりにEffectTaskを使ったコード

//struct GitHubApi {
//    var users: (String) -> EffectTask<[User], ModelError>
//}
//
//extension GitHubApi {
//    static let live = GitHubApi(
//        users: { query in
//            var components = URLComponents()
//            components.scheme = "https"
//            components.host = "api.github.com"
//            components.path = "/search/users"
//            components.queryItems = [URLQueryItem(
//                name: "q",
//                value: query
//            )]
//
//            return EffectTask { callback in
//                URLSession.shared.dataTask(with: components.url!) { data, _, error in
//                    if let error = error {
//                        callback(.failure(.networkError(error.localizedDescription)))
//                        return
//                    }
//
//                    guard let data = data else {
//                        callback(.failure(.noData))
//                        return
//                    }
//
//                    do {
//                        let users = try JSONDecoder().decode(Users.self, from: data)
//                        callback(.success(users.items))
//                    } catch {
//                        callback(.failure(.jsonParseError(error.localizedDescription)))
//                    }
//                }.resume()
//            }
//        }
//    )
//}
