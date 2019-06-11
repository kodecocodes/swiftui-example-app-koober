/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import Foundation

/// Data store for storing the authenticated user's session.
protocol UserSessionStore {
  func getStoredAuthenticatedUserSession(onComplete: @escaping (Result<UserSession?, Never>) -> Void)
  func store(authenticatedUserSession: UserSession,
             onComplete: @escaping (Result<UserSession, Never>) -> Void)
}

/// Fake implementation that's used to simulate whether a user is signed in during launch.
class FakeUserSessionStore: UserSessionStore {
  let userAlreadySignedIn: Bool
  
  init(userAlreadySignedIn: Bool) {
    self.userAlreadySignedIn = userAlreadySignedIn
  }
  
  func getStoredAuthenticatedUserSession(onComplete: @escaping (Result<UserSession?, Never>) -> Void) {
    DispatchQueue.global().async {
      sleep(2)
      DispatchQueue.main.async {
        let result: Result<UserSession?, Never> =
          self.userAlreadySignedIn ? .success(UserSession()) : .success(nil)
        onComplete(result)
      }
    }
  }
  
  func store(authenticatedUserSession: UserSession, onComplete: @escaping (Result<UserSession, Never>) -> Void) {
    DispatchQueue.global().async {
      sleep(1) // Simulate save to keycain...
      DispatchQueue.main.async {
        onComplete(.success(authenticatedUserSession))
      }
    }
  }
}
