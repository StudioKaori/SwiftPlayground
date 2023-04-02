//
//  ContentView.swift
//  SwiftuiPlayground
//
//  Created by Kaori Persson on 2023-03-05.
//

import SwiftUI

struct ContentView: View {

  var body: some View {
    VStack {
      NavigationLink {
        ContentView3()
      } label: {
        Text("Swipe down to load and pull to refresh")
      }

    }
  }
}
