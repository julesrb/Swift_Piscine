//
//  ProfileView.swift
//  diary_app
//
//  Created by jules bernard on 28.11.25.
//


import SwiftUI
import FirebaseAuth

struct ProfileView : View {
    @ObservedObject var notesVM: NoteVM
    @ObservedObject var authVM: AuthenticationVM
    @Binding var openNote: Bool
    @Binding var currDoc: String
    @Binding var appScreen: AppScreen
    @State private var showForm = false
    
    func logout() {
        authVM.logout()
    }
    
    private func emojiCounts() -> [(emoji: String, count: Int)] {
        let emojis = ["😢", "😐", "😊", "😃", "🤩"]
        var dict: [String: Int] = [:]
        for e in emojis { dict[e] = 0 }
        for note in notesVM.notes {
            dict[note.icon, default: 0] += 1
        }
        return emojis.map { ($0, dict[$0] ?? 0) }
    }
    
    var body: some View {
        VStack {
            if let url = authVM.user?.photoURL?.absoluteString {
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()
                } placeholder: {
                    Image("default")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()  // ensures image doesn't overflow
                }
            } else {
                Image("default")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipped()  // ensures image doesn't overflow
            }
            
            VStack (alignment: .leading) {
                Text(authVM.user?.displayName ?? "Virginia Wolf")
                    .font(Font.custom("AbhayaLibre-Bold", size: 48))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Text("Last entries")
                    .font(Font.custom("AbhayaLibre-Regular", size: 24))
                    .padding(.top, 20)
                VStack {
                    ForEach(notesVM.notes.prefix(2)) {note in
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
                
                Text("Feeling stats for my \(notesVM.notes.count) entries")
                    .font(Font.custom("AbhayaLibre-Regular", size: 24))
                    .padding(.top, 20)
                VStack {
                    HStack {
                        ForEach(emojiCounts(), id: \.emoji) { item in
                            VStack {
                                Text(item.emoji)
                                    .font(.largeTitle)
                                Text("\(item.count != 0 ? item.count*100/notesVM.notes.count : 0) %")
                                    .font(Font.custom("AbhayaLibre-Regular", size: 20))
                                    .padding(.leading, 2)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .background(Color(red: 245/255, green: 245/255, blue: 245/255))
                .cornerRadius(22)
                
                Spacer()
                
                Button("Sign out") {
                    logout()
                    appScreen = AppScreen.login
                }
                .font(Font.custom("AbhayaLibre-Regular", size: 24))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
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
