//
//  Themes.swift
//  Memory
//
//  Created by Xiao Quan on 3/24/21.
//

import Foundation

struct Themes {
    enum themes: String, CaseIterable {
        case nationalFlags, faces, symbols, popular, animals, foods
    }
    var emojis: Array<String>
    var theme: themes?
    
    init() {
        theme = themes.allCases.randomElement()
        switch theme {
        case .nationalFlags:
            emojis = ["🇨🇳", "🇺🇸", "🇨🇷", "🇦🇶", "🇦🇷", "🇧🇯", "🇧🇷"]
        case .faces:
            emojis = ["😀", "😃","😄","😁", "😆", "😝"]
        case .symbols:
            emojis = ["🚼", "⚧", "⏯", "🚮", "💹", "⏯"]
        case .popular:
            emojis = ["🈲", "💯", "🍻", "✌️", "🎉"]
        case .animals:
            emojis = ["🐶", "🐺", "🐙", "🪰", "🐸", "🦁", "🐛"]
        case .foods:
            emojis = ["🥑", "🍓", "🧀", "🍖", "🥬", "🌶"]
            
        case .none:
            emojis = ["📵"]
        }
    }

}
