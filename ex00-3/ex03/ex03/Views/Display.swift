//
//  Display.swift
//  ex03
//
//  Created by jules bernard on 16.10.25.
//


import SwiftUI

class DisplayViewModel: ObservableObject {
    @Published var expression = "..."
    @Published var result = "0"
}

struct Display: View {
    @StateObject var displayViewModel = DisplayViewModel()

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text(displayViewModel.expression)
                    .font(.system(size: 30))
                Text(displayViewModel.result)
                    .font(.system(size: 60, weight: .bold))
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
