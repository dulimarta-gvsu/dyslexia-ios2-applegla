//
//  GameHistoryView.swift
//  dyslexia
//
//  Created by Lauren Applegate on 3/19/26.
//

//
//  GameHistoryView.swift
//  dyslexia

import SwiftUI

struct GameHistoryView: View {
    @ObservedObject var viewModel: AppViewModel
    var onDetails: (String, Int, Int, Int) -> Void
    var onWord: () -> Void

    @State private var sortedHistory: [WordRecord] = []

    init(viewModel: AppViewModel, onDetails: @escaping (String, Int, Int, Int) -> Void, onWord: @escaping () -> Void) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.onDetails = onDetails
        self.onWord = onWord
        self._sortedHistory = State(initialValue: viewModel.gameHistory.sorted { $0.secretWord < $1.secretWord })
    }

    let buttonColor = Color(
        red: Double((0x2A1B17 >> 16) & 0xFF) / 255.0,
        green: Double((0x2A1B17 >> 8) & 0xFF) / 255.0,
        blue: Double(0x2A1B17 & 0xFF) / 255.0
    )
    
    let coffeeDark = Color(
        red: Double((0x4E342E >> 16) & 0xFF) / 255.0,
        green: Double((0x4E342E >> 8) & 0xFF) / 255.0,
        blue: Double(0x4E342E & 0xFF) / 255.0
    )
    let coffeeMid = Color(
        red: Double((0x6D4C41 >> 16) & 0xFF) / 255.0,
        green: Double((0x6D4C41 >> 8) & 0xFF) / 255.0,
        blue: Double(0x6D4C41 & 0xFF) / 255.0
    )
    let coffeeLight = Color(
        red: Double((0xA1887F >> 16) & 0xFF) / 255.0,
        green: Double((0xA1887F >> 8) & 0xFF) / 255.0,
        blue: Double(0xA1887F & 0xFF) / 255.0
    )
    
    let sortByWord: ([WordRecord]) -> [WordRecord] = { list in
        list.sorted { $0.secretWord < $1.secretWord }
    }

    let sortByPoints: ([WordRecord]) -> [WordRecord] = { list in
        list.sorted { $0.wordPoints < $1.wordPoints }
    }
    
    let sortByMoves:([WordRecord]) -> [WordRecord] = { list in
        list.sorted { $0.moves < $1.moves }
    }
    
    let sortByTime:([WordRecord]) -> [WordRecord] = { list in
        list.sorted { $0.time > $1.time }
    }
    
    let accentColor = Color(
        red: Double((0x4E342E >> 16) & 0xFF) / 255.0,
        green: Double((0x4E342E >> 8) & 0xFF) / 255.0,
        blue: Double(0x4E342E & 0xFF) / 255.0
    )

    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [coffeeDark, coffeeMid, coffeeLight],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Game History")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .font(.system(size: 35))
                    .padding(.vertical, 20)
                
                
                VStack(spacing: 4) {
                    HStack(spacing: 0) {
                        Spacer()
                        SortButton(label: "Sort by Word", color: buttonColor) {
                            sortedHistory = sortByWord(viewModel.gameHistory)
                        }
                        Spacer()
                        SortButton(label: "Sort by Points", color: buttonColor) {
                            sortedHistory = sortByPoints(viewModel.gameHistory)
                        }
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        Spacer()
                        SortButton(label: "Sort by Moves", color: buttonColor) {
                            sortedHistory = sortByMoves(viewModel.gameHistory)
                        }
                        Spacer()
                        SortButton(label: "Sort by Time", color: buttonColor) {
                            sortedHistory = sortByTime(viewModel.gameHistory)
                        }
                        Spacer()
                    }
                }
                .padding(.vertical, 5)
                .padding(.bottom, 18)
                
                
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(sortedHistory) { record in
                            let rowTint = (record.wordPoints == 0) ? Color(uiColor: .lightGray) : accentColor
                            
                            Button {
                                onDetails(record.secretWord, record.wordPoints, record.moves, record.time)
                            } label: {
                                Text("\(record.secretWord): \(record.wordPoints) points - \(record.moves) moves - \(record.time) seconds")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(rowTint)
                            .cornerRadius(8)
                        }
                        
                    }
                    .padding(16)
                }
                .frame(width: 350, height: 550)
                .background(Color.white.opacity(0.45))
                .cornerRadius(8)
                
                
                Button {
                    onWord()
                } label: {
                    Text("Main Screen")
                        .foregroundColor(.white)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                .padding(.top, 20)
            }
        }
        .onReceive(viewModel.$gameHistory) { newHistory in
            sortedHistory = newHistory.sorted { $0.secretWord < $1.secretWord }
        }
    }
}


struct SortButton: View {
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .foregroundColor(.white)
        }
        .buttonStyle(.borderedProminent)
        .tint(color)
    }
}

#Preview {
    GameHistoryView(viewModel: AppViewModel(), onDetails: { _, _, _, _ in }, onWord: {})
}
