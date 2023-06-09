//
//  ContentView.swift
//  TcaSwiftUI
//
//  Created by Takuya Ando on 2023/05/30.
//

import SwiftUI
import ComposableArchitecture

struct AppEnvironment {
    var gitHubApi = GithubApi.live
    var mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

// アプリの状態
struct AppState: Equatable {
    var users = [User]()
    var searchQuery: String = ""
}

// アクション
enum AppAction: Equatable {
    case searchQueryEditing(String)
    case response(Result<[User], ModelError>)
}

// アクションを受け取り、状態の更新を行うリダクション
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case let .searchQueryEditing(query):
        struct SearchUserId: Hashable {}
        
        return environment.gitHubApi
            .users(query)
            .receive(on: environment.mainQueue)
            .catchToEffect(AppAction.response)
            .cancellable(id: SearchUserId(),
                         cancelInFlight: true
            )
    case let .response(.success(users)):
        state.users = users
        return .none
    case let .response(.failure(error)):
        print(error)
        return .none
    }
}

// ビュー
struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    TextField(
                        "user name",
                        text: viewStore.binding(
                            get: \.searchQuery,
                            send: AppAction.searchQueryEditing
                        )
                    )
                    .onChange(of: viewStore.searchQuery) { _ in
                        viewStore.send(.searchQueryEditing(viewStore.searchQuery))
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.asciiCapable)
                    .padding()
                    Spacer()
                    List(viewStore.users) { user in
                        NavigationLink(destination: Text(":TODO")) {
                            UserRow(user: user)
                        }
                    }
                    .refreshable {
                        viewStore.send(.searchQueryEditing(viewStore.searchQuery))
                    }
                }
                .navigationTitle("GitHubユーザーをさがす")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(
            initialState: AppState(users: [User.mockUser], searchQuery: ""),
            reducer: appReducer,
            environment: AppEnvironment()
        ))
    }
}
