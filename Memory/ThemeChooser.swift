//
//  ThemeChooser.swift
//  Memory
//
//  Created by Xiao Quan on 5/25/21.
//

import SwiftUI

struct ThemeChooser: View {
    @EnvironmentObject var themeStore: ThemeStore
    @State var editMode: EditMode = .inactive
    @State var showThemeEditor: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(themeStore.savedThemes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(theme: theme)
                                    .navigationBarTitle(themeStore.name(for: theme))
                    ) {
                        ThemeRowView(theme: theme, isEditing: editMode.isEditing).environmentObject(self.themeStore)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { self.themeStore.savedThemes[$0] }.forEach { theme in
                        self.themeStore.delete(theme)
                    }
                }
            }
            .navigationBarTitle(self.themeStore.name)
            .navigationBarItems(
                leading: Button(action: {
                    self.themeStore.addTheme()
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }),
                trailing: EditButton()
            ).environment(\.editMode, $editMode)
        }
    }
}

//struct ThemeChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeChooser()
//    }
//}
