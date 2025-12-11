//
//  Notes.swift
//  diary_app
//
//  Created by jules bernard on 18.11.25.
//

import FirebaseFirestore


struct Notes: Codable, Identifiable {
    @DocumentID var id: String?
    var date: Date
    var icon: String
    var text: String
    var title: String
    var usermail: String
    var uuid: String
}
