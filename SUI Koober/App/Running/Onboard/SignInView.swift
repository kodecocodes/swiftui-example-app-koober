/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

struct SignInView : View {
  /// There seems to be three different kinds of state that can affect a view:
  /// 1. **Pure UI state:** Constant view property or `@state` that is exlusively mutated by UI events.
  /// 2. **Local side effect state**: `@State` that is updated as a result of a side effect. For example, error messaging state that is local to the view but that is mutated after a network request fails. The state is local to SwiftUI but mutated as a result of something external.
  /// 3. **Global state:** State being held and manipulated outside the view as a `@BindableObject`.
  
  let startSignInUseCase: (String,
                           String,
                           @escaping (ErrorMessage) -> Void) -> Void
  
  @State private var username = ""
  @State private var password = ""
  
  @State private var signingIn = false
  
  @State private var errorMessage: ErrorMessage? = nil
  @State private var displayErrorMessage = false
  
  var body: some View {
    
    VStack {
      HStack {
        Text("Username")
          .color(.white)
          .frame(width: 80)
          .padding()
        
        TextField($username)
          .padding()
          .background(Color(hue: 1, saturation: 1, brightness: 1, opacity: 0.1))
      }
      
      HStack {
        Text("Password")
          .color(.white)
          .frame(width: 80)
          .padding()
        SecureField($password)
          .padding()
          .background(Color(hue: 1, saturation: 1, brightness: 1, opacity: 0.1))
        
      }
      
      Button(action: signIn) {
        Text("Sign In")
        }
        .accentColor(.white)
        .padding()
      Spacer()
    }
    .padding()
    .background(Color("BackgroundColor"))
    .opacity(signingIn ? 0.6 : 1.0)
    .disabled(signingIn)
    .presentation($displayErrorMessage) {
      Alert(title: Text(errorMessage!.message), dismissButton: .default(Text("OK")) {
        self.displayErrorMessage = false
        self.errorMessage = nil
        })
    }
    
  }
  
  private func signIn() {
    signingIn = true
    startSignInUseCase(username, password) { errorMessage in
      self.errorMessage = errorMessage
      self.displayErrorMessage = true
      self.signingIn = false
    }
  }
}

struct SignInViewModel {
  @State private var username = ""
}

#if DEBUG
struct SignInView_Previews : PreviewProvider {
  static var previews: some View {
    SignInView(startSignInUseCase: { username, password, onError in
      print("Start sign in use case. \(username):\(password)")
    })
  }
}
#endif
