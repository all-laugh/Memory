//
//  Themes.swift
//  Memory
//
//  Created by Xiao Quan on 3/24/21.
//

import SwiftUI

struct Theme: Codable {
    enum Themes: String, CaseIterable, Codable {
        case flags, faces, symbols, popular, animals, foods
    }
    var emojis: Array<String>
    var themeName: Themes?
    var numberOfPairsOfCards: Int
    var cardColor: UIColor.RGB
    
    init(theme: Themes) {
//        self.theme = Themes.allCases.randomElement()
        self.themeName = theme
        switch theme {
        case .flags:
            emojis = ["🇨🇳", "🇺🇸", "🇨🇷", "🇦🇶", "🇦🇷", "🇧🇯", "🇧🇷"]
            numberOfPairsOfCards = 5
            cardColor = UIColor.systemRed.rgb
        case .faces:
            emojis = ["😀", "😃","😄","😁", "😆", "😝"]
            numberOfPairsOfCards = 3
            cardColor = UIColor.systemYellow.rgb
        case .symbols:
            emojis = ["🚼", "⚧", "⏯", "🚮", "💹", "⏯"]
            numberOfPairsOfCards = 4
            cardColor = UIColor.systemBlue.rgb
        case .popular:
            emojis = ["🈲", "💯", "🍻", "✌️", "🎉"]
            numberOfPairsOfCards = 4
            cardColor = UIColor.systemPurple.rgb
        case .animals:
            emojis = ["🐶", "🐺", "🐙", "🪰", "🐸", "🦁", "🐛"]
            numberOfPairsOfCards = 7
            cardColor = UIColor.systemGreen.rgb
        case .foods:
            emojis = ["🥑", "🍓", "🧀", "🍖", "🥬", "🌶"]
            numberOfPairsOfCards = 5
            cardColor = UIColor.systemOrange.rgb
            
//        case .none:
//            emojis = ["📵"]
//            numberOfPairsOfCards = 1
//            cardColor = UIColor.red.rgb
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
//    init?(json: Data?) {
//        if json != nil, let initializedTheme = try? JSONDecoder().decode(Themes.self, from: json!) {
//
//        }
//    }

}
