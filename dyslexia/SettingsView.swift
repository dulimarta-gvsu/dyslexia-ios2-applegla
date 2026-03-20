//
//  SettingsView.swift
//  dyslexia
//
//  Created by Lauren Applegate on 3/19/26.
//

//
//  GameSettingsView.swift
//  dyslexia

import SwiftUI

struct GameSettingsView: View {
    @ObservedObject var viewModel: AppViewModel

    var onWord: (Int, Int, Double, Double, Double) -> Void

    @State private var minLength: Double
    @State private var maxLength: Double
    @State private var red: Double = 255
    @State private var green: Double = 243
    @State private var blue: Double = 224

    init(viewModel: AppViewModel, onWord: @escaping (Int, Int, Double, Double, Double) -> Void) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.onWord = onWord
        self._minLength = State(initialValue: Double(viewModel.wordMin))
        self._maxLength = State(initialValue: Double(viewModel.wordMax))
    }

    let sliderColor = Color(
        red: Double((0x4E342E >> 16) & 0xFF) / 255.0,
        green: Double((0x4E342E >> 8) & 0xFF) / 255.0,
        blue: Double(0x4E342E & 0xFF) / 255.0
    )

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
                Text("Game Settings")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .font(.system(size: 35))
                    .padding(.vertical, 20)

                
                VStack(alignment: .center, spacing: 16) {

                    
                    Text("Word Length")
                        .font(.system(size: 20, weight: .bold))

                    
                    Text("Min: \(Int(minLength))")
                    Slider(value: $minLength, in: 5...10, step: 1)
                        .tint(sliderColor)
                        .onChange(of: minLength) { newVal in
                            if newVal > maxLength { maxLength = newVal }
                        }

                    
                    Text("Max: \(Int(maxLength))")
                    Slider(value: $maxLength, in: 5...10, step: 1)
                        .tint(sliderColor)
                        .onChange(of: maxLength) { newVal in
                            if newVal < minLength { minLength = newVal }
                        }

                    Divider()
                        .frame(width: 300, height: 2)
                        .background(Color(uiColor: .darkGray))

                    
                    Text("Letter Background Color")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 5)

                    Text("Red: \(Int(red))")
                    Slider(value: $red, in: 0...255, step: 1)
                        .tint(sliderColor)

                    Text("Green: \(Int(green))")
                    Slider(value: $green, in: 0...255, step: 1)
                        .tint(sliderColor)

                    Text("Blue: \(Int(blue))")
                    Slider(value: $blue, in: 0...255, step: 1)
                        .tint(sliderColor)

                  
                    Rectangle()
                        .fill(Color(red: red / 255, green: green / 255, blue: blue / 255))
                        .frame(width: 50, height: 50)
                }
                .frame(width: 310, height: 550)
                .padding(.horizontal, 24)
                .padding(.vertical, 30)
                .background(Color.white.opacity(0.45))
                .cornerRadius(8)

                
                Button {
                    viewModel.setWordLength(min: Int(minLength), max: Int(maxLength))
                    onWord(Int(minLength), Int(maxLength), red, green, blue)
                } label: {
                    Text("Main Screen")
                        .foregroundColor(.white)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                .padding(.top, 20)
            }
        }
    }
}

#Preview {
    GameSettingsView(viewModel: AppViewModel(), onWord: { _, _, _, _, _ in })
}
