//
//  ThemeChooser.swift
//  Memory
//
//  Created by Xiao Quan on 5/25/21.
//

import SwiftUI

struct ThemeChooser: View {
    @EnvironmentObject var themeStore: ThemeStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(themeStore.savedThemes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(emojiMemoryGame: EmojiMemoryGame(theme: theme))) {
                        Text(theme.themeName)
                    }
                }
            }
        }
    }
}

//struct ThemeChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeChooser()
//    }
//}
