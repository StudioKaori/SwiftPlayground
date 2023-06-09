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
        Text("LIST: Swipe down to load and pull to refresh")
      }
      
      NavigationLink {
        SkipToThePosition()
      } label: {
        Text("LIST: Skip to the position")
      }

      NavigationLink {
        KeepScrollPosition()
      } label: {
        Text("LIST: KeepScrollPosition")
      }
      
      NavigationLink {
        ImageUploaderWithLocation()
      } label: {
        Text("ImageUploaderWithLocationView")
      }

      
    }
  }
}
