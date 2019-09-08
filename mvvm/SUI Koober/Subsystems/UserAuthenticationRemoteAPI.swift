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

// MARK: - API

/// Network API for authenticating users.
protocol UserAuthenticationRemoteAPI {
  /// Attempts to remotetly authenticate a user.
  /// - Parameter username: User provided username.
  /// - Parameter password: User provided password.
  /// **Note:** Normally the future's failure type would not be `Never`. In this prototype, a user's username/password is not validated, any username-password pair successfully signs in the user.
  func signIn(username: String, password: String) -> Future<UserSession, SignInError>
}

// MARK: - Implementation

protocol UserAuthenticationRemoteAPIError: Error, ErrorMessageConvertible {}

enum SignInError: UserAuthenticationRemoteAPIError {
  case unauthorized
  case unknown
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
    case .unknown:
      return "Unknown error occured. Please try again."
    }
  }
}

class FakeUserAuthenticationRemoteAPI: UserAuthenticationRemoteAPI {
  func signIn(username: String, password: String) -> Future<UserSession, SignInError> {
    let future = Future<UserSession, SignInError> { promise in
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
