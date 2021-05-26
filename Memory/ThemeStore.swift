//
//  ThemeStore.swift
//  Memory
//
//  Created by Xiao Quan on 5/25/21.
//

import SwiftUI
import Combine

class ThemeStore: ObservableObject {
    @Published var savedThemes: [Theme]
    
    private var autosave: AnyCancellable?
    
    init() {
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
        self.savedThemes.append(theme)
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
