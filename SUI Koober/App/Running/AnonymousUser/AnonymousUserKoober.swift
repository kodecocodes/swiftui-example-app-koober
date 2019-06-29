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

class AnonymousUserKoober: Equatable {
  let kooberStateStore: KooberStateStore
  let environment: AnonymousUserEnvironment
  
  init(kooberStateStore: KooberStateStore, environment: AnonymousUserEnvironment) {
    self.kooberStateStore = kooberStateStore
    self.environment = environment
  }
  
  /// Attempts to sign in a usere with credentials.
  /// - Parameter email: User provided email.
  /// - Parameter password: User provided password.
  func startSignInUseCase(email: String, password: String) -> AnyPublisher<UserSession, ErrorMessage> {
    let useCase = environment.makeSignInUseCase(username: email, password: password)
    let publisher = useCase.start()
    return publisher
  }
  
  func on(authenticatedUserSession userSession: UserSession) {
    kooberStateStore.on(authenticatedUserSession: userSession)
  }
  
  static func == (lhs: AnonymousUserKoober, rhs: AnonymousUserKoober) -> Bool {
    lhs === rhs
  }
}

protocol AnonymousUserEnvironment {
  func makeSignInUseCase(username: String, password: String) -> SignInUseCase
}
