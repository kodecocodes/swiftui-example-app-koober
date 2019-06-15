/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

/// To be implemented...
struct SignUpView : View {
  var body: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Text("Sign Up, under construction...")
        Spacer()
      }
      Spacer()
    }
    .padding()
    .background(Color("BackgroundColor"))
    .edgesIgnoringSafeArea(.bottom)
    .navigationBarTitle(Text("Sign Up"))
  }
}

#if DEBUG
struct SignUpView_Previews : PreviewProvider {
  static var previews: some View {
    NavigationView {
      SignUpView()
    }
  }
}
#endif
