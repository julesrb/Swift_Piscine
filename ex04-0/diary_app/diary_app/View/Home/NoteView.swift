//
//  NoteView.swift
//  diary_app
//
//  Created by jules bernard on 19.11.25.
//

import SwiftUI


struct NoteView: View {
    @State var note: Notes
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading) {
                    Text(note.date.formatted())
                        .font(Font.custom("AbhayaLibre-Regular", size: 16))
                    Text("\(note.title)  \(note.icon)")
                        .font(Font.custom("AbhayaLibre-Regular", size: 32))
                        .padding(.bottom, 5)
                    
                }
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(12)
        }
        .background(Color(red: 245/255, green: 245/255, blue: 245/255))
        .cornerRadius(22)
    }
}

#Preview {
    let mockAuth = MockAuthVM()
    let mockNotes = MockNoteVM(authVM: mockAuth)

    HomeScreen(
        authVM: mockAuth,
        appScreen: .constant(.home),
        notesVM: mockNotes
    )
}
