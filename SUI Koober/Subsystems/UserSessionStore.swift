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

/// Data store for storing the authenticated user's session.
protocol UserSessionStore {
  func getStoredAuthenticatedUserSession() -> Future<UserSession?, GetStoredAuthenticatedUserSessionError>
  func store(_ authenticatedUserSession: UserSession) -> Future<UserSession, StoreAuthenticatedUserSessionError>
}

protocol UserSessionStoreError: Error, ErrorMessageConvertible {}

enum GetStoredAuthenticatedUserSessionError: UserSessionStoreError {
  case unknown
}

enum StoreAuthenticatedUserSessionError: UserSessionStoreError {
  case unknown
}

// MARK: - Implementation

/// Fake implementation that's used to simulate whether a user is signed in during launch.
class FakeUserSessionStore: UserSessionStore {
  let userAlreadySignedIn: Bool
  
  init(userAlreadySignedIn: Bool) {
    self.userAlreadySignedIn = userAlreadySignedIn
  }
  
  func getStoredAuthenticatedUserSession() -> Future<UserSession?, GetStoredAuthenticatedUserSessionError> {
    let future = Future<UserSession?, GetStoredAuthenticatedUserSessionError> { promise in
      self.getStoredAuthenticatedUserSession(simulatedIOTime: 2, promise: promise)
    }
    return future
  }
  
  private func getStoredAuthenticatedUserSession(simulatedIOTime: UInt32,
                                                 promise: @escaping (Result<UserSession?, GetStoredAuthenticatedUserSessionError>) -> Void) {
    DispatchQueue.global().async {
      sleep(simulatedIOTime)
      DispatchQueue.main.async {
        self.fulfill(promise)
      }
    }
  }
  
  private func fulfill(_ promise: @escaping (Result<UserSession?, GetStoredAuthenticatedUserSessionError>) -> Void) {
    let result: Result<UserSession?, GetStoredAuthenticatedUserSessionError> =
      self.userAlreadySignedIn ? .success(UserSession.fake) : .success(nil)
    promise(result)
  }
  
  func store(_ authenticatedUserSession: UserSession) -> Future<UserSession, StoreAuthenticatedUserSessionError> {
    let future = Future<UserSession, StoreAuthenticatedUserSessionError> { promise in
      self.store(authenticatedUserSession, simulatedIOTime: 2, promise: promise)
    }
    return future
  }
  
  private func store(_ authenticatedUserSession: UserSession,
                     simulatedIOTime: UInt32,
                     promise: @escaping (Result<UserSession, StoreAuthenticatedUserSessionError>) -> Void) {
    DispatchQueue.global().async {
      sleep(simulatedIOTime)
      DispatchQueue.main.async {
        self.fulfillStoreAuthenticatedUser(promise, authenticatedUserSession: authenticatedUserSession)
      }
    }
  }
  
  private func fulfillStoreAuthenticatedUser(_ promise: @escaping (Result<UserSession, StoreAuthenticatedUserSessionError>) -> Void,
                                             authenticatedUserSession: UserSession) {
    promise(.success(authenticatedUserSession))
  }
}
