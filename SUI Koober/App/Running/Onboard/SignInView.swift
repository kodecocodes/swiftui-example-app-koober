/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

struct SignInView : View {
  let startSignInUseCase: (String, String) -> Void
  
  @State private var username: String = ""
  @State private var password: String = ""
  
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
  }
  
  func signIn() {
    startSignInUseCase(username, password)
  }
}

#if DEBUG
struct SignInView_Previews : PreviewProvider {
  static var previews: some View {
    SignInView(startSignInUseCase: { username, password in
      print("Start sign in use case. \(username):\(password)")
    })
  }
}
#endif
