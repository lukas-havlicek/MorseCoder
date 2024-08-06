//
//  DecoderView.swift
//  MorseCoder
//
//  Created by Lukas Havlicek on 09.07.2021.
//

import SwiftUI

struct DecoderView: View {
  @Environment(\.colorScheme) var colorScheme
  @ObservedObject var coderViewModel: CoderViewModel
  @State private var editorWidth: CGFloat = 0
  @State private var height: CGFloat = .zero
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text("Decoded morse")
          .foregroundColor(.secondary)
          .font(.system(size: 14))
        Spacer()
      }
      .background(GeometryReader { geo in
        Rectangle()
          .fill(Color.clear)
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
              editorWidth = geo.frame(in: .local).width
            }
          }
      })
      
      TextWithAttributedString(dynamicHeight: $height, attributedString: attributeText(coderViewModel.decodingText))
        .padding([.leading, .trailing, .bottom], 10)
        .frame(minWidth: editorWidth, minHeight: 150, alignment: .topLeading)
        .background(RoundedRectangle(cornerRadius: 5).fill(Color(white: colorScheme == .dark ? 0.1 : 0.9)))
      
      HStack {
        Text("Inserted morse")
          .foregroundColor(.secondary)
          .font(.system(size: 14))
        Spacer()
        Button(action: {
          coderViewModel.decodingMorse = ""
          coderViewModel.decodingText = ""
        }) {
          Text("Clear all")
            .font(.system(size: 14))
        }
      }
      
      TextWithAttributedString(dynamicHeight: $height, attributedString: attribute(coderViewModel.decodingMorse))
        .padding([.leading, .trailing, .bottom], 5)
        .frame(minWidth: editorWidth, minHeight: 50)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
      
      VStack(spacing: 10) {
        HStack(spacing: 10) {
          Spacer()
          Button(action: {
            coderViewModel.decodingMorse.append(".")
          }) {
            Circle()
              .frame(width: 10, height: 10)
              .dotDashModifier()
          }
          Button(action: {
            coderViewModel.decodingMorse.append("-")
          }) {
            Rectangle()
              .frame(width: 30, height: 10)
              .dotDashModifier()
          }
          Button(action: {
            if !coderViewModel.decodingMorse.isEmpty {
              if coderViewModel.decodingMorse.hasSuffix(" | ") {
                coderViewModel.decodingMorse.removeLast(2)
              } else if coderViewModel.decodingMorse.hasSuffix("- ") || coderViewModel.decodingMorse.hasSuffix(". ") {
                coderViewModel.decodingMorse.removeLast(2)
              } else {
                coderViewModel.decodingMorse.removeLast()
              }
              coderViewModel.translateToText()
            }
          }) {
            Image(systemName: "delete.left")
              .imageScale(.large)
              .dotDashModifier()
          }
          Spacer()
        }
        HStack(spacing: 10) {
          Spacer()
          Button(action: {
            if !coderViewModel.decodingMorse.isEmpty {
              if coderViewModel.decodingMorse.last != " " {
                coderViewModel.decodingMorse.append(" ")
                coderViewModel.translateToText()
              }
            }
          }) {
            Text("Space")
              .spaceModifier()
          }
          Button(action: {
            if !coderViewModel.decodingMorse.isEmpty {
              if !coderViewModel.decodingMorse.hasSuffix(" | ") && coderViewModel.decodingMorse.last != " " {
                coderViewModel.decodingMorse.append(" | ")
                coderViewModel.translateToText()
              }
            }
          }) {
            Text("Word space")
              .spaceModifier()
          }
          Spacer()
        }
      }
      
    }
  }
  
  private func attribute(_ text: String) -> NSAttributedString {
    let attributedtext = NSMutableAttributedString(string: "")
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = -15
    let aDot: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30, weight: .bold), .paragraphStyle: paragraphStyle, .foregroundColor: colorScheme == .dark ? UIColor.white : UIColor.black]
    let aDash: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30, weight: .bold), .baselineOffset: -6.5, .paragraphStyle: paragraphStyle, .foregroundColor: colorScheme == .dark ? UIColor.white : UIColor.black]
    let aOther: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30, weight: .regular), .baselineOffset: -6.5, .paragraphStyle: paragraphStyle, .foregroundColor: colorScheme == .dark ? UIColor.white : UIColor.black]
    text.forEach {
      if $0 == "-" {
        let txt = NSAttributedString(string: "-", attributes: aDash)
        attributedtext.append(txt)
      } else if $0 == "." {
        let txt = NSAttributedString(string: ".", attributes: aDot)
        attributedtext.append(txt)
      } else {
        let txt = NSAttributedString(string: String($0), attributes: aOther)
        attributedtext.append(txt)
      }
    }
    return attributedtext
  }
  
  private func attributeText(_ text: String) -> NSAttributedString {
    let attributedtext = NSMutableAttributedString(string: "")
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 0
    paragraphStyle.alignment = .left
    let aNormal: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: colorScheme == .dark ? UIColor.white : UIColor.black]
    let aMistake: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.red]
    text.forEach {
      if $0 == "$" {
        let txt = NSAttributedString(string: "?", attributes: aMistake)
        attributedtext.append(txt)
      } else {
        let txt = NSAttributedString(string: String($0), attributes: aNormal)
        attributedtext.append(txt)
      }
    }
    return attributedtext
  }

}

struct DecoderView_Previews: PreviewProvider {
  static var previews: some View {
    DecoderView(coderViewModel: CoderViewModel())
  }
}

struct TextWithAttributedString: UIViewRepresentable {
  @Binding var dynamicHeight: CGFloat
  var attributedString: NSAttributedString
  
  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView(frame: .zero)
    textView.attributedText = attributedString
    textView.textAlignment = .left
    textView.backgroundColor = UIColor(white: 1, alpha: 0)
    textView.isEditable = false
    textView.isSelectable = false
    textView.isScrollEnabled = true
    textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    return textView
  }
  func updateUIView(_ textView: UITextView, context: Context) {
    textView.attributedText = attributedString
    DispatchQueue.main.async {
      dynamicHeight = textView.sizeThatFits(textView.superview?.bounds.size ?? .zero).height
    }
  }
}
