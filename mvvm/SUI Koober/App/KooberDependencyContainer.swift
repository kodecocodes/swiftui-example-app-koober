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

/// Root dependency container for Koober which holds objects who live throught the lifetime of Koober's process, i.e. singletons.
final class KooberDependencyContainer {
  // MARK: Subsystems
  /// Data store that holds the authenticated user's session. This uses a fake implementation to simulate whether a user is signed when the app launches.
  let userSessionStore: UserSessionStore = FakeUserSessionStore(userAlreadySignedIn: false)
  
  // MARK: Factories
  /// Factory method for creating a new sign in use case to sign users into Koober.
  func makeSignInUseCase(username: String, password: String) -> SignInUseCase {
    // Gather dependencies.
    let remoteAPI = makeUserAuthenticationRemoteAPI()
    let userSessionStore = self.userSessionStore
    // Make use case.
    return SignInUseCase(username: username,
                         password: password,
                         remoteAPI: remoteAPI,
                         userSessionStore: userSessionStore)
  }
  
  /// Makes a new user authentication remote API for authenticating users using the cloud.
  func makeUserAuthenticationRemoteAPI() -> UserAuthenticationRemoteAPI {
    return FakeUserAuthenticationRemoteAPI()
  }
}
