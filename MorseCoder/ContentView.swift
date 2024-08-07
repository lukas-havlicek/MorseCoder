//
//  ContentView.swift
//  MorseCoder
//
//  Created by Lukas Havlicek on 05.07.2021.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.colorScheme) var colorScheme
  @StateObject var coderViewModel = CoderViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
        if coderViewModel.coder == .morseEncoder {
          EncoderView(coderViewModel: coderViewModel)
        }
        if coderViewModel.coder == .morseDecoder {
          DecoderView(coderViewModel: coderViewModel)
        }
      }
      .padding()
      .navigationTitle("Morse Coder")
      .navigationBarItems(leading: Button(action: {
        coderViewModel.coder = .morseEncoder
      }) {
        Text("Encoder")
          .font(.system(size: 14))
          .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
          .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
          .background(colorScheme == .dark ? coderViewModel.coder == .morseEncoder ? Color.white : Color.secondary : coderViewModel.coder == .morseEncoder ? Color.primary : Color.secondary)
          .clipShape(Capsule())
      }, trailing: 
        HStack {
          NavigationLink(destination: MorseAlphabetView()) {
            Image(systemName: "list.bullet.circle.fill")
              .scaleEffect(CGSize(width: 1.5, height: 1.5))
              .padding(.trailing, 16)
          }
          Button(action: {
            coderViewModel.coder = .morseDecoder
          }) {
            Text("Decoder")
              .font(.system(size: 14))
              .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
              .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
              .background(colorScheme == .dark ? coderViewModel.coder == .morseDecoder ? Color.white : Color.secondary : coderViewModel.coder == .morseDecoder ? Color.primary : Color.secondary)
              .clipShape(Capsule())
          }
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .ignoresSafeArea()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
