//
//  TcaSwiftUIApp.swift
//  TcaSwiftUI
//
//  Created by Takuya Ando on 2023/05/30.
//

import SwiftUI
import ComposableArchitecture

@main
struct TcaSwiftUIApp: App {
    var body: some Scene {
        // ViewにStoreのインスタンスを渡す
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: AppState(),
                    reducer: appReducer.debug(),
                    environment: AppEnvironment()
                )
            )
        }
    }
}
