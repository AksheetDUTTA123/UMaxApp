//
//  CameraView.swift
//  UMaxApp
//
//  Created by Aksheet Dutta on 8/2/24.
//

import SwiftUI
import UIKit
import AVFoundation

struct ImagePicker : View{
    @State private var isShown:Bool = false
    @State private var image:Image = Image(systemName:"")
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    var body:some View {
        VStack{
            image.resizable().frame(width:200, height:200)
            Button(action: {
                self.isShown.toggle()
                self.sourceType = .camera
            }){
                Text("Camera")
            }
            Button(action: {
                self.isShown.toggle()
                self.sourceType = .photoLibrary
            }){
                Text("Photo Library")
            }
            
        }.sheet(isPresented: $isShown){
            A(isShown:self.$isShown, myImage : self.$image, mysourceType:self.$sourceType)
    }
    }
    }

struct ImagePicker_Previews:PreviewProvider {
    static var previews: some View{
        ImagePicker()
    }
}
struct A:UIViewControllerRepresentable{
    @Binding var isShown : Bool
    @Binding var myImage : Image
    @Binding var mysourceType : UIImagePickerController.SourceType
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<A>) {
        
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<A>) -> UIImagePickerController {
        let obj = UIImagePickerController()
        obj.sourceType = mysourceType
        obj.delegate = context.coordinator
        return obj
    }
    func makeCoordinator() -> C {
        return C(isShown : $isShown, myimage :$myImage)
    }
}

class C: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Binding var isShown: Bool
    @Binding var myimage : Image
    init(isShown: Binding<Bool>, myimage : Binding <Image>){
        _isShown = isShown
        _myimage = myimage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print (image)
            myimage = Image.init(uiImage : image)
            
        }
        isShown = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
