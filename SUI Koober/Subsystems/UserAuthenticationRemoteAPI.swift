/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import Foundation

// MARK: - API

/// Network API for authenticating users.
protocol UserAuthenticationRemoteAPI {
  /// Attempts to remotetly authenticate a user.
  /// - Parameter username: User provided username.
  /// - Parameter password: User provided password.
  /// - Parameter onComplete: Completion closure. **Note:** Normally the `Result` failure type would not be `Never`. In this prototype, a user's username/password is not validated, any username-password pair successfully signs in the user.
  func signIn(username: String,
              password: String,
              onComplete: @escaping (Result<UserSession, SignInError>) -> Void)
}

/// Marker protocol.
protocol UserAuthenticationRemoteAPIError: Error, ErrorMessageConvertible {}

enum SignInError: UserAuthenticationRemoteAPIError {
  case unauthorized
  case uknown
}

/// Maps errors to error messages.
extension SignInError {
  var errorMessage: ErrorMessage {
    ErrorMessage(message: self.message)
  }
  
  var message: String {
    switch self {
    case .unauthorized:
      return "Sign in failed. Please try again"
    case .uknown:
      return "Uknown error occured. Please try again."
    }
  }
}

// MARK: - Implementation

class FakeUserAuthenticationRemoteAPI: UserAuthenticationRemoteAPI {
  
  /// Signs in user if username and password match, otherwise returns unauthorized error result.
  func signIn(username: String,
              password: String,
              onComplete: @escaping (Result<UserSession, SignInError>) -> Void) {
    DispatchQueue.global().async {
      sleep(1)
      DispatchQueue.main.async {
        if username == password {
          onComplete(.success(UserSession(user: User(displayName: username), remoteSession: RemoteUserSession.fake)))
        } else {
          onComplete(.failure(.unauthorized))
        }
      }
    }
  }
}
