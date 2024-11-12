//
//  CamaraCartaPruebasView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 02/11/23.
//
import SwiftUI
import AVFoundation
import Photos
import RealityKit
import ARKit

class CameraDelegateCarta: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    @Published var isRecording = false
    @Published var videoURL: URL?
    
    private var captureSession: AVCaptureSession?
    private var fileOutput: AVCaptureMovieFileOutput?
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error al grabar el video: \(error.localizedDescription)")
        } else {
            saveVideoToLibrary(outputFileURL)
        }
    }

    func setupCamera() {
        captureSession = AVCaptureSession()

        guard let captureSession = captureSession else {
            print("Error: No se pudo crear la sesión de captura")
            return
        }

        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Error: No se pudo obtener la cámara frontal")
            return
        }


        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            captureSession.addInput(input)

            fileOutput = AVCaptureMovieFileOutput()

            if let fileOutput = fileOutput {
                captureSession.addOutput(fileOutput)
                captureSession.startRunning()
            } else {
                print("Error: No se pudo configurar la salida de video")
            }
        } catch {
            print("Error al configurar la cámara: \(error.localizedDescription)")
        }
    }

    func startRecording() {
        guard let captureSession = captureSession, let fileOutput = fileOutput else {
            return
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videoURL = documentsDirectory.appendingPathComponent("myVideo.mp4")

        if FileManager.default.fileExists(atPath: videoURL.path) {
            do {
                try FileManager.default.removeItem(at: videoURL)
            } catch {
                print("Error al eliminar el archivo existente: \(error.localizedDescription)")
            }
        }

        fileOutput.startRecording(to: videoURL, recordingDelegate: self)
        self.videoURL = videoURL
        isRecording = true
    }

    func stopRecording() {
        guard let fileOutput = fileOutput, fileOutput.isRecording else {
            return
        }

        fileOutput.stopRecording()
        isRecording = false
        captureSession?.stopRunning()
    }

    func saveVideoToLibrary(_ videoURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                } completionHandler: { success, error in
                    if success {
                        print("Video guardado en la galería.")
                    } else if let error = error {
                        print("Error al guardar el video en la galería: \(error.localizedDescription)")
                    }
                }
            case .denied, .restricted:
                print("El acceso a la galería de fotos fue denegado o está restringido.")
            default:
                print("No se pudo obtener una respuesta autorizada para acceder a la galería de fotos.")
            }
        }
    }
}

struct ARViewContainerFaceViewCarta: UIViewRepresentable {
    @ObservedObject var cameraDelegate: CameraDelegateCarta

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        if let faceScene = try? SantasHatNueve.loadEscena() {
            arView.scene.anchors.append(faceScene)
        }

        let arConfig = ARFaceTrackingConfiguration()
        arView.session.run(arConfig)

        return arView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct CamaraCartaPruebasView: View {
    @ObservedObject var cameraDelegate = CameraDelegateCarta()

    var body: some View {
        ZStack {
            ARViewContainerFaceViewCarta(cameraDelegate: cameraDelegate)
                .frame(width: 250, height: 300)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(20)
                .offset(x: 250, y: 350)

            VStack {
                Spacer()

                Button(action: {
                    if cameraDelegate.isRecording {
                        cameraDelegate.stopRecording()
                    } else {
                        cameraDelegate.startRecording()
                    }
                }) {
                    Text(cameraDelegate.isRecording ? "Detener" : "Grabar")
                        .padding()
                        .background(cameraDelegate.isRecording ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    if let videoURL = cameraDelegate.videoURL {
                        cameraDelegate.saveVideoToLibrary(videoURL)
                    }
                }) {
                    Text("Guardar en la galería")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
 
