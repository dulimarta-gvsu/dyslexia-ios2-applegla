//
//  ContentView.swift
//  dyslexia
//
//  ContentView.swift
//  dyslexia

import SwiftUI

struct WordView: View {
    init(viewModel: AppViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    @ObservedObject private var viewModel: AppViewModel

    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [
                    Color(
                        red: Double((0x4E342E >> 16) & 0xFF) / 255.0,
                        green: Double((0x4E342E >> 8) & 0xFF) / 255.0,
                        blue: Double(0x4E342E & 0xFF) / 255.0
                    ),

                    Color(
                        red: Double((0x6D4C41 >> 16) & 0xFF) / 255.0,
                        green: Double((0x6D4C41 >> 8) & 0xFF) / 255.0,
                        blue: Double(0x6D4C41 & 0xFF) / 255.0
                    ),

                    Color(
                        red: Double((0xA1887F >> 16) & 0xFF) / 255.0,
                        green: Double((0xA1887F >> 8) & 0xFF) / 255.0,
                        blue: Double(0xA1887F & 0xFF) / 255.0
                    )
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                
                HStack(spacing: 20) {
                    TopButton(label: "New Word") {
                        viewModel.selectNewWord()
                    }
                    TopButton(label: "Game History") {
                        // onGameHistory()
                    }
                    TopButton(label: "Settings") {
                        // onSettings()
                    }
                }
                .padding(.top, 20)

               
                Text("Moves: \(viewModel.rearrangeCount)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(
                        Color(
                            red: Double(0xFF) / 255.0,
                            green: Double(0xF3) / 255.0,
                            blue: Double(0xE0) / 255.0
                        )
                    )
                    .padding(.vertical, 20)

                
                ZStack(alignment: .bottom) {

                    
                    if viewModel.isComplete {
                        VStack(spacing: 12) {
                            Text("Congratulations!")
                                .font(.system(size: 50))
                                .foregroundColor(
                                    Color(
                                        red: Double(0xFF) / 255.0,
                                        green: Double(0xF3) / 255.0,
                                        blue: Double(0xE0) / 255.0
                                    )
                            )
                            
                            Text("You completed the puzzle in \(viewModel.elapsedTime, specifier: "%.0f") seconds and \(viewModel.rearrangeCount) moves")
                                .font(.system(size: 28))
                                .foregroundColor(
                                    Color(
                                        red: Double(0xFF) / 255.0,
                                        green: Double(0xF3) / 255.0,
                                        blue: Double(0xE0) / 255.0
                                    )
                                )
                                .multilineTextAlignment(.center)
                                .lineSpacing(8)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 200)
                    }

                    
                    let nonNilBinding = Binding<[Letter]>(
                        get: { viewModel.letters.compactMap { $0 } },
                        set: { viewModel.letters = $0.map { Optional($0) } }
                    )
                    LetterGroup(letters: nonNilBinding) { arr in
                        if let z = arr.prettyPrint() {
                            print("Rearrange \(z)")
                        }
                        viewModel.applyRearrangedLetters(arr)
                    }

                    
                    Text("Total Score: \(viewModel.totalScore)")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.bottom, 24)
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .offset(y: 100)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}


struct TopButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .foregroundColor(
                    Color(
                        red: Double(0xFF) / 255.0,
                        green: Double(0xF3) / 255.0,
                        blue: Double(0xE0) / 255.0
                    )
                )
        }
        .buttonStyle(.borderedProminent)
        .tint(.black)
    }
}


#Preview {
    WordView(viewModel: AppViewModel())
}
