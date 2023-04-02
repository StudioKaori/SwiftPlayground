//
//  SkipToThePosition.swift
//  SwiftuiPlayground
//
//  Created by Kaori Persson on 2023-04-02.
//

import SwiftUI

struct SkipToThePosition: View {
  var body: some View {
    ScrollViewReader { reader in
      Button("25行目にスクロール") {
        reader.scrollTo(25, anchor: .top)
//        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
//          reader.scrollTo(25, anchor: .top)
//        }
      }
      List {
        ForEach(1..<50, id: \.self) { index in
          Text("item \(index)")
            .id(index)
        }
      }
    }
  }
}

struct SkipToThePosition_Previews: PreviewProvider {
  static var previews: some View {
    SkipToThePosition()
  }
}
