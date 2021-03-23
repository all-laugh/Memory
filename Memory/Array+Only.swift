//
//  Array+Only.swift
//  Memory
//
//  Created by Xiao Quan on 3/23/21.
//

import Foundation

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
