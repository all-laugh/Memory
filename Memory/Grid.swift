//
//  Grid.swift
//  Memory
//
//  Created by Xiao Quan on 3/11/21.
//

import SwiftUI

struct Grid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView ) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: items.count, in: geometry.size))
        }

    }
    
    func body (for layout: GridLayout) -> some View {
        ForEach (items) { item in
            self.body(for: item, in: layout)
        }
    } 
    
    func body (for item: Item, in layout: GridLayout ) -> some View {
        let index = self.index(of: item)!
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))

    }
    
    func index (of item: Item) -> Int? {
        var match: Int?
        for index in 0..<self.items.count {
            if items[index].id == item.id {
                match = index
            }
        }
        return match
    }
    
}
