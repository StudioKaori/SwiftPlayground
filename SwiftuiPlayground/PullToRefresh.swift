//
//  PullToRefresh.swift
//  SwiftuiPlayground
//
//  Created by Kaori Persson on 2023-03-31.
//

import SwiftUI

import SwiftUI
struct ContentView3: View {
  
  @ObservedObject var viewModel: ViewModel3 = .init()
  
  var body: some View {
    
 
      List {
        //アイテム表示領域
        ForEach.init(self.viewModel.items, id: \.self) { value in
          Text(value)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.init(white: 0.9).clipShape(RoundedRectangle(cornerRadius: 8))
              .shadow(radius: 4))
            .padding(4)
            .onAppear() {
              if value == self.viewModel.items.last {
                self.viewModel.loadMore()
              }
              
//              if value == self.viewModel.items.first {
//                self.viewModel.appendItemsOnTop()
//              }
            }
        }
      
        
      }
      .refreshable {
        self.viewModel.appendItemsOnTop()
      }
      
  
    
    
  }
}

class ViewModel3: ObservableObject {
  
  @Published var items: [String] = [] //アイテム表示用の情報
  
  private let max: Int = 100 //最大アイテム数
  private let countPerPage: Int = 20 //ページあたりのアイテム数
  
  private var current = 0
  
  init() {
    
    items = (0..<countPerPage).map({ "Item : \($0+1)" })
    current += items.count
    debugPrint(items)
  }
  
  func appendItems() {
    let newItems = (0..<countPerPage).map({ "Item : \($0+current+1)" })
    current+=newItems.count
    items+=newItems
    debugPrint(items)
  }
  
  func appendItemsOnTop() {
    let newItems = (0..<countPerPage).map({ "Item : \($0+current+1)" })
    current+=newItems.count
    items = newItems + items
    debugPrint(items)
  }
  
}

extension ViewModel3 {
  
  /// さらに読み込めるかどうか
  var canLoadMore: Bool {
    return items.count < max
  }
  
  /// さらに読み込み処理
  func loadMore() {
    
    //通信的な感じを出すため、１秒後に追加を実行
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
      self?.appendItems() //アイテムを20個追加
    }
    
  }
  
}


