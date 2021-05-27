//
//  ThemeStore.swift
//  Memory
//
//  Created by Xiao Quan on 5/25/21.
//

import SwiftUI
import Combine

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var savedThemes: [Theme]
    
    static let themeColors: [UIColor.RGB] = [
        UIColor.systemRed.rgb,
        UIColor.systemBlue.rgb,
        UIColor.systemPurple.rgb,
        UIColor.systemTeal.rgb,
        UIColor.systemGray.rgb,
        UIColor.systemGreen.rgb,
        UIColor.systemOrange.rgb,
        UIColor.systemYellow.rgb,
        UIColor.systemIndigo.rgb,
        UIColor.brown.rgb,
        UIColor.black.rgb
    ]
    
    private var autosave: AnyCancellable?
    
    func name(for theme: Theme) -> String {
        let nameRawValue = theme.themeName
        let nameFirstLetterCapitalized = nameRawValue.prefix(1).capitalized + nameRawValue.dropFirst()
        return nameFirstLetterCapitalized
    }
    
    func renameTheme(for theme: Theme, to newName: String) {
        var newTheme = theme
        newTheme.rename(to: newName)
        swapTheme(previous: theme, new: newTheme)
    }
    
    func addEmojis(to theme: Theme , emojis: String) {
        var newTheme = theme
        var newThemeEmojis = newTheme.emojis
        for emoji in emojis {
            newThemeEmojis.append(String(emoji))
        }
        newTheme.updateEmojis(newEmojis: newThemeEmojis)
        swapTheme(previous: theme, new: newTheme)
    }
    
    func removeEmoji(from theme: Theme, emoji: String ) {
        var newTheme = theme
        var newThemeEmojis = newTheme.emojis
        if let indexToRemove = newThemeEmojis.firstIndex(of: emoji) {
            newThemeEmojis.remove(at: indexToRemove)
        }
        newTheme.updateEmojis(newEmojis: newThemeEmojis)
        swapTheme(previous: theme, new: newTheme)
    }
     
    func setPairsOfCards(for theme: Theme, numberOfPairs: Int) {
        var newTheme = theme
        newTheme.setPairsOfCards(to: numberOfPairs)
        swapTheme(previous: theme, new: newTheme)
    }
    
    func setThemeColor(to color: UIColor.RGB, for theme: Theme) {
        var newTheme = theme
        newTheme.setThemeColor(to: color)
        swapTheme(previous: theme, new: newTheme)
    }
    
    func swapTheme(previous: Theme, new: Theme) {
        if let previousIndex = self.savedThemes.firstIndex(matching: previous) {
            savedThemes.remove(at: previousIndex)
            savedThemes.insert(new, at: previousIndex)
        }
    }
    
    
    init(named name: String = "Memory Game") {
        self.name = name
        let defaultsKey = "MemoryGameThemes"
        self.savedThemes = Array(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? [
            Theme(.animals),
            Theme(.faces),
            Theme(.flags),
            Theme(.foods),
            Theme(.popular),
            Theme(.symbols)
        ]
        
        autosave = $savedThemes.sink { themes in
            UserDefaults.standard.set(themes.json, forKey: defaultsKey)
        }
    }
    
    func addTheme(theme: Theme) {
//        let theme = Theme(emojis: ["🛠", "🧱", "🔧"], themeName: "New Theme", numberOfPairsOfCards: 3, cardColor: UIColor.systemGray.rgb)
        self.savedThemes.append(theme)
    }
    
    func delete(_ theme: Theme) {
        if let indexToRemove = self.savedThemes.firstIndex(matching: theme) {
            self.savedThemes.remove(at: indexToRemove)
        }
    }
    
}

extension Array where Element == Theme {
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let themes = try? JSONDecoder().decode([Theme].self, from: json!) {
            self = themes
        } else {
            return nil
        }
    }
}
