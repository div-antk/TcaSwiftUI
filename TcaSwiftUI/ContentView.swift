//
//  ContentView.swift
//  TcaSwiftUI
//
//  Created by Takuya Ando on 2023/05/30.
//

import SwiftUI
import ComposableArchitecture

// アプリの状態
struct AppState {
    var count: Int = 0
}

// アクション
enum AppAction {
    case increment
    case decrement
}

// アクションを受け取り、状態の更新を行うリダクション
let appReducer = Reducer<AppState, AppAction, Void> { state, action, _ in
    switch action {
    case .increment:
        state.count += 1
        return .none
        
    case .decrement:
        state.count -= 1
        return .none
    }
}

// ビュー
struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("Count: \(viewStore.count)")
                HStack {
                    Button(action: { viewStore.send(.decrement) }) {
                        Text("Decrement")
                    }
                    Button(action: { viewStore.send(.increment) }) {
                        Text("Increment")
                    }
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(
            initialState: AppState(),
            reducer: appReducer,
            environment: ()
        ))
    }
}
