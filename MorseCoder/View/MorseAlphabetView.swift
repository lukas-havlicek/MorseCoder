//
//  MorseAlphabetView.swift
//  MorseCoder
//
//  Created by Lukas Havlicek on 07.08.2024.
//

import SwiftUI

struct MorseAlphabetView: View {
  
  @Environment(\.dismiss) var dismiss
  
  var alphabetLetters: [Morse] = []
  var alphabetNumbers: [Morse] = []
  var alphabetSymbols: [Morse] = []
  
  init() {
    for item in morseAlphabet {
      if Character(item.key).isLetter {
        let morseLetter = Morse(id: item.key, letter: item.key, code: item.value)
        alphabetLetters.append(morseLetter)
      }
      if Character(item.key).isNumber {
        let morseNumber = Morse(id: item.key, letter: item.key, code: item.value)
        alphabetNumbers.append(morseNumber)
      }
      if !Character(item.key).isLetter && !Character(item.key).isNumber {
        let morseSymbol = Morse(id: item.key, letter: item.key, code: item.value)
        alphabetSymbols.append(morseSymbol)
      }
    }
  }
  
  let letterColumns = [GridItem(.fixed(120), spacing: 10, alignment: .leading), GridItem(.fixed(120), spacing: 10, alignment: .leading)]
  let numberColumns = [GridItem(.fixed(160))]
  
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
      
      Text("Numbers")
        .font(.system(size: 20, weight: .bold))
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
      
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
      
      Text("Symbols")
        .font(.system(size: 20, weight: .bold))
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
      
      LazyVGrid(columns: numberColumns, spacing: 10) {
        ForEach(alphabetSymbols.sorted(by: { $0.letter < $1.letter })) { item in
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
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          Label("Back", systemImage: "chevron.left")
        }
      }
    }
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
