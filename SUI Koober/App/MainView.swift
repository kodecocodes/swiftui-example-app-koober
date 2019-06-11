/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 9, 2019.

import SwiftUI

/// The app's root view.
struct MainView : View {
  /// This is the app's state store that is threaded down the view hierachy. It's a kind of Redux-like usage of SwiftUI. Anytime any state in `Koober` changes, this view and the entire view hierarchy is recomputed to reflect changes. This is supposed to be cheap because only the views that change are re-rendered.
  @ObjectBinding var koober: Koober
  
  var body: some View {
    VStack {
      if koober.isLaunching {
        LaunchingView()
      } else {
        RunningView(koober: koober)
      }
    }
  }
}

#if DEBUG
struct MainView_Previews : PreviewProvider {
  static var previews: some View {
    MainView(koober: Koober())
  }
}
#endif
