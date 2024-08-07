//
//  MorseAlphabetView.swift
//  MorseCoder
//
//  Created by Lukas Havlicek on 07.08.2024.
//

import SwiftUI

struct MorseAlphabetView: View {
  
  var alphabet: [Morse] = []
  
  init() {
    for item in morseAlphabet {
      let morseLetter = Morse(id: item.key, letter: item.key, code: item.value)
      alphabet.append(morseLetter)
    }
  }
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(.fixed(20))], alignment: .leading, spacing: 10, pinnedViews: []) {
        Text("Placeholder")
        Text("Placeholder")
      }
    }
    .navigationTitle("Morse Alphabet")
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

#Preview {
  MorseAlphabetView()
}


struct Morse: Identifiable {
  let id: String
  let letter: String
  let code: String
}
