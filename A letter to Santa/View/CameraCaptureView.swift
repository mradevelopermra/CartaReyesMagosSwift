//
//  CameraCaptureView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 19/09/23.
//

import SwiftUI
import AVFoundation


struct CameraCaptureView: View {
    @State private var isDrawing = false // Variable de estado para controlar el dibujo
    @State private var capturedImage: UIImage? // Variable para almacenar la imagen capturada
    
    var body: some View {
        ZStack {
            CameraPreview(capturedImage: $capturedImage) // Vista de vista previa de la cámara
                .onAppear {
                    isDrawing = true // Comienza a capturar cuando aparece la vista
                }
            
            if let image = capturedImage {
                AnimatedDrawingView(image: image) // Vista para animar el dibujo
            }
        }
    }
}

struct CameraPreview: View {
    @Binding var capturedImage: UIImage?
    
    var body: some View {
        CameraViewController(capturedImage: $capturedImage)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CameraViewController: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    
    func makeUIViewController(context: Context) -> AVCaptureViewController {
        let viewController = AVCaptureViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AVCaptureViewController, context: Context) {
        // No se necesita actualización
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, AVCaptureViewControllerDelegate {
        var parent: CameraViewController
        
        init(_ parent: CameraViewController) {
            self.parent = parent
        }
        
        func didCaptureImage(_ image: UIImage) {
            parent.capturedImage = image
        }
    }
}

struct AnimatedDrawingView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(360))
            .animation(.easeInOut(duration: 2.0))
    }
}

 
