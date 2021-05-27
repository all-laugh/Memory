//
//  ThemeEditor.swift
//  Memory
//
//  Created by Xiao Quan on 5/27/21.
//

import SwiftUI

struct ThemeEditor: View {
    @EnvironmentObject var store: ThemeStore
    
    @Binding var isShowing: Bool
    @State private var themeName: String = ""
    @State private var emojisToAdd: String = ""
    @State private var numberOfPairsOfCards: Int = 3
    
    var themeToEdit: Theme
    
    init (isShowing: Binding<Bool>, themeToEdit: Theme) {
        self._isShowing = isShowing
        self.themeToEdit = themeToEdit
        _numberOfPairsOfCards = State(wrappedValue: self.themeToEdit.numberOfPairsOfCards)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Text(store.name(for: themeToEdit)).font(.headline).padding()
                HStack {
                    Button(action: {
                        self.isShowing = false
                    }, label: { Text("Cancel") }).padding()
                    Spacer()
                    Button(action: {
                        
                        self.isShowing = false
                    }, label: { Text("Done") }).padding()
                }
            }
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
                Section(header: Text("Current Emojis"), footer: Text("Tap to exclude.")) {
                    Grid(themeToEdit.emojis.map { String($0) }, id: \.self) { emoji in
                        Text(emoji).font(Font.system(size: self.fontSize))
                            .onTapGesture {
                                self.store.removeEmoji(from: self.themeToEdit, emoji: emoji)
                            }
                    }
                    .frame(height: self.height)
                }
                
                Section(header: Text("Card Number")) {
                    Stepper(value: $numberOfPairsOfCards, in: 2...15) { isEditing in
                        if !isEditing {
                            self.store.setPairsOfCards(for: themeToEdit, pair: numberOfPairsOfCards)
                        }
                    } label: {
                        Text("\(numberOfPairsOfCards) pairs of cards.")

                    }
                }
            }
        }
        .onAppear { self.themeName = store.name(for: themeToEdit) }
    }
    
    //MARK: - Drawing Constants
    var height: CGFloat {
        CGFloat((themeToEdit.emojis.count - 1) / 6) * 70 + 70
    }
    let fontSize: CGFloat = 40
    
}

