//
//  NoteVM.swift
//  diary_app
//
//  Created by jules bernard on 20.11.25.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

@MainActor
class NoteVM: ObservableObject {
    @Published var notes: [Notes] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(authVM: AuthenticationVM) {
            authVM.$user
                .compactMap { $0?.uid }
                .sink { [weak self] uid in
                    self?.loadNotes(for: uid)
                }
                .store(in: &cancellables)
        }
    
    func loadNotes(for uid: String) {
        print("start listen for uid : \(uid)")
        Firestore.firestore()
            .collection("notes")
            .whereField("uuid", isEqualTo: uid)
            .addSnapshotListener { snapshot, error in
                self.notes = snapshot?.documents.compactMap { try? $0.data(as: Notes.self) } ?? []
            }
    }
}
