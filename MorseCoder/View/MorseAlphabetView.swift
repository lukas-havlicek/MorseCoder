//
//  MorseAlphabetView.swift
//  MorseCoder
//
//  Created by Lukas Havlicek on 07.08.2024.
//

import SwiftUI

struct MorseAlphabetView: View {
  
  var alphabetLetters: [Morse] = []
  var alphabetNumbers: [Morse] = []
  var alphabetSymbols: [Morse] = []
  
  init() {
    for item in morseAlphabet {
      if Character(item.key).isLetter {
        let morseLetter = Morse(id: item.key, letter: item.key, code: item.value)
        alphabetLetters.append(morseLetter)
      }
    }
  }
  
  let columns = [GridItem(.fixed(120), spacing: 20, alignment: .leading), GridItem(.fixed(120), spacing: 20, alignment: .leading)]
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVGrid(columns: columns, spacing: 10) {
        ForEach(alphabetLetters.sorted(by: { $0.letter < $1.letter })) { item in
          HStack {
            Text(item.letter)
            Text(item.code)
          }
          .font(.system(size: 30, weight: .bold))
          .padding()
          .frame(width: 120)
        }
        .background(Color.yellow)
      }
    }
    .navigationTitle("Morse Alphabet")
    .navigationBarTitleDisplayMode(.inline)
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
