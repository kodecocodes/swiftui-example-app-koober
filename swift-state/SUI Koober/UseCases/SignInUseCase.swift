/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
  
  func start() -> AnyPublisher<UserSession, ErrorMessage> {
    let future = signIn()
                  .flatMap(store(authenticatedUserSession:))
                  .eraseToAnyPublisher()
    return future
  }
  
  func signIn() -> AnyPublisher<UserSession, ErrorMessage> {
    let future =
      remoteAPI.signIn(username: username, password: password)
        .mapError { signInError in
          signInError.errorMessage
        }
        .eraseToAnyPublisher()
    return future
  }
  
  func store(authenticatedUserSession: UserSession) -> AnyPublisher<UserSession, ErrorMessage> {
    let future =
      userSessionStore.store(authenticatedUserSession)
        .mapError { storeAuthenticatedUserSessionError in
          storeAuthenticatedUserSessionError.errorMessage
        }
      .eraseToAnyPublisher()
    return future
  }
}
