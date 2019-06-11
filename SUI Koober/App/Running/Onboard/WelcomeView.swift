/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

/// This view welcomes the user and asks the user to either sign in or sign up.
struct WelcomeView : View {
  @ObjectBinding var koober: Koober
  
  var body: some View {
      VStack {
          NavigationView {
            VStack {
                Image("roo_logo")
                    .background(Color("BackgroundColor"))
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
            .background(Color("BackgroundColor"))
        }
  }
  }
}

#if DEBUG
struct WelcomeView_Previews : PreviewProvider {
  static var previews: some View {
    WelcomeView(koober: Koober())
  }
}
#endif
