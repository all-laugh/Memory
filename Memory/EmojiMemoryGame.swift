//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Xiao Quan on 3/7/21.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    
    // MARK: - Game Model Initialization
    
    @Published private var game: MemorizeGame<String> = createMemorizeGame()
    
    
    private static func createMemorizeGame() -> MemorizeGame<String> {
        let theme = Themes()
        let emojis: Array<String> = theme.emojis
        
        let numPairs = Int.random(in: 3...6)
        
        return MemorizeGame<String> (numberOfPairsOfCards: numPairs, theme: theme) { pairIndex in
            return emojis[pairIndex % emojis.count]
        }
    }
    
    // MARK: - Access to Model
    var cards: Array<MemorizeGame<String>.Card> { game.cards }
    var theme: Themes { game.theme }
    var score: Int { game.score }
    
    // MARK: - User Intents
    func choose(_ card: MemorizeGame<String>.Card) {
        objectWillChange.send()
        game.choose(card)
    }
    
    func resetModel() -> Void {
        self.game = EmojiMemoryGame.createMemorizeGame()
    }
    
}
