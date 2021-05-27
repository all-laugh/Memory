//
//  ThemeEditor.swift
//  Memory
//
//  Created by Xiao Quan on 5/27/21.
//

import SwiftUI

struct ThemeEditor: View {
    @EnvironmentObject var store: ThemeStore
    
    @State private var themeName: String = ""
    @State private var emojisToAdd: String = ""
    @State private var numberOfPairsOfCards: Int = 3
    
    private var themeToEdit: Theme
    private var maxCardPairCount: Int {
        self.themeToEdit.emojis.count
    }
    
    init (themeToEdit: Theme) {
        self.themeToEdit = themeToEdit
        _numberOfPairsOfCards = State(wrappedValue: self.themeToEdit.emojis.count)
    }
    
    var body: some View {
        VStack {
            Text(store.name(for: themeToEdit)).font(.headline).padding()
            Divider()
            Form {
                Section(header: Text("Theme Name")) {
                    TextField("Theme Name", text: $themeName) { isEditing in
                        if !isEditing {
                            self.store.renameTheme(for: themeToEdit, to: themeName)
                        }
                    }
                }
                Section(header: Text("Add Emoji")) {
                    ZStack {
                        TextField("Emoji", text: $emojisToAdd, onEditingChanged: { began in
                            if !began {
                                self.store.addEmojis(to: themeToEdit, emojis: emojisToAdd)
                                self.emojisToAdd = ""
                            }
                        })
                        HStack {
                            Spacer()
                            Button("Add") {
                                self.store.addEmojis(to: themeToEdit, emojis: emojisToAdd)
                                self.emojisToAdd = ""
                            }
                            .opacity( self.emojisToAdd.isEmpty ? 0 : 1)
                            .padding()
                        }
                    }
                }
                Section(header: Text("Current Emojis"), footer: Text("Tap to exclude. 2 emojis minimum.")) {
                    Grid(themeToEdit.emojis.map { String($0) }, id: \.self) { emoji in
                        Text(emoji).font(Font.system(size: self.fontSize))
                            .onTapGesture {
                                if self.themeToEdit.emojis.count > 2 {
                                    self.store.removeEmoji(from: self.themeToEdit, emoji: emoji)
                                    self.numberOfPairsOfCards = themeToEdit.emojis.count
                                }
                            }
                    }
                    .frame(height: self.emojiGridFrameHeight)
                }
                Section(header: Text("Card Count"), footer: Text("\(maxCardPairCount) pairs maximum.")) {
                    Stepper(value: $numberOfPairsOfCards, in: 2...maxCardPairCount) { isEditing in
                        if !isEditing {
                            self.store.setPairsOfCards(for: themeToEdit, numberOfPairs: numberOfPairsOfCards)
                        }
                    } label: {
                        Text("\(numberOfPairsOfCards) pairs of cards")

                    }
                }
                Section(header: Text("Card Color")) {
                    ColorSelector(store: _store, selectedColor: themeToEdit.cardColor, themeToEdit: themeToEdit)
                }
            }
        }
        .onAppear { self.themeName = store.name(for: themeToEdit) }
    }
    
    //MARK: - Drawing Constants
    var emojiGridFrameHeight: CGFloat {
        CGFloat((themeToEdit.emojis.count - 1) / 6) * 70 + 70
    }
    
    let fontSize: CGFloat = 40
    
}

