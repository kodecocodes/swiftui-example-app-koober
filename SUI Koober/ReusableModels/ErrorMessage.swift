/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 19, 2019.

import Foundation

struct ErrorMessage: Error {
  let id = UUID()
  var message: String
}

protocol ErrorMessageConvertible {
  var errorMessage: ErrorMessage { get }
}

extension ErrorMessageConvertible {
  var errorMessage: ErrorMessage {
    ErrorMessage(message: "Uknown error. Please try again.")
  }
}
