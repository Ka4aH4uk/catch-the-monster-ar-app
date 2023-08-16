//
//  CatchTheMonsterARApp.swift
//  CatchTheMonsterAR
//

import SwiftUI

@main
struct CatchTheMonsterARApp: App {
    @StateObject private var locationViewModel = LocationViewModel()
    @State private var isShowingSplash = true

    var body: some Scene {
        WindowGroup {
            if isShowingSplash {
                ScreenView()
                    .preferredColorScheme(.dark)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            isShowingSplash = false
                        }
                    }
            } else {
                ContentView()
                    .preferredColorScheme(.dark)
                    .environmentObject(locationViewModel)
            }
        }
    }
}
