//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Xiao Quan on 3/7/21.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    // MARK: - Game Model Initialization
    
    @Published private var game: MemorizeGame<String>
    @Published var theme: Theme
    
    init(theme: Theme) {
        self.theme = theme
        self.game = EmojiMemoryGame.createMemorizeGame(theme: theme)
    }
    
    private static func createMemorizeGame(theme: Theme) -> MemorizeGame<String> {
//        print("json = \(String(data: theme.json!, encoding: .utf8) ?? "nil")")
        let emojis: Array<String> = theme.emojis
        
        let numPairs = theme.numberOfPairsOfCards
        
        return MemorizeGame<String> (numberOfPairsOfCards: numPairs) { pairIndex in
            return emojis[pairIndex % emojis.count]
        }
    }
    
    // MARK: - Access to Model
    var cards: Array<MemorizeGame<String>.Card> { game.cards }
    var score: Int { game.score }
    
    // MARK: - User Intents
    func choose(_ card: MemorizeGame<String>.Card) {
        objectWillChange.send()
        game.choose(card)
    }
    
    func resetGame() -> Void {
        self.game = EmojiMemoryGame.createMemorizeGame(theme: self.theme)
    }
    
}
