//
//  dyslexiaApp.swift
//  dyslexia

import SwiftUI

@main
struct dyslexiaApp: App {
    @StateObject private var viewModel = AppViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
