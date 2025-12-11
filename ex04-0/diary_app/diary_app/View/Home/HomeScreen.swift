//
//  HomeScreen.swift
//  diary_app
//
//  Created by jules bernard on 18.11.25.
//

import SwiftUI
import FirebaseAuth


struct HomeScreen: View {
    @ObservedObject var authVM: AuthenticationVM
    @Binding var appScreen: AppScreen
    @ObservedObject var notesVM: NoteVM
    @State private var showForm = false
    @State private var openNote = false
    @State private var currDoc: String = ""
    
    init(authVM: AuthenticationVM, appScreen: Binding<AppScreen>, notesVM: NoteVM? = nil) {
        self.authVM = authVM
        self._appScreen = appScreen
        self.notesVM = notesVM ?? NoteVM(authVM: authVM)
    }
    
    func logout() {
        Task {
            do {
                try await authVM.logout()
                print("user logged out")
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("Diary")
                        .font(Font.custom("AbhayaLibre-Regular", size: 96))
                        .padding(.top, 105)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                ScrollView {
                    ForEach(notesVM.notes) {note in
                        NoteView(note: note)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                currDoc = note.id!
                                openNote = true
                            }
                            .padding(.vertical, 4)
                    }
                    
                    VStack {
                        VStack {
                            if showForm {
                                FormPopup(authVM: authVM, showForm: $showForm)
                                    .transition(.scale)
                                    .zIndex(1)
                            }
                            else {
                                Text("+ add entry")
                                    .font(Font.custom("AbhayaLibre-Regular", size: 20))
                            }
                        }
                        .padding(12)
                    }
                    .background(Color(red: 245/255, green: 245/255, blue: 245/255))
                    .cornerRadius(22)
                    .onTapGesture {
                        showForm = true
                    }
                    
                }
                .padding(.top, 0)
                
            }
            .padding(24)
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if openNote {
                NoteZoomView(note: notesVM.notes.first(where: { $0.id == currDoc })!, openNote: $openNote)
                    .transition(.scale)
                    .zIndex(1)
            }
        }
        .background(Color(red: 213/255, green: 213/255, blue: 213/255))
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
