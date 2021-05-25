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
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let indexOfCurrentFaceUpCard = indexOfTheOneOnlyFaceUpCard {
                if cards[indexOfCurrentFaceUpCard].content == cards[chosenIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[indexOfCurrentFaceUpCard].isMatched = true
                    score += 2
//                    indexOfTheOneOnlyFaceUpCard = nil
                } else {
                    let cardsInvolved = [cards[indexOfCurrentFaceUpCard], cards[chosenIndex]]
                    let scoreDeduction = cardsInvolved.indices.filter { cardsInvolved[$0].hasSeen }.count
                    score -= scoreDeduction
                    cards[chosenIndex].hasSeen = true
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneOnlyFaceUpCard = chosenIndex
                cards[chosenIndex].hasSeen = true
            }
        }
    }
    
    // MARK: - Card Struct
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false {
            didSet{
                if isFaceUp {
                    startUsingBonusTime()
                }else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false{
            didSet{
                stopUsingBonusTime()
            }
        }
        var hasSeen: Bool = false
        var content: CardContent

        // MARK: - Bonus Time
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        // can be zero which means "no bonus points" for this card
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever face up
        private var faceUptime: TimeInterval {
           if let lastFaceUpDate = lastFaceUpDate {
               return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
           } else {
               return pastFaceUpTime
           }
        }

        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
           max(0, bonusTimeLimit - pastFaceUpTime)
        }

        // percentage of the bonus time remaining
        var bonusRemaining: Double {
           (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }

        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
           isMatched && bonusTimeRemaining > 0
        }

        // whether we are currently face up, unmatched and
        // have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
           isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
           if isConsumingBonusTime, lastFaceUpDate == nil {
               lastFaceUpDate = Date()
           }
        }

        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
           pastFaceUpTime = faceUptime
           lastFaceUpDate = nil
        }
    }
    
}
