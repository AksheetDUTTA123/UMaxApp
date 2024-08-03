//
//  CameraView.swift
//  UMaxApp
//
//  Created by Aksheet Dutta on 8/2/24.
//

import SwiftUI
import UIKit

struct IdentifiableImage: Identifiable, Hashable {
    let id = UUID()
    let uiImage: UIImage

    func image() -> Image {
        Image(uiImage: uiImage)
    }
}

struct ImagePicker: View {
    @State private var isShown: Bool = false
    @State private var images: [IdentifiableImage] = []
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        VStack {
            Text("Insert at most 3 pictures of your body. Make sure your entire body is visible.")
            ScrollView{
                
                ForEach(images) { identifiableImage in
                    identifiableImage.image()
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding()
                }
            }
            if self.images.count < 3 {
                Button(action: {
                    self.isShown.toggle()
                    self.sourceType = .camera
                    
                }) {
                    Text("Camera")
                }
                Button(action: {
                    self.isShown.toggle()
                    self.sourceType = .photoLibrary
                    
                }) {
                    Text("Photo Library")
                }
            }
        }
        NavigationLink(destination:AnalyzeView()){
            Text("Click for AI Reccomendations!").frame(width:300, height:200, alignment: .center).background(Color.black).foregroundColor(Color.yellow).cornerRadius(30)
                .sheet(isPresented: $isShown) {
                    ImagePickerView(isShown: self.$isShown, images: self.$images, sourceType: self.sourceType)
                }
        }
        
    }
    
    struct ImagePicker_Previews: PreviewProvider {
        static var previews: some View {
            ImagePicker()
        }
    }
    
    struct ImagePickerView: UIViewControllerRepresentable {
        @Binding var isShown: Bool
        @Binding var images: [IdentifiableImage]
        var sourceType: UIImagePickerController.SourceType
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {}
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = context.coordinator
            return picker
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(isShown: $isShown, images: $images)
        }
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            @Binding var isShown: Bool
            @Binding var images: [IdentifiableImage]
            
            init(isShown: Binding<Bool>, images: Binding<[IdentifiableImage]>) {
                _isShown = isShown
                _images = images
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    let identifiableImage = IdentifiableImage(uiImage: uiImage)
                    images.append(identifiableImage)
                }
                isShown = false
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                isShown = false
            }
        }
    }
}
