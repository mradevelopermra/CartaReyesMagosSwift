//
//  GrabaVideoView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 20/12/23.
//

import SwiftUI
import ARKit
import ARVideoKit
import Photos

class Recorder: ObservableObject {
    var sceneView: ARSCNView
    var recordAR: RecordAR?

    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        recordAR = RecordAR(ARSceneKit: sceneView)
    }

    func startRecording() {
        guard let recordAR = recordAR else { return }
        recordAR.record()
    }

    func stopRecording() {
        guard let recordAR = recordAR else { return }
        recordAR.stopAndExport { url, _, _ in
            self.saveVideoToPhotoLibrary(videoURL: url)
        }
    }

    private func saveVideoToPhotoLibrary(videoURL: URL) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        } completionHandler: { success, error in
            if success {
                print("Video saved to photo library successfully.")
            } else {
                if let error = error {
                    print("Error saving video to photo library: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct GrabaVideoViewCinco: View {
    var recorder: Recorder

    init() {
        let sceneView = ARSCNView()
        self.recorder = Recorder(sceneView: sceneView)
    }

    var body: some View {
        VStack {
            ARViewContainerCinco(recorder: recorder)
            HStack {
                Button("Start Recording") {
                    recorder.startRecording()
                }
                Button("Stop Recording") {
                    recorder.stopRecording()
                }
            }
        }
    }
}

struct ARViewContainerCinco: UIViewRepresentable {
    var recorder: Recorder

    func makeUIView(context: Context) -> ARSCNView {
        return recorder.sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
 
