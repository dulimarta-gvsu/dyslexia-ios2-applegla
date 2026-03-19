//
//  Letter.swift
//  dyslexia

import Foundation

struct Letter: Equatable, Hashable {
    var text: String = ""
    var point: Int = 0
}

extension Array<Letter?> {
    func prettyPrint() -> String {
        return self
            .filter { $0 != nil }
            .map { String($0!.text) }
            .joined(separator: "")
    }
}

extension Array<Letter> {
    func prettyPrint() -> String {
        return self
            .map { "\($0.text)" }
            .joined(separator: "")
    }
}

extension Array<Letter> {
    func prettyPrint() -> String? {
        return self.map { $0.text }.joined()
    }
}
