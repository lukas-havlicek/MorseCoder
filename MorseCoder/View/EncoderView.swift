//
//  EncoderView.swift
//  MorseCoder
//
//  Created by Lukas Havlicek on 06.07.2021.
//

import SwiftUI

struct EncoderView: View {
  @Environment(\.colorScheme) var colorScheme
  @ObservedObject var coderViewModel: CoderViewModel
  @State private var keyboardVisible = false
  @State private var editorWidth: CGFloat = 0
  @State private var height: CGFloat = .zero
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Encoded morse")
        .foregroundColor(.secondary)
        .font(.system(size: 14))
      
      TextWithAttributedString(dynamicHeight: $height, attributedString: attribute(coderViewModel.encodingMorse))
        .padding([.leading, .trailing, .bottom], 5)
        .frame(minWidth: editorWidth, minHeight: 50)
        .background(RoundedRectangle(cornerRadius: 5).fill(Color(white: colorScheme == .dark ? 0.1 : 0.9)))
      
      HStack {
        Text("Insert text")
          .font(.system(size: 14))
          .foregroundColor(.secondary)
        Spacer()
        Button(action: {
          coderViewModel.encodingText = ""
        }) {
          Text("Clear all")
            .font(.system(size: 14))
        }
        if keyboardVisible {
          Button(action: {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            keyboardVisible = false
          }) {
            Image(systemName: "keyboard.chevron.compact.down")
              .imageScale(.large)
          }
        }
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
      
      TextEditor(text: $coderViewModel.encodingText)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification), perform: { _ in
          keyboardVisible = true
        })
    }
    .disableAutocorrection(true)
    .autocapitalization(.none)
    .onChange(of: coderViewModel.encodingText, perform: { _ in
      coderViewModel.translateToMorse()
    })
  }
  
  private func attribute(_ text: String) -> NSAttributedString {
    let attributedtext = NSMutableAttributedString(string: "")
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = -15
    let aDot: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30, weight: .bold), .baselineOffset: 6.5, .paragraphStyle: paragraphStyle, .foregroundColor: colorScheme == .dark ? UIColor.white : UIColor.black]
    let aDash: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30, weight: .bold), .paragraphStyle: paragraphStyle, .foregroundColor: colorScheme == .dark ? UIColor.white : UIColor.black]
    let aOther: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 30, weight: .regular), .paragraphStyle: paragraphStyle, .foregroundColor: colorScheme == .dark ? UIColor.white : UIColor.black]
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
  
}

struct EncoderView_Previews: PreviewProvider {
  static var previews: some View {
    EncoderView(coderViewModel: CoderViewModel())
  }
}

/*
struct LabelWithAttributedString: UIViewRepresentable {
  @Binding var dynamicHeight: CGFloat
  var attributedString: NSAttributedString
  
  func makeUIView(context: Context) -> UILabel {
    let label = UILabel(frame: .zero)
    label.attributedText = attributedString
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.textAlignment = .left
    label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    return label
  }
  func updateUIView(_ label: UILabel, context: Context) {
    label.attributedText = attributedString
    DispatchQueue.main.async {
      dynamicHeight = label.sizeThatFits(label.superview?.bounds.size ?? .zero).height
    }
  }
}
*/
