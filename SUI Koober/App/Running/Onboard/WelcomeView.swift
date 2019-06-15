/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

/// This view welcomes the user and asks the user to either sign in or sign up.
struct WelcomeView : View {
  @ObjectBinding var koober: Koober
  
  var body: some View {
    VStack {
      Spacer()
      WelcomeContentView(koober: koober)
      Spacer()
    }
    .background(Color("BackgroundColor"))
    .edgesIgnoringSafeArea(.bottom)
    .navigationBarTitle(Text("Welcome"))
  }
}

#if DEBUG
struct WelcomeView_Previews : PreviewProvider {
  static var previews: some View {
    WelcomeView(koober: Koober())
  }
}
#endif

/// App logo, sign in and sign up buttons.
private struct WelcomeContentView : View {
  @ObjectBinding var koober: Koober
  
  var body: some View {
    VStack {
      Image("roo_logo").background(Color("BackgroundColor"))
      SignInSignUpButtons(koober: koober)
    }
    .background(Color("BackgroundColor"))
    .padding()
  }
}

private struct SignInSignUpButtons : View {
  @ObjectBinding var koober: Koober
  
  var body: some View {
    HStack {
      NavigationButton(destination: SignInView(startSignInUseCase: koober.startSignInUseCase)) {
        Text("Sign In")
        }
        .accentColor(.white)
        .padding()
      Spacer()
      NavigationButton(destination: SignUpView()) {
        Text("Sign Up")
        }
        .accentColor(.white)
        .padding()
    }
  }
}
