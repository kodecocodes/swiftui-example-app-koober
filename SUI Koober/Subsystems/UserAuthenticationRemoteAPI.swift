/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import Foundation
import Combine

// MARK: - API

/// Network API for authenticating users.
protocol UserAuthenticationRemoteAPI {
  /// Attempts to remotetly authenticate a user.
  /// - Parameter username: User provided username.
  /// - Parameter password: User provided password.
  /// **Note:** Normally the future's failure type would not be `Never`. In this prototype, a user's username/password is not validated, any username-password pair successfully signs in the user.
  func signIn(username: String, password: String) -> Publishers.Future<UserSession, SignInError>
}

// MARK: - Implementation

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

class FakeUserAuthenticationRemoteAPI: UserAuthenticationRemoteAPI {
  func signIn(username: String, password: String) -> Publishers.Future<UserSession, SignInError> {
    let future = Publishers.Future<UserSession, SignInError> { promise in
      self.fakeSignIn(promise: promise)
    }
    return future
  }
  
  func fakeSignIn(promise: @escaping (Result<UserSession, SignInError>) -> Void) {
    DispatchQueue.global().async {
      sleep(1)
      DispatchQueue.main.async {
        promise(.success(UserSession.fake))
      }
    }
  }
}
