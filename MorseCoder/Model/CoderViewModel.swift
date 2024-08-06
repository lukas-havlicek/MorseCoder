//
//  CoderViewModel.swift
//  MorseCoder
//
//  Created by Lukas Havlicek on 05.07.2021.
//

import SwiftUI

class CoderViewModel: ObservableObject {
  @Published var coder: CoderModel = .morseEncoder
  
  @Published var encodingText = ""
  @Published var encodingMorse = ""
  
  @Published var decodingMorse = ""
  @Published var decodingText = ""
  
  @Published var lastLetter = ""
  
  func translateToMorse() {
    var outputMorse = ""
    for letter in encodingText {
      if let dictLetter = morseAlphabet[String(letter.lowercased())] {
        outputMorse.append(dictLetter)
        outputMorse.append(" ")
      } else if letter == " " {
        outputMorse.append("| ")
      }
    }
    encodingMorse = outputMorse
  }
  
  func translateToText() {
    var outputText = ""
    var outputLetters = [String]()
    var morseLetter = ""
    for letter in decodingMorse {
      if letter != " " {
        morseLetter.append(letter)
      } else {
        if morseLetter.isEmpty {
          continue
        }
        outputLetters.append(morseLetter)
        morseLetter = ""
      }
    }
    for morseLetter in outputLetters {
      if let textLetter = morseAlphabet.someKey(forValue: morseLetter) {
        outputText.append(textLetter)
      } else if morseLetter == "|" {
        outputText.append(" ")
      } else {
        outputText.append("$")
      }
    }
    decodingText = outputText
  }
  
  func deleteLast() {
    
  }
  
}

enum CoderModel {
  case morseEncoder, morseDecoder
}

extension Dictionary where Value: Equatable {
  func someKey(forValue val: Value) -> Key? {
    first(where: { $1 == val })?.key
  }
}

struct DotDashModifier: ViewModifier {
  @Environment(\.colorScheme) var colorScheme
  func body(content: Content) -> some View {
    content
      .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
      .frame(width: 90, height: 40)
      .background(colorScheme == .dark ? Color.white : Color.black)
      .clipShape(Capsule())
  }
}
extension View {
  func dotDashModifier() -> some View {
    self.modifier(DotDashModifier())
  }
}
struct SpaceModifier: ViewModifier {
  @Environment(\.colorScheme) var colorScheme
  func body(content: Content) -> some View {
    content
      .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
      .frame(width: 120, height: 40)
      .background(Color.secondary)
      .clipShape(Capsule())
  }
}
extension View {
  func spaceModifier() -> some View {
    self.modifier(SpaceModifier())
  }
}
