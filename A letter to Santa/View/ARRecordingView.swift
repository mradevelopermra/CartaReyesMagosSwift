//
//  ARRecordingView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 12/12/23.
//
import SwiftUI
import ARKit
import AVFoundation
import Photos
import RealityFoundation
import RealityKit

struct ARRecordingView: View {
    @State private var isRecording = false
    @State private var recorder: VideoRecorder?

    var body: some View {
        ARViewContainerDos(isRecording: $isRecording)
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if isRecording {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.red)
                                .frame(width: 50, height: 50)
                        }
                        Button(action: {
                            isRecording.toggle()
                            if isRecording {
                                recorder?.startRecording()
                            } else {
                                recorder?.stopRecording()
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
            )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                recorder = VideoRecorder()
            }
            .onDisappear {
                recorder = nil
            }
            .gesture(
                LongPressGesture(minimumDuration: 1)
                    .onEnded { _ in
                        isRecording.toggle()
                        if isRecording {
                            recorder?.startRecording()
                        } else {
                            recorder?.stopRecording()
                        }
                    }
            )
    }
}

 
/*struct ARRecordingView: View {
    @State private var isRecording = false
    @State private var recorder: VideoRecorder?
    
    var body: some View {
        ARViewContainerDos(isRecording: $isRecording)
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if isRecording {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.red)
                                .frame(width: 50, height: 50)
                        }
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
            )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                recorder = VideoRecorder()
            }
            .onDisappear {
                recorder = nil
            }
            .gesture(
                LongPressGesture(minimumDuration: 1)
                    .onEnded { _ in
                        isRecording.toggle()
                        if isRecording {
                            startRecording()
                        } else {
                            stopRecording()
                        }
                    }
            )
    }

    func startRecording() {
        // Lógica para iniciar la grabación de video usando recorder
        recorder?.startRecording()
    }

    func stopRecording() {
        // Lógica para detener la grabación de video usando recorder
        recorder?.stopRecording()
    }
}*/

 /*struct ARRecordingView: View {
    @State private var isRecording = false
    @State private var recorder: VideoRecorder?

    var body: some View {
        /*VStack {
           ARViewContainerDos(isRecording: $isRecording)
                        .edgesIgnoringSafeArea(.all)
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            isRecording.toggle()
                            if isRecording {
                                recorder?.startRecording()
                            } else {
                                recorder?.stopRecording()
                            }
                        }) {
                            Text(isRecording ? "Stop Recording" : "Start Recording")
                                .padding()
                                .background(isRecording ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }*/
         ARViewContainerDos(isRecording: $isRecording)
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if isRecording {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.red)
                                .frame(width: 50, height: 50)
                        }
                        Button(action: {
                            isRecording.toggle()
                            if isRecording {
                                recorder?.startRecording()
                            } else {
                                recorder?.stopRecording()
                            }
                        }) {
                            Text(isRecording ? "Stop Recording" : "Start Recording")
                                .padding()
                                .background(isRecording ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    
                    /*HStack {
                        Button(action: {
                            isRecording.toggle()
                            if isRecording {
                                recorder?.startRecording()
                            } else {
                                recorder?.stopRecording()
                            }
                        }) {
                            Text(isRecording ? "Stop Recording" : "Start Recording")
                                .padding()
                                .background(isRecording ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()*/
                    
                }
                

            )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                recorder = VideoRecorder()
            }
            .onDisappear {
                recorder = nil
            }
            .gesture(
                LongPressGesture(minimumDuration: 1)
                    .onEnded { _ in
                        isRecording.toggle()
                        if isRecording {
                            recorder?.startRecording()
                        } else {
                            recorder?.stopRecording()
                        }
                    }
            )
        
        
    }
}*/

 struct ARViewContainerDos: UIViewRepresentable {
    @Binding var isRecording: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARViewContainerDos

        init(_ parent: ARViewContainerDos) {
            self.parent = parent
        }

        // ... Otro código de coordinador según sea necesario
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        do {
            // Cargar la entidad de RealityKit
            let santasHat = try SantasHatNueve.loadEscena()
            
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

/* struct ARViewContainerDos: UIViewRepresentable {
    @Binding var isRecording: Bool
    var arView = ARSCNView(frame: .zero)

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARViewContainerDos

        init(_ parent: ARViewContainerDos) {
            self.parent = parent
        }

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            // Implement logic to add models or nodes to the AR scene
        }
    }

     func makeUIView(context: Context) -> ARSCNView {
        arView.delegate = context.coordinator
        //let config = ARWorldTrackingConfiguration()
         let config = ARWorldTrackingConfiguration()
        arView.session.run(config)
        return arView
    }
    
    /*func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        
        // Load the RealityKit scene
        let faceScene = try! SantasHatNueve.loadEscena()
        
        // Loop through all the entities in the scene and add their anchor to the AR view
        for entity in faceScene.children {
            if let anchorEntity = entity as? HasAnchoring {
                // Check if the entity can be anchored
                arView.scene.anchors.append(anchorEntity.anchor)
            }
        }
        
        // Set up ARFaceTrackingConfiguration and start the session
        let arConfig = ARFaceTrackingConfiguration()
        arView.session.run(arConfig)
        
        return arView
    } */
    
    /*func makeUIView(context: Context) -> ARView {
            let arView = ARView(frame: .zero)

            do {
                // Cargar la entidad de RealityKit
                let santasHat = try SantasHatNueve.loadEscena()
                
                // Crear una entidad ARAnchor
                let anchor = AnchorEntity()
                anchor.addChild(santasHat)
                
                // Add the box anchor to the scene
                let arConfig = ARFaceTrackingConfiguration()
                arView.session.run(arConfig)
                
                // Agregar el ARAnchor al ARView
                arView.scene.addAnchor(anchor)
            } catch {
                // Manejar cualquier error que pueda ocurrir durante la carga de la entidad de RealityKit
                print("Error al cargar la escena de RealityKit: \(error)")
            }

            return arView
        }*/

    func updateUIView(_ uiView: ARView, context: Context) {}
 
    //func updateUIView(_ uiView: ARSCNView, context: Context) {}

    func addNodeToScene() {
        // Logic to add models or nodes to the AR scene
    }
}*/

class VideoRecorder: NSObject {
    private let captureSession = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()
    private var outputFileURL: URL?

    override init() {
        super.init()
        setupSession()
    }

    private func setupSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: device) else {
            print("No se pudo obtener el dispositivo de video o el input.")
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)

            if captureSession.canAddOutput(movieOutput) {
                captureSession.addOutput(movieOutput)
            } else {
                print("No se pudo agregar la salida de video a la sesión de captura.")
            }

            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
        } else {
            print("No se pudo agregar el videoInput a la captura")
        }
    }

    func startRecording() {
            guard let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("video.mp4") else {
                print("No se pudo obtener la URL del archivo de salida.")
                return
            }

            outputFileURL = outputURL

            if movieOutput.isRecording {
                print("La grabación ya está en curso.")
                return
            }

            do {
                try movieOutput.startRecording(to: outputURL, recordingDelegate: self)
                print("Comenzó la grabación de video.")
            } catch let error {
                print("Error al iniciar la grabación: \(error.localizedDescription)")
                // Otras acciones de manejo de errores según sea necesario
            }
        }

    func stopRecording() {
            if !movieOutput.isRecording {
                print("La grabación no está en curso.")
                return
            }

            movieOutput.stopRecording()
            print("Detuvo la grabación de video.")
        }
}

extension VideoRecorder: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error al grabar el video: \(error.localizedDescription)")
            print("Error al grabar el video: \(error.self)")
        } else {
            print("La grabación finalizó correctamente.")
            saveVideoToPhotoLibrary(at: outputFileURL)
        }
    }

    func saveVideoToPhotoLibrary(at fileURL: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }) { success, error in
            if success {
                print("Video guardado en la galería de imágenes correctamente.")
            } else {
                if let error = error {
                    print("Error al guardar el video en la galería de imágenes: \(error.localizedDescription)")
                }
            }
        }
    }
}

 


/*struct ARViewContainerDos: UIViewRepresentable {
    let session: ARSession

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        arView.session = session // Asigna la sesión proporcionada al ARSCNView
 
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // No se necesitan cambios adicionales aquí en este caso
    }
}*/


/*struct ARViewContainerDos: UIViewRepresentable {
    let session: ARSession

        init(session: ARSession) {
            self.session = session
        }

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
*/
