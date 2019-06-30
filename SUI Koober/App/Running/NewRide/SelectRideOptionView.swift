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

struct SelectRideOptionView : View {
  @State private var rideOptions = [RideOption(name: "Wallabee", selected: true),
                                    RideOption(name: "Wallaroo"),
                                    RideOption(name: "Kangaroo")]
  var body: some View {
    ZStack(alignment: .bottom) {
      BackgroundBar()
      RideOptionButtons(rideOptions: rideOptions, action: select(rideOption:))
    }
  }
  
  func select(rideOption selectedRideOption: RideOption) {
    self.rideOptions = rideOptions.map { rideOption in
      let isSelectedRideOption = rideOption == selectedRideOption
      var updatedRideOption = rideOption
      updatedRideOption.selected = isSelectedRideOption
      return updatedRideOption
    }
  }
}

struct RideOptionButtons: View {
  let rideOptions: [RideOption]
  let action: (RideOption) -> Void
  
  var body: some View {
    HStack {
      Spacer()
      ForEach(rideOptions) { rideOption in
        RideOptionButton(rideOption: rideOption, action: self.action)
          .padding(.bottom)
        Spacer()
      }
    }
  }
}

struct BackgroundBar: View {
  var body: some View {
    VStack {
      Color("BackgroundColor")
      }.frame(height: 86)
  }
}

struct RideOptionButton: View {
  let rideOption: RideOption
  let action: (RideOption) -> Void
  
  var body: some View {
    Button(action: {
      self.action(self.rideOption)
    }) {
      Image(rideOption.selected ? rideOption.selectedImageName : rideOption.imageName)
        .frame(width: 90, height: 80)
      Text(rideOption.name)
    }
    .accentColor(Color.white)
  }
}

struct RideOption: Identifiable, Equatable {
  var id: String { name }
  let name: String
  var imageName: String { "ride_option_\(name.lowercased())" }
  var selectedImageName: String { "\(imageName)_selected" }
  var selected: Bool = false
}

#if DEBUG
struct SelectRideOptionView_Previews : PreviewProvider {
  static var previews: some View {
    ZStack(alignment: .bottom) {
      Color.white
      SelectRideOptionView()
    }
    
  }
}
#endif
