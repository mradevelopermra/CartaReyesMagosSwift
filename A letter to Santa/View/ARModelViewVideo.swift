//
//  ARModelViewVideo.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 18/03/24.
//
import SwiftUI
import RealityKit
import AVFoundation
import Photos
import AVKit
import ARKit
import SwiftUI
import RealityKit
import AVFoundation
import Photos
import ARKit
import AVKit

struct ARModelViewVideo: View {
    @State private var isRecording = false
    @State private var videoURL: URL?
    @State private var recordingTimer: Timer?
    @State private var elapsedTime: TimeInterval = 0
    private let videoProcessor = ARVideoCaptureProcessorVideo()

    var body: some View {
        ZStack {
            ARViewContainerFaceDosVideo(isRecording: $isRecording, videoURL: $videoURL, elapsedTime: $elapsedTime)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        Spacer()
                        if let videoURL = videoURL {
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .frame(width: 300, height: 200)
                                .padding()
                        }
                        HStack {
                            Button(action: {
                                startRecording()
                            }) {
                                Text("Iniciar Grabación")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }
                            .padding()

                            Button(action: {
                                stopRecording()
                            }) {
                                Text("Terminar Video")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                            .padding()
                        }
                        Text(String(format: "%.1f s", elapsedTime))
                            .padding()
                    },
                    alignment: .bottom
                )
        }
    }

    private func startRecording() {
        recordingTimer?.invalidate()
        elapsedTime = 0
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            elapsedTime += 0.1
        }
        videoProcessor.startRecording()
        isRecording = true
    }

    private func stopRecording() {
        recordingTimer?.invalidate()
        videoProcessor.stopRecording()
        isRecording = false
    }
}

struct ARViewContainerFaceDosVideo: UIViewRepresentable {
    @Binding var isRecording: Bool
    @Binding var videoURL: URL?
    @Binding var elapsedTime: TimeInterval

    private let videoCaptureProcessor = ARVideoCaptureProcessorVideo()

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let faceScene = try! SantasHatNueve.loadEscena()
        let arAnchor = AnchorEntity(world: [0, 0, -1])
        arAnchor.addChild(faceScene)
        arView.scene.addAnchor(arAnchor)

        // Configurar la sesión AR para utilizar la cámara frontal exclusivamente
        let arConfig = ARFaceTrackingConfiguration()
        arConfig.worldAlignment = .camera
        arView.session.run(arConfig)

        // Iniciar la grabación si está activada
        if isRecording {
            videoCaptureProcessor.startRecording()
        }

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // No necesitamos actualizar la vista aquí
    }
}

// Protocolo personalizado para actuar como delegado del procesador de captura de video
protocol VideoCaptureProcessorDelegate: AnyObject {
    func didFinishRecordingVideo(outputFileURL: URL)
}

class ARVideoCaptureProcessorVideo: NSObject, AVCaptureFileOutputRecordingDelegate {
    weak var delegate: VideoCaptureProcessorDelegate?
    var videoURL: URL?
    private let captureSession = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()

    override init() {
        super.init()

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let deviceInput = try? AVCaptureDeviceInput(device: device) else {
            print("No se pudo acceder a la cámara frontal.")
            return
        }

        // Al asignar el delegado en el bloque 'if'
        if captureSession.canAddInput(deviceInput) && captureSession.canAddOutput(movieOutput) {
            captureSession.addInput(deviceInput)
            captureSession.addOutput(movieOutput)

            let connection = movieOutput.connection(with: .video)
            connection?.videoOrientation = .portrait
        } else {
            print("No se pudo agregar la entrada o salida de la cámara.")
        }
    }

    func startRecording() {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("capturedVideo.mp4")
        movieOutput.startRecording(to: fileURL, recordingDelegate: self)
    }

    func stopRecording() {
        movieOutput.stopRecording()
    }

    // Método del delegado de AVCaptureFileOutputRecordingDelegate
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error al grabar el video: \(error.localizedDescription)")
        } else {
            print("La grabación de video ha finalizado.")
            videoURL = outputFileURL
            // Notificar al delegado personalizado
            delegate?.didFinishRecordingVideo(outputFileURL: outputFileURL)
        }
    }
}
