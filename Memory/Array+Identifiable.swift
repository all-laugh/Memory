//
//  Array+Identifiable.swift
//  Memory
//
//  Created by Xiao Quan on 3/23/21.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex (matching item: Element) -> Int? {
        var match: Int?
        for index in 0..<self.count {
            if self[index].id == item.id {
                match = index
            }
        }
        return match
    }
}
