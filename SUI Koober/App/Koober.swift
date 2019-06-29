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

final class Koober {
  let stateStore: KooberStateStore
  let appLauncher: AppLauncher
  
  init() {
    let stateStore = KooberStateStore()
    let work = KooberWork(stateStore: stateStore)
    self.stateStore = stateStore
    self.appLauncher = work
  }

  init(stateStore: KooberStateStore, appLauncher: AppLauncher) {
    self.stateStore = stateStore
    self.appLauncher = appLauncher
    
    appLauncher.launchKoober()
  }
  
  func on(authenticatedUserSession userSession: UserSession) {
    stateStore.on(authenticatedUserSession: userSession)
  }
}

/// `KooberStateStore` is a state store that holds the app's current state. SwiftUI will be notified anytime _anything_ changes in `appState`. This means all the views are recomputed by SwiftUI whenevr anything changes. Recomputing views is supposed to be cheap. **I haven't profiled taking this strategy so your milage may vary.**
final class KooberStateStore: BindableObject {
  /// `Publisher` required by `BindableObject` protocol. This publisher gets sent a new `Void` value anytime `appState` changes.
  private(set) var didChange = PassthroughSubject<Void, Never>()
  
  /// This is the app's entire state. The SwiftUI view hierarchy is a function of this state.
  var appState = AppState.launching {
    didSet {
      didChange.send(())
    }
  }
  
  func on(authenticatedUserSession userSession: UserSession) {
    self.appState = .running(.authenticated(userSession))
  }
}

protocol AppLauncher {
  func launchKoober()
}

final class KooberWork: AppLauncher {
  let stateStore: KooberStateStore
  let dependencyContainer = KooberDependencyContainer()
  
  init(stateStore: KooberStateStore) {
    self.stateStore = stateStore
  }
  
  func launchKoober() {
    startLoadUserSessionUseCase()
  }
  
  /// Determines if user is signed in when app launches.
  func startLoadUserSessionUseCase() {
    let userSessionStore = dependencyContainer.userSessionStore
    let _ = userSessionStore.getStoredAuthenticatedUserSession()
      .sink { userSession in
        if let userSession = userSession {
          self.stateStore.appState = .running(.authenticated(userSession))
        } else {
          self.stateStore.appState = .running(.unauthenticated(self.makeAnonymousUserKoober()))
        }
    }
  }
  
  func makeAnonymousUserKoober() -> AnonymousUserKoober {
    let dependencyContainer = AnonymousUserDependencyContainer(userSessionStore: self.dependencyContainer.userSessionStore)
    return AnonymousUserKoober(kooberStateStore: self.stateStore, environment: dependencyContainer)
  }
}
