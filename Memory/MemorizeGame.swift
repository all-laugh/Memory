//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Xiao Quan on 3/6/21.
//

import Foundation

struct MemorizeGame<CardContent: Equatable> {
    
    // MARK: - Initializer
    private(set) var cards: Array<Card>
    private(set) var theme: Themes
    private(set) var score = 0
    
    private var indexOfTheOneOnlyFaceUpCard: Int? {
        get {
            let faceUpCards = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpCards.only
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
                
            }
        }
    }
    
    var indicesOfSeenCards: Array<Int> {
        cards.indices.filter { cards[$0].hasSeen }
    }

    
    // Initializes n numbers of pairs of card with game specific content
    init(numberOfPairsOfCards: Int, theme: Themes, cardContent: (Int)->CardContent) {
        cards = Array<Card>()
        self.theme = theme
        for index in 0..<numberOfPairsOfCards {
            let content = cardContent(index)
            cards.append( Card(id: index * 2, content: content))
            cards.append( Card(id: index * 2 + 1, content: content ))
        }
        cards.shuffle()
    }
    
    // MARK: - Player Functions
    
    mutating func choose(_ card: Card) {
//        print("-------------------------------------------------")
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneOnlyFaceUpCard {
//                print("---There is a face up card---")
                if cards[potentialMatchIndex].content == cards[chosenIndex].content {
//                    print("--There is a match--")
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
//                    print("-flip everything down-")
                    indexOfTheOneOnlyFaceUpCard = nil
                    return
                }
                else {
//                    print("--There is a mismatch--")
                    let cardsInvolved = [cards[potentialMatchIndex], cards[chosenIndex]]
//                    print("cards involved: \(cardsInvolved)")
                    let scoreDeduction = cardsInvolved.indices.filter { cardsInvolved[$0].hasSeen }.count
//                    print(cardsInvolved.indices.filter { cardsInvolved[$0].hasSeen })
//                    print("score deduction: \(scoreDeduction)")
                    score -= scoreDeduction
//                    print("setting chosen card to hasSeen")
                    cards[potentialMatchIndex].hasSeen = true
                    cards[chosenIndex].hasSeen = true
                }
            } else {
//                print("---There is no faceUp card, setting the chosen one to be the one---")
                indexOfTheOneOnlyFaceUpCard = chosenIndex
                
            }
//            print("setting the chosen card to be faced up")
            self.cards[chosenIndex].isFaceUp = true
//            print("the only faceUp card: \(indexOfTheOneOnlyFaceUpCard)")
//            print("seen cards: \(indicesOfSeenCards)")
//            print("-------------------------------------------------")
        }
    }
    
    // MARK: - Card Struct
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var hasSeen: Bool = false
    }
    
}
