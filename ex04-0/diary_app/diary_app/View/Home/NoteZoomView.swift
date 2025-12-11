//
//  NoteZoomView.swift
//  diary_app
//
//  Created by jules bernard on 19.11.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct NoteZoomView: View {
    @State var note: Notes
    @Binding var openNote: Bool
    
    func deleteDocument() {
        let db = Firestore.firestore()
        Task {
            do {
                try await db.collection("notes").document(note.id!).delete()
                print("Document successfully removed!")
            } catch {
                print("Error removing document: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (alignment: .leading) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .onTapGesture {
                                openNote = false
                            }
                            .font(.system(size: 25))
                            .padding(.bottom, 5)
                        Text(note.date.formatted())
                            .font(Font.custom("AbhayaLibre-Regular", size: 16))
                        Spacer()
                        Text(note.icon)
                            .font(.system(size: 42))
                    }
                    Text(note.title)
                        .font(Font.custom("AbhayaLibre-Regular", size: 60))
                        .padding(.bottom, 5)
                    Text(note.text)
                        .font(Font.custom("AbhayaLibre-Regular", size: 32))
                        .padding(.bottom, 5)
                    
                }
            }
            Spacer()
            Text("Delete")
                .font(Font.custom("AbhayaLibre-Regular", size: 20))
                .foregroundColor(.red)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    openNote = false
                    deleteDocument()
                }
        }
        .padding(20)
        .background(Color(red: 245/255, green: 245/255, blue: 245/255))
        .frame(maxWidth: .infinity, alignment: .leading)
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
