/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

struct SignInView : View {
  let startSignInUseCase: (String, String) -> Void
  
  @State private var username: String = ""
  @State private var password: String = ""
  
  var body: some View {
    VStack {
      FormField($username) {
        Text("Username")
          .color(.white)
          .frame(width: 80)
          .padding()
      }
      FormField($password, secure: true) {
        Text("Password")
          .color(.white)
          .frame(width: 80)
          .padding()
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
    .edgesIgnoringSafeArea(.bottom)
    .navigationBarTitle(Text("Sign In"))
  }
  
  func signIn() {
    startSignInUseCase(username, password)
  }
}

#if DEBUG
struct SignInView_Previews : PreviewProvider {
  static var previews: some View {
    NavigationView{
      SignInView(startSignInUseCase: { username, password in
        print("Start sign in use case. \(username):\(password)")
      })
    }
  }
}
#endif

private struct FormField<Label: View>: View {
  private var text: Binding<String>
  let secure: Bool
  let label: Label
  
  init(_ text: Binding<String>, secure: Bool = false, @ViewBuilder label: () -> Label) {
    self.text = text
    self.secure = secure
    self.label = label()
  }
  
  var body: some View {
    HStack {
      label
      if (secure) {
        SecureField(text)
          .padding()
          .background(Color(hue: 1, saturation: 1, brightness: 1, opacity: 0.1))
      } else {
        TextField(text)
          .padding()
          .background(Color(hue: 1, saturation: 1, brightness: 1, opacity: 0.1))
      }
    }
  }
}
