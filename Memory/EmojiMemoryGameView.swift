//
//  EmojiMemoryGameView.swift
//  Memory
//
//  Created by Xiao Quan on 3/8/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var emojiMemorizeGame: EmojiMemoryGame

    var body: some View {
        Grid(emojiMemorizeGame.cards) { card in
                    CardView(card: card).onTapGesture {
                        emojiMemorizeGame.choose(card)
                    }
                    .padding(2)
        }
        .foregroundColor(.green)
        .font(Font.largeTitle)
        .padding()
        
    }
}


struct CardView: View {
    var card: MemorizeGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: borderWidth)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius).fill()
                    }
                }
            }
//            .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
            .font(Font.system(size: font(for: geometry.size)))
        }
    }
    
    // MARK: - Drawing Constants
    let cornerRadius: CGFloat = 10.0
    let borderWidth: CGFloat = 3.0
    func font(for size: CGSize) -> CGFloat {
        min(size.width, size.height ) * 0.75
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(emojiMemorizeGame: EmojiMemoryGame())
    }
}
