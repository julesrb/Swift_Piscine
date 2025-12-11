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
    @State private var openNote = false
    @State private var currDoc: String = ""
    @State private var page = 0
    
    init(authVM: AuthenticationVM, appScreen: Binding<AppScreen>, notesVM: NoteVM? = nil) {
        self.authVM = authVM
        self._appScreen = appScreen
        self.notesVM = notesVM ?? NoteVM(authVM: authVM)
    }
    
    var body: some View {
        ZStack {
            VStack{
                ScrollView {
                    if page == 0 {
                        ProfileView(notesVM: notesVM, authVM: authVM, openNote: $openNote, currDoc: $currDoc, appScreen: $appScreen)
                    }
                    else {
                        CalendarView(notesVM: notesVM, authVM: authVM, openNote: $openNote, currDoc: $currDoc)
                            .padding()
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: page == 0 ? "person.fill" : "person")
                        .font(.title)
                        .onTapGesture {
                            page = 0
                        }
                    Spacer()
                    Image(systemName: page == 1 ? "calendar.circle.fill" : "calendar.circle")
                        .font(.title)
                        .onTapGesture {
                            page = 1
                        }
                    Spacer()
                }
                .padding(.bottom, 24)
            }
            .ignoresSafeArea()
            
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
