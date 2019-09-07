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
import SwiftUI
import Combine

/// `Koober` is a state store that holds the app's current state. SwiftUI will be notified anytime _anything_ changes in `appState`. This means all the views are recomputed by SwiftUI whenevr anything changes. Recomputing views is supposed to be cheap. **I haven't profiled taking this strategy so your milage may vary.**
final class Koober: ObservableObject {
  /// This is the app's entire state. The SwiftUI view hierarchy is a function of this state.
  @Published private(set) var appState = AppState.launching(.starting)
  
  // MARK: Dependencies
  let kooberDependencyContainer = KooberDependencyContainer()
  
  // MARK: Computed properties
  /// Helper computed property used by SwiftUI views.
  var isLaunching: Bool {
    return appState == .launching(.starting)
  }
  
  /// Helper computed property used by SwiftUI views.
  var userIsAuthenticated: Bool {
    switch appState {
    case .running(.authenticated):
      return true
    default:
      return false
    }
  }
  
  /// Helper computed property for accessing user.
  /// TODO: Undo this hack once authenticated dependency container is in place.
  var authenticatedUser: User? {
    switch appState {
    case .running(.authenticated(let userSession)):
      return userSession.user
    default:
      return nil
    }
  }
  
  init() {
    launchKoober()
  }
  
  func launchKoober() {
    startLoadUserSessionUseCase()
  }
  
  /// Determines if user is signed in when app launches.
  func startLoadUserSessionUseCase() {
    let userSessionStore = kooberDependencyContainer.userSessionStore
    let anyCancellable = userSessionStore.getStoredAuthenticatedUserSession()
                          .sink(receiveCompletion: { completion in }) { userSession in
                              if let userSession = userSession {
                                self.appState = .running(.authenticated(userSession))
                              } else {
                                self.appState = .running(.unauthenticated(.idle))
                              }
                           }
    appState = .launching(.loadingUserSession(anyCancellable))
  }
  
  /// Attempts to sign in a usere with credentials.
  /// - Parameter username: User provided userename.
  /// - Parameter password: User provided password.
  func startSignInUseCase(username: String, password: String) {
    let useCase = kooberDependencyContainer
      .makeSignInUseCase(username: username, password: password)
    let anyCancellable = useCase.start().sink(receiveCompletion: { completion in}) { userSession in
      self.appState = .running(.authenticated(userSession))
    }
    appState = .running(.unauthenticated(.signingIn(anyCancellable)))
  }
}

// MARK: - Model

enum AppState: Equatable {
  case launching(LaunchState)
  case running(UserState)
}

enum LaunchState: Equatable {
  case starting
  case loadingUserSession(AnyCancellable)
}

/// Represents whether user is signed in or not. In a complete implemnetation, the `authenticated` case would hold a `UserSession` as an associated value.
enum UserState: Equatable {
  case unauthenticated(UnauthenticatedState)
  case authenticated(UserSession)
}

enum UnauthenticatedState: Equatable {
  case idle
  case signingIn(AnyCancellable)
  case signingUp(AnyCancellable)
}

/// Placeholder. This type would normally hold the signed in user's information and auth token.
struct UserSession: Equatable {
  let user: User
  let remoteSession: RemoteUserSession
}

/// User's profile information.
struct User: Equatable {
  let displayName: String
  let fullName: String
  let email: String
  let phone: String
}

/// User's cloud session.
struct RemoteUserSession: Equatable {
  let authToken: String
}

// MARK: Fakes

extension UserSession {
  static var fake: UserSession {
    UserSession(user: User.fake, remoteSession: RemoteUserSession.fake)
  }
}

extension User {
  static var fake: User {
    User(
      displayName: "Johnny",
      fullName: "Johnny Appleseed",
      email: "johnny@gmail.com",
      phone: "510-736-8754"
    )
  }
}

extension RemoteUserSession {
  static var fake: RemoteUserSession {
    RemoteUserSession(authToken: "fake-auth-token")
  }
}
