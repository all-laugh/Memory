//
//  ThemeColors.swift
//  Memory
//
//  Created by Xiao Quan on 3/24/21.
//

import Foundation
import SwiftUI

struct ThemeColors {
    var theme: Themes.themes?
    var cardColor: Color
    
    init(gameTheme: Themes) {
        theme = gameTheme.theme
        switch theme {
        case .nationalFlags:
            cardColor = .red
        case .faces:
            cardColor = .yellow
        case .symbols:
            cardColor = .blue
        case .popular:
            cardColor = .purple
        case .animals:
            cardColor = .green
        case .foods:
            cardColor = .orange
        case .none:
            cardColor = .red
        }
    }
}
