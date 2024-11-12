//
//  CameraVideoView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 31/10/23.
//
 

import SwiftUI
import AVKit
import AVFoundation

struct CameraVideoView: View {
    @State private var isRecording = false
    @State private var videoURL: URL?

    var body: some View {
        VStack {
            CameraVideoView(isRecording: $isRecording)

            Button(action: {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
            }) {
                Text(isRecording ? "Detener Grabación" : "Comenzar Grabación")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if let videoURL = videoURL {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(width: 300, height: 200)
                    .onAppear {
                        videoURL.startAccessingSecurityScopedResource()
                    }
                    .onDisappear {
                        videoURL.stopAccessingSecurityScopedResource()
                    }
            }
        }
    }

    func startRecording() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("No se pudo acceder al directorio de documentos.")
            return
        }

        let videoFilename = UUID().uuidString
        let outputURL = documentsDirectory.appendingPathComponent(videoFilename).appendingPathExtension("mov")

        let captureSession = AVCaptureSession()

        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("No se pudo acceder a la cámara frontal.")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch {
            print("Error al configurar la entrada de la cámara: \(error.localizedDescription)")
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill

        let videoOutput = AVCaptureMovieFileOutput()
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        captureSession.startRunning()
        videoOutput.startRecording(to: outputURL, recordingDelegate: self)
    }

    func stopRecording() {
        videoURL = nil
    }
}

extension CameraView: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("Comenzando la grabación: \(fileURL)")
        videoURL = fileURL
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error al finalizar la grabación: \(error.localizedDescription)")
        } else {
            print("Grabación finalizada: \(outputFileURL)")
        }
    }
}

 
