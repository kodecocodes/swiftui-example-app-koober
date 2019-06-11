/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

/// This view is presented if a user is signed in and ready to start a new ride.
struct NewRideView : View {
  var body: some View {
    Text("Start a new hoppin ride...")
  }
}

#if DEBUG
struct NewRideView_Previews : PreviewProvider {
  static var previews: some View {
    NewRideView()
  }
}
#endif
