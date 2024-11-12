//
//  FotoUIView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 25/01/24.
//
/* import SwiftUI
import AVFoundation
import Photos
import PhotosUI

struct CameraFaceView: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraFaceView
        var didCaptureImage: (UIImage) -> Void

        init(parent: CameraFaceView, didCaptureImage: @escaping (UIImage) -> Void) {
            self.parent = parent
            self.didCaptureImage = didCaptureImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                didCaptureImage(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Binding var capturedImage: UIImage?
    var didCaptureImage: (UIImage) -> Void // Nueva adición
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, didCaptureImage: didCaptureImage)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraDevice = .front
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


struct FotoUIView: View {
    @State private var capturedImage: UIImage?
    @State private var isCapturePresented = false

    var body: some View {
        VStack {
            if let capturedImage = capturedImage {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                Button("Tomar Foto") {
                    isCapturePresented = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .sheet(isPresented: $isCapturePresented) {
                    CameraFaceView(capturedImage: $capturedImage, didCaptureImage: { image in
                        self.didCaptureImage(image)
                    })
                }
            }
        }
    }

    func didCaptureImage(_ image: UIImage) {
        capturedImage = image
    }
}*/
 
//************************
 
import SwiftUI
import TOCropViewController

struct CameraFaceView: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate {
        var parent: CameraFaceView
        var didCaptureImage: (UIImage) -> Void

        init(parent: CameraFaceView, didCaptureImage: @escaping (UIImage) -> Void) {
            self.parent = parent
            self.didCaptureImage = didCaptureImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                let cropViewController = TOCropViewController(image: image)
                cropViewController.delegate = self
                parent.presentationMode.wrappedValue.dismiss()

                // Use the key window's root view controller to present the crop view controller
                if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                   let rootViewController = keyWindow.rootViewController {
                    rootViewController.present(cropViewController, animated: true, completion: nil)
                }
            }
        }

        func toCropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, rect cropRect: CGRect, angle: Int) {
            didCaptureImage(image)
            cropViewController.dismiss(animated: true, completion: nil)
        }

        func toCropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
            cropViewController.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Binding var capturedImage: UIImage?
    var didCaptureImage: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, didCaptureImage: didCaptureImage)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraDevice = .front
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct FotoUIView: View {
    @State private var capturedImage: UIImage?
    @State private var isCapturePresented = false

    var body: some View {
        VStack {
            if let capturedImage = capturedImage {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                Button("Tomar Foto") {
                    isCapturePresented = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .sheet(isPresented: $isCapturePresented) {
                    CameraFaceView(capturedImage: $capturedImage, didCaptureImage: { image in
                        self.didCaptureImage(image)
                    })
                }
            }
        }
    }

    func didCaptureImage(_ image: UIImage) {
        capturedImage = image
        isCapturePresented = false // Cierra la vista modal después de capturar y recortar la imagen
    }
}

