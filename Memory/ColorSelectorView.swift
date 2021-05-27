//
//  ColorSelector.swift
//  Memory
//
//  Created by Xiao Quan on 5/27/21.
//

import SwiftUI

struct ColorSelector: View {
    @EnvironmentObject var store: ThemeStore
    @State var selectedColor: UIColor.RGB = UIColor.white.rgb
    var themeToEdit: Theme
    
    var body: some View {
        Grid(ThemeStore.themeColors) { color in
            ZStack {
                EmptyView()
                    .cardify(isFaceUp: false)
                    .foregroundColor(Color(color))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 2)
//                    )
                    .padding(5)
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .bottomTrailing)
//                    .foregroundColor(selectedColor == UIColor.white.rgb ? .black : .white)
                    .opacity(color == self.selectedColor ? 1 : 0)
                    .transition(.scale)
                    .animation(.linear)
            }
            .onTapGesture {
                self.selectedColor = color
                store.setThemeColor(to: color, for: self.themeToEdit)
            }
        }
        .frame(height: self.colorGridFrameHeight)
    }
    
    var colorGridFrameHeight: CGFloat {
        CGFloat((ThemeStore.themeColors.count - 1) / 5) * 70 + 70
    }
}

//struct ColorSelector_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorSelector(selectedColor: Color.white).environmentObject(ThemeStore())
//    }
//}
