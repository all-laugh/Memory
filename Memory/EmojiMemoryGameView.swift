//
//  EmojiMemoryGameView.swift
//  Memory
//
//  Created by Xiao Quan on 3/8/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var emojiMemorizeGame: EmojiMemoryGame
    var theme: Themes { emojiMemorizeGame.theme }
    var themeColor: Color { ThemeColors(gameTheme: theme).cardColor }
    var score: Int { emojiMemorizeGame.score }

    var body: some View {
        
        VStack {
            Text(theme.theme?.rawValue.uppercased() ?? "no theme")
                .fontWeight(.bold)
                .padding(.top, 10)
                .foregroundColor(themeColor)
                .font(.headline)
            Text("Score: \(score)").font(.caption)
        }

        
        Grid(emojiMemorizeGame.cards) { card in
                    CardView(card: card).onTapGesture {
                        emojiMemorizeGame.choose(card)
                    }
                    .padding(2)
        }
        .foregroundColor(themeColor)
//        .font(Font.largeTitle)
        .padding()
        
        Button("New Game") {
            self.emojiMemorizeGame.resetModel()
        }
        .padding(.bottom, 15)
        .foregroundColor(themeColor)
        .font(.headline)
    }
}


struct CardView: View {
    var card: MemorizeGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    func body (for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                CountdownPie(
                    startAngle: Angle(degrees: 0-90),
                    endAngle: Angle(degrees: 110-90)
                )
                .padding(5)
                .opacity(0.4)
                Text(card.content)
            }
            .cardify(isFaceUp: card.isFaceUp)
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
        return EmojiMemoryGameView(emojiMemorizeGame: game)
    }
}
