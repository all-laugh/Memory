//
//  ContentView.swift
//  Memory
//
//  Created by Xiao Quan on 3/8/21.
//

import SwiftUI

struct ContentView: View {
    
    var emojiMemorizeGame: EmojiMemoryGame

    var body: some View {
        let fiveOrMore = emojiMemorizeGame.cards.count >= 5
        HStack {
            ForEach(emojiMemorizeGame.cards) { card in
                if fiveOrMore {
                    CardView(card: card).onTapGesture {
                        emojiMemorizeGame.choose(card: card)
                    }.font(Font.title)
                }
                else {
                    CardView(card: card).onTapGesture {
                        emojiMemorizeGame.choose(card: card)
                    }
                }
                
            }
        }
        .foregroundColor(.orange)
        .font(Font.largeTitle)
        .padding()
        
    }
}


struct CardView: View {
    var card: MemorizeGame<String>.Card
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text(card.content).foregroundColor(.black)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
        .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(emojiMemorizeGame: EmojiMemoryGame())
    }
}
