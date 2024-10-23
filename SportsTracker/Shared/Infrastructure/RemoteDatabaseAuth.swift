import Foundation
import FirebaseCore
import FirebaseAuth

final class RemoteDatabaseAuth {
    enum RemoteDatabaseAuthError: Error {
        case ErrorSignIn
    }
    
    static let shared = RemoteDatabaseAuth()
    
    private init() {}
    
    func signInAnonymously() async throws {
        do {
            try await Auth.auth().signInAnonymously()
        } catch {
            throw RemoteDatabaseAuthError.ErrorSignIn
        }
    }
    
    func isSignedIn() -> Bool {
        Auth.auth().currentUser != nil
    }
}
