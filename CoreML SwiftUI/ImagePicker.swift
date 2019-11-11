//
//  ImagePicker.swift
//  CoreML SwiftUI
//
//  Created by Frank Bara on 11/10/19.
//  Copyright © 2019 BaraLabs. All rights reserved.
//

import SwiftUI

final class ImagePickerCoordinator: NSObject {
    
    @Binding var image: UIImage?
    @Binding var takePhoto: Bool
    
    init(image: Binding<UIImage?>, takePhoto: Binding<Bool>) {
        _image = image
        _takePhoto = takePhoto
    }
}

struct ShowImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var takePhoto: Bool

    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(image: $image, takePhoto: $takePhoto)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = context.coordinator
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return pickerController }
        
        switch self.takePhoto {
        case true:
            pickerController.sourceType = .camera
        case false:
            pickerController.sourceType = .photoLibrary
        }
        
        pickerController.allowsEditing = true
        
        return pickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

extension ImagePickerCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        self.image = uiImage
        picker.dismiss(animated: true)
    }
}
