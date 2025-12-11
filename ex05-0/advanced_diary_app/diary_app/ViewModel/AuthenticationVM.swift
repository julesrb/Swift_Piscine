//
//  AuthenticationVM.swift
//  diary_app
//
//  Created by jules bernard on 17.11.25.
//

import SwiftUI
import Combine
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth
import FirebaseCore


struct GithubEmail: Codable {
    let email: String
    let primary: Bool
    let verified: Bool
}

@MainActor
class AuthenticationVM: NSObject, ObservableObject {
    
    var webAuthSession: ASWebAuthenticationSession?
    private var oauthProvider: OAuthProvider?
    @Published var user: User? = nil
    @Published var userEmail: String = ""
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
        self.logout()
        // google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthenticationError.runtimeError("no firbase clientID found")
        }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //get rootView
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = scene?.windows.first?.rootViewController
        else {
            throw AuthenticationError.runtimeError("no root view controller")
        }
        
        //google sign in authentication response
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let usera = result.user
        guard let idToken = usera.idToken?.tokenString else {
            throw AuthenticationError.runtimeError("Unexpected error occurred, please retry")
        }
        
        //Firebase auth
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken, accessToken: usera.accessToken.tokenString
        )
        let accessToken: String = try await withCheckedThrowingContinuation { continuation in
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: AuthenticationError.runtimeError("Firebase sign in failed: \(error)"))
                    return
                }
                guard let oauthCred = authResult?.credential as? OAuthCredential else {
                    continuation.resume(throwing: AuthenticationError.runtimeError("Firebase sign in failed"))
                    return
                }
                self.user = Auth.auth().currentUser
                guard let email = self.user!.email else {
                    continuation.resume(throwing: AuthenticationError.runtimeError("No email found"))
                    return
                }
                self.userEmail = email
                print("email : \(self.userEmail)")
                if let acessToken = oauthCred.accessToken {
                    continuation.resume(returning: acessToken)
                }
            }
        }
        print("uid : \(user!.uid)")
    }

    func githubOauth() async throws {
        self.logout()
        let provider = OAuthProvider(providerID: "github.com")
        provider.customParameters = ["allow_signup": "false", "login": "" ]
        provider.scopes = ["read:user", "user:email"]
        self.oauthProvider = provider
        
        // GET GITHUB CREDENTIALS
        let credential: AuthCredential = try await withCheckedThrowingContinuation { continuation in
            
            provider.getCredentialWith(nil) { credential, error in
                if let error = error {
                    continuation.resume(throwing: AuthenticationError.runtimeError("No credential returned by GitHub: \(error)"))
                    return
                }
                if let credential = credential {
                    continuation.resume(returning: credential)
                    return
                }
            }
        }
        
        // SIGN IN TO FIREBASE
        let accessToken: String = try await withCheckedThrowingContinuation { continuation in
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: AuthenticationError.runtimeError("Firebase sign in failed: \(error)"))
                    return
                }
                guard let oauthCred = authResult?.credential as? OAuthCredential else {
                    continuation.resume(throwing: AuthenticationError.runtimeError("Firebase sign in failed"))
                    return
                }
                self.user = Auth.auth().currentUser
                if let acessToken = oauthCred.accessToken {
                    continuation.resume(returning: acessToken)
                }
            }
        }
        print("github user present")
        
        // Get Email from Github
        let url = URL(string: "https://api.github.com/user/emails")!
        var request = URLRequest(url: url)
        request.setValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        let emails = try JSONDecoder().decode([GithubEmail].self, from: data)
        guard let email = emails.first(where: { $0.primary })?.email else {
            throw AuthenticationError.runtimeError("No email found")
        }
        self.userEmail = email
        print("email : \(self.userEmail)")
        print("uid : \(user!.uid)")
    }
 
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
