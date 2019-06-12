/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

/// This view is presented once the app is finished launching and is running.
struct RunningView : View {
  @ObjectBinding var koober: Koober
  
  var body: some View {
    VStack {
      if koober.userIsAuthenticated {
        // TODO: Undo this force unwrap hack.
        NewRideView(user: koober.authenticatedUser!)
      } else {
        OnboardView(koober: koober)
      }
    }
  }
}

#if DEBUG
struct RunningView_Previews : PreviewProvider {
  static var previews: some View {
    RunningView(koober: Koober())
  }
}
#endif
