//
//  FotoARView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 26/01/24.
//
import SwiftUI
import ARKit
import RealityKit
import AVFoundation

struct FotoARView: View {
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
                    isCapturePresented.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .sheet(isPresented: $isCapturePresented) {
                    CameraARView(capturedImage: $capturedImage)
                }
            }

            ARViewTresContainer(capturedImage: $capturedImage)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 300)  // Ajusta la altura según tus necesidades
        }
    }
}

struct ARViewTresContainer: UIViewRepresentable {
    @Binding var capturedImage: UIImage?

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.setupConfiguration()
        arView.setupGestureRecognizers()
        arView.addModelToScene()
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Actualizar la vista si es necesario
    }
}

struct CameraARView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraARView

        init(parent: CameraARView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraDevice = .front
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Actualizar la vista si es necesario
    }
}

extension ARView {
    func setupConfiguration() {
        // Configuración AR
        let configuration = ARFaceTrackingConfiguration()
        session.run(configuration, options: [])
    }

    func setupGestureRecognizers() {
        // Configuración de gestos si es necesario
    }

    func addModelToScene() {
        // Añadir modelo a la escena si es necesario
    }
}
