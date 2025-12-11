//
//  CalendarView.swift
//  diary_app
//
//  Created by jules bernard on 28.11.25.
//

import SwiftUI
import FirebaseAuth


struct CalendarView : View {
    @ObservedObject var notesVM: NoteVM
    @ObservedObject var authVM: AuthenticationVM
    @Binding var openNote: Bool
    @Binding var currDoc: String
    @State private var showForm = false
    @State private var date = Date()
    
    func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        Calendar.current.isDate(d1, inSameDayAs: d2)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            DatePicker(
                "Start Date",
                selection: $date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .background(Color(red: 245/255, green: 245/255, blue: 245/255))
            .cornerRadius(22)
            .padding(.top, 70)
            Text("Entries from the day")
                .font(Font.custom("AbhayaLibre-Regular", size: 24))
                .frame(maxWidth: .infinity ,alignment: .leading)
                .padding(.top, 10)
            VStack {
                ForEach(notesVM.notes.filter { isSameDay($0.date, date) }) {note in
                    NoteView(note: note)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            currDoc = note.id!
                            openNote = true
                        }
                    Divider()
                        .background(Color.black)
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
                    .padding(8)
                }
                .background(Color(red: 245/255, green: 245/255, blue: 245/255))
                .cornerRadius(22)
                .onTapGesture {
                    showForm = true
                }
                .padding(.top, 0)
            }
            .background(Color(red: 245/255, green: 245/255, blue: 245/255))
            .cornerRadius(22)
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
