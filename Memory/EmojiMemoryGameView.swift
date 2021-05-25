//
//  EmojiMemoryGameView.swift
//  Memory
//
//  Created by Xiao Quan on 3/8/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    var theme: Theme { emojiMemoryGame.theme }
    var cardColor: Color { Color(theme.cardColor) }
    var score: Int { emojiMemoryGame.score }

    var body: some View {
        VStack {
            Text(theme.themeName?.rawValue.uppercased() ?? "no theme")
                .fontWeight(.bold)
                .padding(.top, 10)
                .font(.title)
            Text("Score: \(score)").font(.caption)
            
            Grid(emojiMemoryGame.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear) {
                        emojiMemoryGame.choose(card)
                    }
                }
                    .padding(2)
            }
                .padding(5)
            
            Button("New Game") {
                withAnimation(.linear) {
                    self.emojiMemoryGame.resetGame()
                }
            }
                .padding(.bottom, 15)
                .font(.title)
        }
        .foregroundColor(cardColor)

    }


    struct CardView: View {
        var card: MemorizeGame<String>.Card
        
        var body: some View {
            GeometryReader { geometry in
                self.body(for: geometry.size)
            }
        }
        
        @State private var animatedBonusRemaining: Double = 0
        
        private func startBonusTimeAnimation() {
            animatedBonusRemaining = card.bonusRemaining
            withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                animatedBonusRemaining = 0
            }
        }
        
        @ViewBuilder
        func body (for size: CGSize) -> some View {
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Group {
                        if card.isConsumingBonusTime {
                            CountdownPie(
                                startAngle: Angle(degrees: 0-90),
                                endAngle: Angle(degrees: -animatedBonusRemaining * 360 - 90)
                            )
                            .onAppear {
                                startBonusTimeAnimation()
                            }
                        } else {
                            CountdownPie(
                                startAngle: Angle(degrees: 0-90),
                                endAngle: Angle(degrees: -card.bonusRemaining * 360 - 90)
                            )
                        }
                    }
                    .padding(5)
                    .opacity(0.4)
                    .transition(.scale)

                    Text(card.content)
                        .rotationEffect(Angle.degrees(card.isMatched ? -360 : 0))
                        .animation(card.isMatched ? .linear(duration: 1).repeatForever(autoreverses: false) : .default)
                }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(.scale)
                .font(Font.system(size: font(for: size)))
            }
        }
        
        // MARK: - Drawing Constants
        private func font(for size: CGSize) -> CGFloat {
            min(size.width, size.height ) * 0.65
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            let game = EmojiMemoryGame()
            game.choose(game.cards[0])
            return EmojiMemoryGameView(emojiMemoryGame: game)
        }
    }
}
