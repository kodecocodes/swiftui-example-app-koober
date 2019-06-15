/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

/// This view is presented when a user is not signed in.
struct OnboardView : View {
  @ObjectBinding var koober: Koober
  
  var body: some View {
    NavigationView {
      WelcomeView(koober: koober)
    }
  }
}

#if DEBUG
struct OnboardView_Previews : PreviewProvider {
  static var previews: some View {
    OnboardView(koober: Koober())
  }
}
#endif
