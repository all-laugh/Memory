//
//  ThemeRowView.swift
//  Memory
//
//  Created by Xiao Quan on 5/26/21.
//

import SwiftUI

struct ThemeRowView: View {
    @EnvironmentObject var store: ThemeStore
    var theme: Theme
//    @Binding var editMode: EditMode
    var isEditing: Bool
    
//    var editSymbolSize: CGFloat {
//        editMode.isEditing ? 20 : 0
//    }
    
//    init(theme: Theme, isEditing: Bool) {
//        self.theme = theme
//        self.isEditing = isEditing
//    }
    
    @State var showThemeEditor: Bool = false

    var body: some View {
        HStack {
            Text(self.theme.emojis.first!)
                .font(.title2)
//            Image(systemName: "square.and.pencil")
//                .resizable()
//                .frame(width: editSymbolSize, height: editSymbolSize)
//                .opacity(editMode.isEditing ? 1 : 0)

            Text(store.name(for: theme))
                .font(Font.system(size: 20, weight: .semibold))
                .foregroundColor(Color(theme.cardColor))
            Spacer()
            Text("\(theme.numberOfPairsOfCards) pairs")
                        .font(.caption)
        }
        .popover(isPresented: $showThemeEditor) {
            ThemeEditor(isShowing: $showThemeEditor, themeToEdit: theme)
                .environmentObject(self.store)
        }
        .onTapGesture {
            print("editing? \(isEditing)")
            if isEditing {
                self.showThemeEditor = true
            }
        }
        .disabled(!isEditing)
    }
}

struct ThemeEditor: View {
    @EnvironmentObject var store: ThemeStore
    
    @Binding var isShowing: Bool
    @State private var themeName: String = ""
    @State private var emojisToAdd: String = ""
    
    var themeToEdit: Theme
    
    var body: some View {
        VStack {
            ZStack {
                Text(store.name(for: themeToEdit)).font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowing = false
                    }, label: { Text("Done") }).padding()
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Theme Name", text: $themeName) { isEditing in
                        if !isEditing {
                            self.store.renameTheme(for: themeToEdit, to: themeName)
                        }
                    }
                    
                    ZStack {
                        TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
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
                            }.padding()
                        }
                    }
                }
                
                Section (header: Text("Current Emojis")) {
                    Grid(themeToEdit.emojis.map { String($0) }, id: \.self) { emoji in
                        Text(emoji).font(Font.system(size: self.fontSize))
                            .onTapGesture {
                                self.store.removeEmoji(from: self.themeToEdit, emoji: emoji)
                            }
                    }
                    .frame(height: self.height)
                }
            }
        }.onAppear { self.themeName = store.name(for: themeToEdit) }
    }
    
    //MARK: - Drawing Constants
    var height: CGFloat {
        CGFloat((themeToEdit.emojis.count - 1) / 6) * 70 + 70
    }
    let fontSize: CGFloat = 40
    
}

