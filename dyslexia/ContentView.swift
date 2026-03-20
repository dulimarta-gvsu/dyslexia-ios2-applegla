//
//  Untitled.swift
//  dyslexia
//
//  Created by Lauren Applegate on 3/19/26.
//

//  dyslexia

import SwiftUI


enum AppRoute: Hashable {
    
    case gameHistory
    case gameSettings
    case details(word: String, points: Int, moves: Int, time: Int)
}


struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    @State private var navigationPath = NavigationPath()

   
    @State private var red: Double = 255
    @State private var green: Double = 243
    @State private var blue: Double = 224

    var body: some View {
        NavigationStack(path: $navigationPath) {
            WordView(
                viewModel: viewModel,
                red: red, green: green, blue: blue,
                onGameHistory: {
                    navigationPath.append(AppRoute.gameHistory)
                },
                onSettings: {
                    navigationPath.append(AppRoute.gameSettings)
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                

                case .gameHistory:
                    GameHistoryView(
                        viewModel: viewModel,
                        onDetails: { word, points, moves, time in
                            navigationPath.append(AppRoute.details(
                                word: word, points: points, moves: moves, time: time
                            ))
                        },
                        onWord: {
                            navigationPath.removeLast()
                        }
                    )

                case .gameSettings:
                    GameSettingsView(
                        viewModel: viewModel,
                        onWord: { wordMin, wordMax, r, g, b in
                           
                            viewModel.setWordLength(min: wordMin, max: wordMax)
                            red = r
                            green = g
                            blue = b
                            navigationPath.removeLast()
                        }
                    )

                case .details(let word, let points, let moves, let time):
                    DetailsView(
                        word: word, points: points, moves: moves, time: time,
                        onGameHistory: {
                            navigationPath.removeLast()
                        }
                    )
                }
            }
        }
    }
}


