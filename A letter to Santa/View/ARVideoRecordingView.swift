//
//  ARVideoRecordingView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 20/12/23.
//
import SwiftUI
import ARKit
import ARVideoKit
import RecordAR

class RecorderObject: ObservableObject {
    var recorder: RecordAR

    init(_ arSCNView: ARSCNView) {
        self.recorder = RecordAR(ARSceneKit: arSCNView)
    }
}

struct ARVideoRecordingView: View {
    @StateObject var recorderObject = RecorderObject()
    @State var arSCNView = ARSCNView()

    var body: some View {
        ZStack {
            ARViewContainerDOS(recorder: recorder)
            
            VStack {
                Spacer()
                
                Button(action: {
                    isRecording.toggle()
                    isRecording ? startRecording() : stopRecording()
                }) {
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }

    func startRecording() {
        let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videoURL = documentsFolder.appendingPathComponent("ARRecording.mp4")
        recorder.startRecording(to: videoURL)
    }

    func stopRecording() {
        recorder.stopRecording { path in
            if let path = path {
                print("Video recorded at: \(path)")
            }
        }
    }
}

struct ARViewContainerDOS: UIViewRepresentable {
    var recorder: RecordAR

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        arView.session = recorder.arView.session

        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)
        
        recorder.prepare(configuration)

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
