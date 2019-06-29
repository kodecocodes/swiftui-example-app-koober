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

// MARK: - Model

enum AppState: Equatable {
  case launching
  case running(UserState)
}

/// Represents whether user is signed in or not. In a complete implemnetation, the `authenticated` case would hold a `UserSession` as an associated value.
enum UserState: Equatable {
  case unauthenticated(AnonymousUserKoober)
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
