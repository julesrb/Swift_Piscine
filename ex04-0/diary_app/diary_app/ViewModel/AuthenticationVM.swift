//
//  AuthenticationVM.swift
//  diary_app
//
//  Created by jules bernard on 17.11.25.
//

import SwiftUI
import Combine
import AuthenticationServices
//import GoogleSignInSwift
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
//import SafariServices

@MainActor
class AuthenticationVM: NSObject, ObservableObject {
    
    var webAuthSession: ASWebAuthenticationSession?
    private var oauthProvider: OAuthProvider?
    @Published var user: User? = nil
    private var handle: AuthStateDidChangeListenerHandle?

    override init() {
        super.init()
        addListener()
    }
  
    func addListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.user = user
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func googleOauth() async throws {
        try await logout()
        // google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("no firbase clientID found")
        }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //get rootView
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = scene?.windows.first?.rootViewController
        else {
            fatalError("There is no root view controller!")
        }
        
        //google sign in authentication response
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )
        let usera = result.user
        guard let idToken = usera.idToken?.tokenString else {
            throw AuthenticationError.runtimeError("Unexpected error occurred, please retry")
        }
        
        //Firebase auth
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken, accessToken: usera.accessToken.tokenString
        )
        print(credential)
        Auth.auth().signIn(with: credential) { result, error in
            print("Result = \(result, default: "none")")
        }
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
            print(email ?? "no email")
          let photoURL = user.photoURL
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
          // ...
        }
    }

    func githubOauth() async throws {
        try await logout()
        let provider = OAuthProvider(providerID: "github.com")
        provider.customParameters = [
            "allow_signup": "false"
        ]
        provider.scopes = ["read:user", "user:email"]
        self.oauthProvider = provider
        print("starting githib flow")
        print(OAuthProvider.self)
        
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = scene?.windows.first?.rootViewController
        else {
            fatalError("There is no root view controller!")
        }
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                print("err get credential: \(error!)")
                return
            }
            if credential != nil {
                Auth.auth().signIn(with: credential!) { authResult, error in
                    if error != nil {
                        print("err sing in: \(error!)")
                    }
                    guard let oauthCredential = authResult?.credential else {
                        print("no credentials ?")
                        return
                    }
                    let user = Auth.auth().currentUser
                    print("github auth worked")
                    if let user = user {
                        // The user's ID, unique to the Firebase project.
                        // Do NOT use this value to authenticate with your backend server,
                        // if you have one. Use getTokenWithCompletion:completion: instead.
                        let uid = user.uid
                        let email = user.email
                        print(email ?? "no email")
                        let photoURL = user.photoURL
                        var multiFactorString = "MultiFactor: "
                        for info in user.multiFactor.enrolledFactors {
                            multiFactorString += info.displayName ?? "[DispayName]"
                            multiFactorString += " "
                        }
                    }
                }
            }
        }
    }
 
    
    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
    

}
