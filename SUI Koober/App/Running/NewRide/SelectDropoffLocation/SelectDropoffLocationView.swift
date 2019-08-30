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

struct SelectDropoffLocationView : View {
  let locations: [Location] = ["Opera House", "Apple Store", "100 George Street", "MOMA"]
  @State private var searchQuery = ""
  
  var body: some View {
    NavigationView {
      SearchField(searchQuery: $searchQuery)
      DropoffLocationList(locations: locations, action: select(location:))
        .navigationBarTitle(Text("Where to?"))
        .navigationBarItems(leading: CancelButton(action: cancel))
    }
  }
  
  func cancel() {
    // TODO: Implement view dismiss.
  }
  
  func select(location: Location) {
    // TODO: Implement selection logic.
  }
}

struct SearchField: View {
  @Binding var searchQuery: String
  
  var body: some View {
    ZStack {
      Color("SearchBackgroundColor")
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundColor(Color("PlaceholderTextColor"))
          .padding(.leading, CGFloat(15))

        // .foregroundColor(Color("PlaceholderTextColor"))
        TextField("Search", text: $searchQuery)
          .font(.body)
      }
    }
    .frame(maxHeight: 40)
    .cornerRadius(10)
    .padding([.leading, .trailing])
  }
}

struct DropoffLocationList: View {
  let locations: [Location]
  let action: (Location) -> Void
  
  var body: some View {
    List(locations) { location in
      Button(action: {
        self.select(location: location)
      }) {
        Text(location.name)
      }
    }
  }
  
  func select(location: Location) {
    action(location)
  }
  
}

struct CancelButton: View {
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text("Cancel")
    }
  }
}

/// Temporary data structure to populate dropoff location list.
struct Location: ExpressibleByStringLiteral, Identifiable {
  var id: String
  var name: String
  
  init(stringLiteral value: String) {
    self.id = value
    self.name = value
  }
}

#if DEBUG
struct SelectDropoffLocationView_Previews : PreviewProvider {
  static var previews: some View {
    SelectDropoffLocationView()
  }
}
#endif
