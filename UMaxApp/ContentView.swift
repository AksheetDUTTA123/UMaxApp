//
//  ContentView.swift
//  UMaxApp
//
//  Created by Aksheet Dutta on 8/2/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(destination:ImagePicker()){
                    Text("Click for Camera").frame(width:300, height:200, alignment: .center).background(Color.black).foregroundColor(Color.yellow).cornerRadius(30)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
