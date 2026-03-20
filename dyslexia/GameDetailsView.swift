//
//  GameDetailsView.swift
//  dyslexia
//
//  Created by Lauren Applegate on 3/19/26.
//


import SwiftUI

struct DetailsView: View {
    let word: String
    let points: Int
    let moves: Int
    let time: Int
    var onGameHistory: () -> Void

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

            VStack {
                Text("Word Details")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .font(.system(size: 35))
                    .padding(.vertical, 20)

                
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.45))
                        .frame(width: 350, height: 650)

                    VStack(alignment: .center, spacing: 0) {
                        Text("Word: \(word)")
                            .font(.system(size: 35, weight: .bold))
                            .padding(.top, 60)

                        Divider()
                            .frame(width: 300, height: 2)
                            .background(Color(uiColor: .darkGray))
                            .padding(.top, 30)

                        Text("Points: \(points)")
                            .font(.system(size: 30))
                            .padding(.top, 50)

                        Text("Moves: \(moves)")
                            .font(.system(size: 30))
                            .padding(.top, 100)

                        Text("Time: \(time) seconds")
                            .font(.system(size: 30))
                            .padding(.top, 100)
                    }
                }

                
                Button(action: onGameHistory) {
                    Text("Game History")
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
    DetailsView(word: "DRIPCOFFEE", points: 20, moves: 8, time: 30, onGameHistory: {})
}
