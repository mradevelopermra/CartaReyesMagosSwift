//
//  CamaraPruebasView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 31/10/23.
//
import SwiftUI
import AVFoundation
import Photos
import RealityKit
import ARKit
import _AVKit_SwiftUI

class CameraDelegate: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    @Published var isRecording = false
    @Published var videoURL: URL?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    var player: AVPlayer?

    override init() {
        super.init()
        setupCamera()
    }

    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        // Implementa este método si es necesario
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error al grabar el video: \(error.localizedDescription)")
        } else {
            saveVideoToLibrary(outputFileURL)
        }
    }

    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.beginConfiguration()

        guard let captureSession = captureSession else { return }

        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }

            let dataOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }

            captureSession.commitConfiguration()

            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer = previewLayer
            captureSession.startRunning()
        } catch {
            print("Error al configurar la cámara: \(error.localizedDescription)")
        }
    }

    func startRecording() {
        guard let captureSession = captureSession else { return }

        if let dataOutput = captureSession.outputs.first as? AVCaptureMovieFileOutput {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let videoURL = documentsDirectory.appendingPathComponent("myVideo.mp4")

            if FileManager.default.fileExists(atPath: videoURL.path) {
                do {
                    try FileManager.default.removeItem(at: videoURL)
                } catch {
                    print("Error al eliminar el archivo existente: \(error.localizedDescription)")
                }
            }

            dataOutput.startRecording(to: videoURL, recordingDelegate: self)
            self.videoURL = videoURL
            isRecording = true
        }
    }

    func stopRecording() {
        guard let captureSession = captureSession else { return }

        if let dataOutput = captureSession.outputs.first as? AVCaptureMovieFileOutput, dataOutput.isRecording {
            dataOutput.stopRecording()
            isRecording = false
            captureSession.stopRunning()
        }
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

struct CamaraPruebasView: View {
    @ObservedObject var cameraDelegate = CameraDelegate()

    var body: some View {
        ZStack {
            if let previewLayer = cameraDelegate.previewLayer {
                CameraPreviewView(previewLayer: previewLayer)
                    .onAppear(perform: {
                        cameraDelegate.setupCamera()
                    })
            }

            if let player = cameraDelegate.player {
                VideoPlayer(player: player)
                    .onAppear {
                        player.play()
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }

            ARViewContainerFaceCarta(cameraDelegate: cameraDelegate)
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
            }
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    var previewLayer: AVCaptureVideoPreviewLayer
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct ARViewContainerFaceCarta: UIViewRepresentable {
    @ObservedObject var cameraDelegate: CameraDelegate

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
 
