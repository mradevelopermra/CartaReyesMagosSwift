import _AVKit_SwiftUI
import SwiftUI
import AVFoundation
import Photos

struct VideoRecordingView: View {
    @State private var isRecording = false
    @State var videoURL: URL?
    @State private var captureSession: AVCaptureSession?
    @State private var output: AVCaptureMovieFileOutput?

    var body: some View {
        VStack {
            if let videoURL = videoURL {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 300)
                    .padding()
            } else {
                CameraPreviewViewCarta(isRecording: $isRecording, videoURL: $videoURL, captureSession: $captureSession, output: $output)
                    .frame(height: 300)
                    .padding()
            }

            Button(action: {
                if isRecording {
                    stopRecordingVideo()
                } else {
                    startRecordingVideo()
                }
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if videoURL != nil {
                Button(action: saveVideoToGallery) {
                    Text("Save to Gallery")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }

    func startRecordingVideo() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }

        do {
            let captureSession = AVCaptureSession()
            let input = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)

            let output = AVCaptureMovieFileOutput()
            captureSession.addOutput(output)

            captureSession.startRunning()
            captureSession.commitConfiguration()

            let tempVideoURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")

            output.startRecording(to: tempVideoURL, recordingDelegate: VideoRecordingDelegate(parent: self, output: output))
            self.captureSession = captureSession
            self.output = output
            isRecording = true
        } catch {
            print("Error setting up the camera: \(error.localizedDescription)")
        }
    }

    func stopRecordingVideo() {
        captureSession?.stopRunning()
        isRecording = false
    }

    func saveVideoToGallery() {
        if let videoURL = videoURL {
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            } completionHandler: { success, error in
                if success {
                    print("Video saved to the gallery")
                } else if let error = error {
                    print("Error saving video: \(error)")
                }
            }
        }
    }
}

struct CameraPreviewViewCarta: View {
    @Binding var isRecording: Bool
    @Binding var videoURL: URL?
    @Binding var captureSession: AVCaptureSession?
    @Binding var output: AVCaptureMovieFileOutput?

    var body: some View {
        // Implement your camera preview here
        Rectangle()
            .fill(Color.gray)
            .onAppear {
                if isRecording {
                    startRecordingVideo()
                }
            }
            .onDisappear {
                stopRecordingVideo()
            }
    }

    func startRecordingVideo() {
        // Implement video recording logic here
    }

    func stopRecordingVideo() {
        // Implement video recording stop logic here
    }
}

class VideoRecordingDelegate: NSObject, AVCaptureFileOutputRecordingDelegate {
    var parent: VideoRecordingView
    var output: AVCaptureMovieFileOutput

    init(parent: VideoRecordingView, output: AVCaptureMovieFileOutput) {
        self.parent = parent
        self.output = output
    }

    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        // Handle recording start
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording video: \(error.localizedDescription)")
        } else {
            parent.videoURL = outputFileURL
        }
    }
}
