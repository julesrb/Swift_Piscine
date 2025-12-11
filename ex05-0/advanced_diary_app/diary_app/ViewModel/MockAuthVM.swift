//
//  MockAuthVM.swift
//  diary_app
//
//  Created by jules bernard on 27.11.25.
//


final class MockAuthVM: AuthenticationVM {
    override init() {
        super.init()
        self.user = nil
    }
}
