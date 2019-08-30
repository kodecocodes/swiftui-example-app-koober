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

struct EnjoyTheRideView : View {
  var body: some View {
    ZStack {
      Color("BackgroundColor")
      VStack {
        TopHStack(goToProfileAction: goToProfile)
        Spacer()
        StartNewRideButton(action: startNewRide)
          .padding()
          .padding(.bottom, 40)
      }
      Image("success_message")
    }
  }
  
  func startNewRide() {
    // TODO: Wire logic to start new ride.
  }
  
  func goToProfile() {
    // TODO: Wire navigation logic.
  }
}

// MARK: - TopHStack
private struct TopHStack: View {
  let goToProfileAction: () -> Void
  
  var body: some View {
    HStack {
      Spacer()
      ProfileButton(action: goToProfileAction)
        .padding()
    }
  }
}

// MARK: - StartNewRideButton
private struct StartNewRideButton: View {
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text("Start New Ride")
        .font(.headline)
        .foregroundColor(.white)
      }
      .frame(minWidth: 80, idealWidth: 200, maxWidth: .infinity,
             minHeight: 54, maxHeight: 54)
      .background(Color("SecondaryBackgroundColor"))
      .cornerRadius(4)
  }
}

// MARK: - ProfileButton
// TODO: Re-use this view in other screens.
struct ProfileButton: View {
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Image(systemName: "person")
        .foregroundColor(.black)
        .font(.title)
    }
  }
}

// MARK: - Preview
#if DEBUG
struct EnjoyTheRideView_Previews : PreviewProvider {
  static var previews: some View {
    EnjoyTheRideView()
  }
}
#endif
