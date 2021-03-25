//
//  Grid.swift
//  Memory
//
//  Created by Xiao Quan on 3/11/21.
//

import SwiftUI

struct Grid<Item: Identifiable, ItemView: View>: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView ) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: items.count, in: geometry.size))
        }

    }
    
    private func body (for layout: GridLayout) -> some View {
        ForEach (items) { item in
            self.body(for: item, in: layout)
        }
    } 
    
    private func body (for item: Item, in layout: GridLayout ) -> some View {
        let index = self.items.firstIndex(matching: item)
        return viewForItem(item)
                .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                .position(layout.location(ofItemAt: index!))
    }
}
