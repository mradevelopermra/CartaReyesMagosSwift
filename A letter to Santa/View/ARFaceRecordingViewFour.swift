import SwiftUI
import ARKit

struct ARFaceRecordingViewFour: View {
    @StateObject var arFaceViewModel = ARFaceRecordingViewModelFour()

    var body: some View {
        VStack {
            ARViewContainerFour(arFaceViewModel: arFaceViewModel)
                .onAppear {
                    arFaceViewModel.setupRecorder()
                }

            Button(arFaceViewModel.isRecording ? "Stop Recording" : "Start Recording") {
                if arFaceViewModel.isRecording {
                    arFaceViewModel.stopRecording()
                } else {
                    arFaceViewModel.startRecording()
                }
            }
        }
    }
}

struct ARViewContainerFour: UIViewRepresentable {
    var arFaceViewModel: ARFaceRecordingViewModelFour
    var arView: ARSCNView?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        var parent: ARViewContainerFour

        init(_ parent: ARViewContainerFour) {
            self.parent = parent
        }

        // Implement ARSessionDelegate methods here if needed

        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            // Update logic if needed
        }
    }

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        arView.delegate = context.coordinator
        self.arView = arView
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if arView == nil {
            arView = uiView
            context.coordinator.parent.setupRecording()
        }
    }

    func setupRecording() {
        guard let uiView = arView else { return }
        let recorder = ARFaceTrackingRecorder(withARSCNView: uiView)
        arFaceViewModel.setupRecorder(recorder)
    }
}

class ARFaceRecordingViewModelFour: ObservableObject {
    var recorder: ARFaceTrackingRecorder?
    @Published var isRecording = false

    func startRecording() {
        recorder?.record()
        isRecording = true
    }

    func stopRecording() {
        recorder?.stopAndExport()
        isRecording = false
    }

    func setupRecorder() {
        guard recorder == nil else { return }
        let recorder = ARFaceTrackingRecorder(withARSCNView: nil)
        self.recorder = recorder
    }
}
