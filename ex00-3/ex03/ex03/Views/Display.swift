//
//  Display.swift
//  ex03
//
//  Created by jules bernard on 16.10.25.
//


import SwiftUI

struct Display: View {
    @ObservedObject var viewModel: CoreViewModel

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.expression)
                    .font(.system(size: 30))
                Text(viewModel.result)
                    .font(.system(size: 60, weight: .bold))
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
