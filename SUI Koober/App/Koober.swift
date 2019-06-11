/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import Foundation
import SwiftUI
import Combine

/// `Koober` is a state store that holds the app's current state. SwiftUI will be notified anytime _anything_ changes in `appState`. This means all the views are recomputed by SwiftUI whenevr anything changes. Recomputing views is supposed to be cheap. **I haven't profiled taking this strategy so your milage may vary.**
class Koober: BindableObject {
  
  /// `Publisher` required by `BindableObject` protocol. This publisher gets sent a new `Void` value anytime `appState` changes.
  var didChange = PassthroughSubject<Void, Never>()
  
  /// This is the app's entire state. The SwiftUI view hierarchy is a function of this state.
  var appState = AppState.launching {
    didSet {
      self.didChange.send(())
    }
  }
  
  // MARK: Subsystems
  /// Data store that holds the authenticated user's session. This uses a fake implementation to simulate whether a user is signed when the app launches.
  let userSessionStore: UserSessionStore = FakeUserSessionStore(userAlreadySignedIn: false)
  
  // MARK: Computed properties
  /// Helper computed property used by SwiftUI views.
  var isLaunching: Bool {
    switch appState {
    case .launching:
      return true
    default:
      return false
    }
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
  
  init() {
    launchKoober()
  }
  
  func launchKoober() {
    startLoadUserSessionUseCase()
  }
  
  /// Determines if user is signed in when app launches.
  func startLoadUserSessionUseCase() {
    userSessionStore.getStoredAuthenticatedUserSession() { result in
      switch result {
      case .success(nil):
        self.appState = .running(.unauthenticated)
      case .success(.some):
        self.appState = .running(.authenticated)
      default:
        fatalError()
      }
    }
  }
  
  
  /// Attempts to sign in a usere with credentials.
  /// - Parameter username: User provided userename.
  /// - Parameter password: User provided password.
  func startSignInUseCase(username: String, password: String) {
    let remoteAPI = FakeUserAuthenticationRemoteAPI()
    let useCase = SignInUseCase(username: username,
                                password: password,
                                remoteAPI: remoteAPI,
                                userSessionStore: self.userSessionStore)
    useCase.start { result in
      switch result {
      case .success(_):
        self.appState = .running(.authenticated)
      default:
        fatalError() // **NOTE:** Typically a failure case would need to be handled here. For this prototype, any username/password is accepted.
      }
    }
  }
}

// MARK: - Model

enum AppState {
  case launching
  case running(UserState)
}

/// Represents whether user is signed in or not. In a complete implemnetation, the `authenticated` case would hold a `UserSession` as an associated value.
enum UserState {
  case unauthenticated
  case authenticated
}

/// Placeholder. This type would normally hold the signed in user's information and auth token.
struct UserSession {
  
}
