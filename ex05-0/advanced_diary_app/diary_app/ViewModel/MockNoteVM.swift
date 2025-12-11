//
//  MockNoteVM.swift
//  diary_app
//
//  Created by jules bernard on 27.11.25.
//

import Foundation


final class MockNoteVM: NoteVM {
    override init(authVM: AuthenticationVM) {
        super.init(authVM: authVM)

        self.notes = [
            Notes(
                id: "1",
                date: Date(),
                icon: "😃",
                text: "This is a preview note so you can see the layout.",
                title: "My First Mock Note",
                usermail: "preview@example.com",
                uuid: "tgertfwthretger"
            ),
            Notes(
                id: "2",
                date: Date(),
                icon: "😐",
                text: "Another mock note, showing what multiple notes look like. Thank you for your application at UP42 for the position of Junior Frontend Engineer. We received your application from our colleague and we are in the process of reviewing it. Your privacy and communication preferences are a top priority for us at UP42. As part of the EU legislation changes, we wanted to get in touch with you to make sure that you are able to make changes to your personal data. By clicking the following link you give us voluntarily your consent to store your data (name, CV, application",
                title: "Another Entry but this time with an extra long title to see hwo my layout break with it",
                usermail: "preview@example.com",
                uuid: "ertgertggertgwrt"
            ),
            Notes(
                id: "2",
                date: Date(),
                icon: "😃",
                text: "Another mock note, showing what multiple notes look like.",
                title: "Another Entry",
                usermail: "preview@example.com",
                uuid: "ertgertertgwrt"
            ),
            Notes(
                id: "2",
                date: Date(),
                icon: "😐",
                text: "Another mock note, showing what multiple notes look like.",
                title: "Another Entry",
                usermail: "preview@example.com",
                uuid: "ertgeretgwrt"
            ),
            Notes(
                id: "2",
                date: Date(),
                icon: "😃",
                text: "Another mock note, showing what multiple notes look like.",
                title: "Another Entry",
                usermail: "preview@example.com",
                uuid: "ertgertgwrt"
            ),
            Notes(
                id: "2",
                date: Date(),
                icon: "😐",
                text: "Another mock note, showing what multiple notes look like.",
                title: "Another Entry",
                usermail: "preview@example.com",
                uuid: "etrghwrtgef35"
            )
        ]
        
    }
}
