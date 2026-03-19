//
//  ContentView.swift
//  dyslexia

import SwiftUI
import Combine

struct ContentView: View {
    init(viewModel: AppViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    @ObservedObject private var viewModel: AppViewModel
    @State private var letters: [Letter?] = []
    
    var body: some View {
        VStack {
            Button("New") {
                viewModel.selectNewWord()
            }.buttonStyle(.borderedProminent)
            Spacer()
            
            let nonNilBinding = Binding<[Letter]>(
                get: { viewModel.letters.compactMap { $0 } },
                set: { viewModel.letters = $0.map { Optional($0) } }
            )

            LetterGroup(letters: nonNilBinding) { arr in
                if let z = arr.prettyPrint() {
                    print("Rearrange \(z)")
                }
                viewModel.letters = arr.map { Optional($0) }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.yellow)
        .onReceive(viewModel.$letters) { newValue in
            print("New word in content view")
            letters = newValue
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: AppViewModel())
    }
}


