/// **NOTE:** This is a quick prototype built to understand SwiftUI. The code was hacked together, some of the code is rough and attempts to simulate side effects. June 15, 2019.

import SwiftUI

/// Container view that spans the entire screen, ignoring safe areas.
struct FullscreenView<Content: View> : View {
  let content: Content
  let backgroundColor: Color
  
  
  public init(backgroundColor: Color = Color.white,
              @ViewBuilder content: () -> Content) {
    self.backgroundColor = backgroundColor
    self.content = content()
  }
  
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Spacer()
        content
        Spacer()
      }
      Spacer()
    }
    .background(backgroundColor)
    .edgesIgnoringSafeArea(.all)
  }
}

#if DEBUG
struct FullscreenView_Previews : PreviewProvider {
  static var previews: some View {
    FullscreenView {
      Text("Content")
    }
  }
}
#endif
