//
//  ARRecordingViewTres.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 21/12/23.
//
import SwiftUI
import ReplayKit
import RealityKit

struct ARViewContainerTres: View {
    @Binding var isRecording: Bool
    
    var body: some View {
        ZStack {
            ARViewContainerTres(isRecording: $isRecording)
            
            VStack {
                Spacer()
                Button(action: {
                    isRecording.toggle()
                    if isRecording {
                        startRecording()
                    } else {
                        stopRecording()
                    }
                }) {
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .padding()
                        .background(isRecording ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    func startRecording() {
        let recorder = RPScreenRecorder.shared()
        if recorder.isAvailable {
            recorder.startRecording { error in
                if let error = error {
                    print("Error al iniciar la grabación: \(error.localizedDescription)")
                } else {
                    print("Comenzó la grabación de pantalla.")
                }
            }
        }
    }
    
    func stopRecording() {
                let recorder = RPScreenRecorder.shared()
                recorder.stopRecording { previewViewController, error in
                    if let error = error {
                        print("Error al detener la grabación: \(error.localizedDescription)")
                    }
                    
                    if let previewViewController = previewViewController {
                        previewViewController.previewControllerDelegate = self
                        // Presentar vista previa: present(previewViewController)
                    }
                    
                    // Guardar el video en la galería
                    if let previewItem = previewViewController?.previewController(previewViewController, previewFor: .share) {
                        let activityViewController = UIActivityViewController(activityItems: [previewItem], applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                    }
                }
            }
}

extension ARViewContainerTres: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.addSubview(ARViewContainer(isRecording: $isRecording).makeUIView(context: context))
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var isRecording: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARViewContainer

        init(_ parent: ARViewContainer) {
            self.parent = parent
        }

        // ... Otro código de coordinador según sea necesario
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        do {
            // Cargar la entidad de RealityKit
            let santasHat = try SantasHatNueve.loadScene()
            
            // Crear una entidad ARAnchor
            let anchor = AnchorEntity()
            anchor.addChild(santasHat)
            
            // Configurar ARFaceTrackingConfiguration y comenzar la sesión
            let arConfig = ARFaceTrackingConfiguration()
            arView.session.run(arConfig)
            
            // Agregar el ARAnchor al ARView
            arView.scene.anchors.append(anchor)
        } catch {
            // Manejar cualquier error que pueda ocurrir durante la carga de la entidad de RealityKit
            print("Error al cargar la escena de RealityKit: \(error)")
        }

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

extension ARViewContainerDos: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        // Se invoca cuando el usuario termina con la vista previa
        previewController.dismiss(animated: true)
    }
}

