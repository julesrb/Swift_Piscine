//
//  FormPopup.swift
//  diary_app
//
//  Created by jules bernard on 19.11.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct FormPopup: View {
    @ObservedObject var authVM: AuthenticationVM
    @Binding var showForm: Bool
    @State var title: String = ""
    @State var text: String = ""
    @FocusState private var isKeyboardFocused: Bool
    let emojis = ["😢", "😐", "😊", "😃", "🤩"]
    @State private var sliderValue: Double = 2
    var body: some View {
        VStack {
            Image(systemName: "arrow.up")
                .onTapGesture {
                    showForm = false
                }
            VStack(alignment: .leading) {
                Text("Title")
                    .font(Font.custom("AbhayaLibre-Regular", size: 20))
                TextField("Enter title", text: $title)
                    .font(Font.custom("AbhayaLibre-Regular", size: 20))
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(10)
                    .focused($isKeyboardFocused)
                
                Text("Content")
                    .font(Font.custom("AbhayaLibre-Regular", size: 20))
                TextEditor(text: $text)
                    .font(Font.custom("AbhayaLibre-Regular", size: 20))
                    .frame(height: 150)
                    .cornerRadius(12)
                    .focused($isKeyboardFocused)
                
                HStack {
                    Slider(
                        value: $sliderValue,
                        in: 0...Double(emojis.count - 1),
                        step: 1
                    )
                    .accentColor(.yellow)
                    Text(emojis[Int(sliderValue)])
                        .font(.system(size: 50))
                        .padding(.leading, 5)
                }
                .padding()
                
            }
                Button("submit") {
                    print("email before submit \(authVM.userEmail)")
                    let icon = emojis[Int(sliderValue)]
                    if title.isEmpty {
                        print("Title is empty")
                        return
                    }

                    if text.isEmpty {
                        print("Text is empty")
                        return
                    }

                    if icon.isEmpty {
                        print("Icon is empty")
                        return
                    }

                    if authVM.userEmail.isEmpty {
                        print("User email is empty")
                        return
                    }
                    showForm = false
                    let db = Firestore.firestore()
                    let newNote = Notes(
                        date: Date(),
                        icon: icon,
                        text: text,
                        title: title,
                        usermail: authVM.userEmail,
                        uuid: authVM.user!.uid)
                    let ref = db.collection("notes").document()
                    do {
                        try ref.setData(from: newNote)
                    } catch let error {
                        print("Error writing note to Firestore: \(error)")
                    }
            }
                .font(Font.custom("AbhayaLibre-Regular", size: 20))
                .foregroundColor(.black)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isKeyboardFocused = false
        }
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
