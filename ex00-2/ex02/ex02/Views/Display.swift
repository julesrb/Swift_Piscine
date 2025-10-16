//
//  Display.swift
//  ex02
//
//  Created by jules bernard on 16.10.25.
//


import SwiftUI

struct Display: View {
    @State var expression = "...+...-.../...*...?"
    @State var result = "0"

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text(expression)
                    .font(.system(size: 30))
                Text(result)
                    .font(.system(size: 60, weight: .bold))
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
