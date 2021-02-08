//
//  ImagePicker.swift
//  Full Login
//
//  Created by Mickey on 18/06/20. All rights reserved.
//

import SwiftUI

struct ImagePickerOnboarding: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        
        return ImagePickerOnboarding.Coordinator(parent1: self)
    }
    
    @Binding var showPicker : Bool
    @Binding var imageData : Data
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePickerOnboarding
        
        init(parent1: ImagePickerOnboarding) {
            
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            parent.showPicker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if ((info[.editedImage]) != nil) {
                let image = info[.editedImage] as! UIImage
                parent.imageData = image.jpegData(compressionQuality: 0.5)!
                parent.showPicker.toggle()
            } else {
            let imgData = info[.originalImage] as! UIImage
            parent.imageData = imgData.jpegData(compressionQuality: 0.5)!
            parent.showPicker.toggle()
            }
        }
    }
}
