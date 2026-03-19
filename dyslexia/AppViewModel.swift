//
//  AppViewModel.swift
//  dyslexia


import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {

    let wordStock = [
        "LATTE", "MOCHA", "ESPRESSO", "CAPPUCCINO", "AMERICANO",
        "MACCHIATO", "COLDBREW", "FRAPPE", "AFFOGATO", "ARABICA",
        "ROBUSTA", "VANILLA", "CARAMEL", "HAZELNUT", "COCOA",
        "BEANS", "CREAM", "SUGAR", "GRINDER", "FILTER",
        "BARISTA", "ROAST", "STEAM", "FROTH", "CINNAMON",
        "DECAF", "BREWER", "DRIPCOFFEE", "ROASTERY", "POUROVER"
    ]

    let letterScore: [Character: Int] = [
        "A":1,"B":3,"C":3,"D":2,"E":1,"F":4,"G":2,"H":4,
        "I":1,"J":8,"K":5,"L":2,"M":3,"N":2,"O":1,"P":3,
        "Q":10,"R":1,"S":1,"T":1,"U":1,"V":4,"W":4,"X":8,
        "Y":4,"Z":10
    ]

    @Published var selectedWord: String = ""
    @Published var letters: [Letter?] = []
    @Published var removedLetter: Letter? = nil
    @Published var rearrangeCount: Int = 0
    private var previousState: [Letter?] = []

    private var startTimer: Double = 0

    @Published var elapsedTime: Double = 0
    @Published var isComplete: Bool = false
    @Published var totalScore: Int = 0
    @Published var gameHistory: [WordRecord] = []

    @Published var wordMin: Int = 5
    @Published var wordMax: Int = 10

    init() {
        selectNewWord()
    }
    

    func selectNewWord() {

        if !selectedWord.isEmpty && !isComplete {
            gameHistory.append(
                WordRecord(
                    secretWord: selectedWord,
                    wordPoints: 0,
                    moves: rearrangeCount,
                    time: Int((Date().timeIntervalSince1970 - startTimer))
                )
            )
        }

        let eligibleWords = wordStock.filter {
            $0.count >= wordMin && $0.count <= wordMax
        }

        selectedWord = eligibleWords.randomElement() ?? wordStock.randomElement()!

        letters = selectedWord.map {
                    Letter(text: String ($0), point: letterScore[$0] ?? 0)
                }.shuffled()

        removedLetter = nil
        rearrangeCount = 0

        startTimer = Date().timeIntervalSince1970
        elapsedTime = 0
        isComplete = false
    }

    
    func removeLetter(at pos: Int) {
        
        if pos < 0 || pos >= letters.count { return }
        
        removedLetter = letters[pos]

        letters = letters.enumerated().map { index, ch in
            return index == pos ? nil : ch
        }
    }

    
    func unremoveLetter() {
       
        if removedLetter == nil {
            return
        }

        let letter = removedLetter!

        
        previousState = letters

        
        letters = letters.map { ch in
            ch ?? letter
        }

        
        if previousState != letters {
            rearrangeCount += 1
        }

        removedLetter = nil
        checkIfSolved()
    }
    
    

    func swapLetters(_ aPos: Int, _ bPos: Int) {
        if aPos >= letters.count || bPos >= letters.count || aPos == bPos {
            return
        }

        letters.swapAt(aPos, bPos)
        checkIfSolved()
    }
    

    private func checkIfSolved() {
        let currentWord = letters.prettyPrint()

        if currentWord == selectedWord {
            elapsedTime = Date().timeIntervalSince1970 - startTimer
            isComplete = true

            let score = calculateWordScore()
            totalScore += score

            gameHistory.append(
                WordRecord(
                    secretWord: currentWord,
                    wordPoints: score,
                    moves: rearrangeCount,
                    time: Int(elapsedTime)
                )
            )
        }
    }

    private func calculateWordScore() -> Int {
        return letters.compactMap { $0?.point }.reduce(0, +)
    }

    func setWordLength(min: Int, max: Int) {
        wordMin = min
        wordMax = max
    }
}


struct WordRecord: Identifiable {
    let id = UUID()
    let secretWord: String
    let wordPoints: Int
    let moves: Int
    let time: Int
}

