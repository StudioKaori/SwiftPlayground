//
//  KeepScrollPosition.swift
//  SwiftuiPlayground
//
//  Created by Kaori Persson on 2023-04-06.
//

import SwiftUI

struct KeepScrollPosition: View {
  @State var items = Array(0..<20)
  @State var currentID: Int? = nil
  
  var body: some View {
    VStack {
      Button("Add Item") {
        items.append(items.count)
      }
      List {
        ScrollViewReader { scrollView in
          ForEach(items, id: \.self) { item in
            Text("Item \(item)")
              .frame(height: 50)
              .background(Color.gray)
              .id(item)
              .onAppear {
                // Set the current ID when the view appears
                currentID = item
              }
          }
          .onChange(of: items) { _ in
            // Restore the previous scroll position after updating the data source
            if let id = currentID {
              scrollView.scrollTo(id, anchor: .center)
            }
          }
        }
      }
      .refreshable {
        items = [111,222,333] + items
      }
    }
  }
}
