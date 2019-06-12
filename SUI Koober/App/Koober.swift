/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import Foundation
import SwiftUI
import Combine

/// `Koober` is a state store that holds the app's current state. SwiftUI will be notified anytime _anything_ changes in `appState`. This means all the views are recomputed by SwiftUI whenevr anything changes. Recomputing views is supposed to be cheap. **I haven't profiled taking this strategy so your milage may vary.**
final class Koober: BindableObject {
  
  /// `Publisher` required by `BindableObject` protocol. This publisher gets sent a new `Void` value anytime `appState` changes.
  private(set) var didChange = PassthroughSubject<Void, Never>()
  
  /// This is the app's entire state. The SwiftUI view hierarchy is a function of this state.
  private var appState = AppState.launching {
    didSet {
      didChange.send(())
    }
  }
  
  // MARK: Dependencies
  let kooberDependencyContainer = KooberDependencyContainer()
  
  // MARK: Computed properties
  /// Helper computed property used by SwiftUI views.
  var isLaunching: Bool {
    return appState == .launching
  }
  
  /// Helper computed property used by SwiftUI views.
  var userIsAuthenticated: Bool {
    switch appState {
    case .running(.authenticated(_)):
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
    userSessionStore.getStoredAuthenticatedUserSession() { result in
      switch result {
      case .success(nil):
        self.appState = .running(.unauthenticated)
      case .success(.some(let userSession)):
        self.appState = .running(.authenticated(userSession))
      default:
        fatalError()
      }
    }
  }
  
  /// Attempts to sign in a usere with credentials.
  /// - Parameter username: User provided userename.
  /// - Parameter password: User provided password.
  func startSignInUseCase(username: String, password: String) {
    let useCase = kooberDependencyContainer
      .makeSignInUseCase(username: username, password: password)
    useCase.start { result in
      switch result {
      case .success(let userSession):
        self.appState = .running(.authenticated(userSession))
      default:
        fatalError() // **NOTE:** Typically a failure case would need to be handled here. For this prototype, any username/password is accepted.
      }
    }
  }
}

// MARK: - Model

enum AppState: Equatable {
  case launching
  case running(UserState)
}

/// Represents whether user is signed in or not. In a complete implemnetation, the `authenticated` case would hold a `UserSession` as an associated value.
enum UserState: Equatable {
  case unauthenticated
  case authenticated(UserSession)
}

/// Placeholder. This type would normally hold the signed in user's information and auth token.
struct UserSession: Equatable {
  let user: User
  let remoteSession: RemoteUserSession
}

/// User's profile information.
struct User: Equatable {
  let displayName: String
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
    User(displayName: "Fake User")
  }
}

extension RemoteUserSession {
  static var fake: RemoteUserSession {
    RemoteUserSession(authToken: "fake-auth-token")
  }
}
