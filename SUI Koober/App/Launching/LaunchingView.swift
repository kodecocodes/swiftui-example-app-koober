/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

/// This view is presented while the app is launching, i.e. determining if a user is signed in.
struct LaunchingView : View {
  var body: some View {
    VStack {
      Image("roo_logo")
        .background(Color("BackgroundColor"))
        .padding()
      HStack {
        Text("Launching...")
          .font(.headline)
          .color(.white)
          .padding()
      }
      .background(Color("BackgroundColor"))
    }
    .background(Color("BackgroundColor"))
  }
}

#if DEBUG
struct LaunchingView_Previews : PreviewProvider {
  static var previews: some View {
    LaunchingView()
  }
}
#endif

