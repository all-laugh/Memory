//
//  ThemeChooserRowView.swift
//  Memory
//
//  Created by Xiao Quan on 5/26/21.
//

import SwiftUI

struct ThemeChooserRowView: View {
    @EnvironmentObject var store: ThemeStore
    var theme: Theme
    var isEditing: Bool
    
    var editSymbolSize: CGFloat {
        isEditing ? 20 : 0
    }
    
//    init(theme: Theme, isEditing: Bool) {
//        self.theme = theme
//        self.isEditing = isEditing
//    }
    
    @State var showThemeEditor: Bool = false

    var body: some View {
        HStack {
            Text(self.theme.emojis.first!)
                .font(.title2)
            Group {
                Text(store.name(for: theme))
                    .font(Font.system(size: 20, weight: .semibold))
                Spacer()
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .frame(width: editSymbolSize, height: editSymbolSize)
                    .opacity(isEditing ? 1 : 0)
                    .onTapGesture {
                        print("editing? \(isEditing)")
                        if isEditing {
                            self.showThemeEditor = true
                        }
                    }
                    .disabled(!isEditing)
            }
            .foregroundColor(Color(theme.cardColor))
            Text("\(theme.numberOfPairsOfCards) pairs")
                        .font(.caption)
        }
        .popover(isPresented: $showThemeEditor) {
            ThemeEditor(themeToEdit: theme)
                .environmentObject(self.store)
        }
    }
}



