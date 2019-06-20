/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import Foundation
import Combine

/// Use case for signing in users. Attempts to remotely authenticate user and stores the user's session.
class SignInUseCase {
  let username: String
  let password: String
  
  let remoteAPI: UserAuthenticationRemoteAPI
  let userSessionStore: UserSessionStore
  
  init(username: String,
       password: String,
       remoteAPI: UserAuthenticationRemoteAPI,
       userSessionStore: UserSessionStore) {
    self.username = username
    self.password = password
    self.remoteAPI = remoteAPI
    self.userSessionStore = userSessionStore
  }
  
  func start() -> AnyPublisher<UserSession, Never> {
    let future = signIn()
    return future // These two lines can be collapsed into one. Leaving as two lines for clarity.
  }
  
  func signIn() -> AnyPublisher<UserSession, Never> {
    let future =
      remoteAPI.signIn(username: username, password: password)
        .flatMap(self.store(authenticatedUserSession:))
        .eraseToAnyPublisher()
    return future
  }
  
  func store(authenticatedUserSession: UserSession) -> Publishers.Future<UserSession, Never> {
    let future = userSessionStore.store(authenticatedUserSession)
    return future
  }
}
