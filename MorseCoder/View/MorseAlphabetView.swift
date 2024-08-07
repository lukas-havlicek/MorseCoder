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
      if let num = Int(item.key) {
        let morseNumber = Morse(id: item.key, letter: item.key, code: item.value)
        alphabetNumbers.append(morseNumber)
      }
      if Character(item.key).isSymbol {
        let morseSymbol = Morse(id: item.key, letter: item.key, code: item.value)
        alphabetLetters.append(morseSymbol)
      }
    }
  }
  
  let letterColumns = [GridItem(.fixed(120), spacing: 10, alignment: .leading), GridItem(.fixed(120), spacing: 10, alignment: .leading)]
  let numberColumns = [GridItem(.fixed(150))]
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVGrid(columns: letterColumns, spacing: 10) {
        ForEach(alphabetLetters.sorted(by: { $0.letter < $1.letter })) { item in
          HStack(spacing: 0) {
            Text(item.letter).frame(width: 20)
            Text(":").frame(width: 20)
            setBaselineOffsetToDot(item.code)
              .frame(width: 60, alignment: .center)
              .font(.system(size: 36, weight: .bold))
          }
          .font(.system(size: 24, weight: .bold))
          .padding(.horizontal, 12)
          .frame(width: 120, alignment: .leading)
        }
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
      }
      
      Divider()
      
      LazyVGrid(columns: numberColumns, spacing: 10) {
        ForEach(alphabetNumbers.sorted(by: { $0.letter < $1.letter })) { item in
          HStack(spacing: 0) {
            Text(item.letter).frame(width: 20)
            Text(":").frame(width: 20)
            setBaselineOffsetToDot(item.code)
              .frame(width: 100, alignment: .center)
              .font(.system(size: 36, weight: .bold))
          }
          .font(.system(size: 24, weight: .bold))
          .padding(.horizontal, 12)
          .frame(width: 160, alignment: .leading)
        }
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
      }
    }
    .navigationTitle("Morse Alphabet")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  private func setBaselineOffsetToDot(_ code: String) -> Text {
    var text = Text("")
    
    for char in code {
      if char == "." {
        text = text + Text("\(char)").baselineOffset(13)
      } else {
        text = text + Text("\(char)").baselineOffset(5)
      }
    }
    
    return text
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
