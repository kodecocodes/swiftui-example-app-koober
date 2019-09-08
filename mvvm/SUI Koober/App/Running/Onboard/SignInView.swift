/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct SignInView : View {
  
  let viewModel: SignInViewModelProtocol
  
  var body: some View {
    VStack {
      FormField(viewModel.email) {
        Text("Username")
          .foregroundColor(.white)
          .frame(width: 80)
          .padding()
      }
      FormField(viewModel.password, secure: true) {
        Text("Password")
          .foregroundColor(.white)
          .frame(width: 80)
          .padding()
      }
      Button(action: viewModel.signIn) {
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
}

#if DEBUG
struct SignInView_Previews : PreviewProvider {
  static var previews: some View {
    NavigationView {
      SignInView(viewModel: SignInViewModel(startSignInUseCase: { username, password in
        print("Start sign in use case. \(username):\(password)")
      }))
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
        SecureField("", text: text) // TODO: Add title property to `FormField`.
          .padding()
          .background(Color(hue: 1, saturation: 1, brightness: 1, opacity: 0.1))
      } else {
        TextField("", text: text) // TODO: Add title property to `FormField`.
          .padding()
          .background(Color(hue: 1, saturation: 1, brightness: 1, opacity: 0.1))
      }
    }
  }
}
