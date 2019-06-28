/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import Foundation
import Combine

// MARK: - API

/// Data store for storing the authenticated user's session.
protocol UserSessionStore {
  func getStoredAuthenticatedUserSession() -> Publishers.Future<UserSession?, GetStoredAuthenticatedUserSessionError>
  func store(_ authenticatedUserSession: UserSession) -> Publishers.Future<UserSession, StoreAuthenticatedUserSessionError>
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
  
  func getStoredAuthenticatedUserSession() -> Publishers.Future<UserSession?, GetStoredAuthenticatedUserSessionError> {
    let future = Publishers.Future<UserSession?, GetStoredAuthenticatedUserSessionError> { promise in
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
  
  func store(_ authenticatedUserSession: UserSession) -> Publishers.Future<UserSession, StoreAuthenticatedUserSessionError> {
    let future = Publishers.Future<UserSession, StoreAuthenticatedUserSessionError> { promise in
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
