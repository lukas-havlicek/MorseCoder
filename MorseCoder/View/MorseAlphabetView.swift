//
//  MorseAlphabetView.swift
//  MorseCoder
//
//  Created by Lukas Havlicek on 07.08.2024.
//

import SwiftUI

struct MorseAlphabetView: View {
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
