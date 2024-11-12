//
//  ContentView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 25/09/23.
//
 
import SwiftUI
import RealityKit
import ARKit

struct ContentModelView : View {
    @State private var selectedModel: String?
    @State private var isModelPickerPresented = false
    
    var body: some View {
        NavigationView {
            ARModelUsdzViewer(selectedModel: $selectedModel)
                .edgesIgnoringSafeArea(.all)
                .navigationBarItems(trailing:
                    Button("Select Model") {
                        isModelPickerPresented.toggle()
                    }
                )
        }
        .sheet(isPresented: $isModelPickerPresented) {
            ModelPicker(selectedModel: $selectedModel)
        }
    }
}

struct ModelPicker: View {
    @Binding var selectedModel: String?
    
    var body: some View {
        List(["gift_box.usdz", "Christmas_Lights.usdz", "christmas_bell.usdz"], id: \.self) { modelName in
            Button(action: {
                selectedModel = modelName
            }) {
                Text(modelName)
            }
        }
    }
}

struct ARModelUsdzViewer: View {
    @Binding var selectedModel: String?
    
    var body: some View {
        ARViewUsdzContainer(modelName: $selectedModel)
    }
}

struct ARViewUsdzContainer: UIViewRepresentable {
    @Binding var modelName: String?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config)
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelName = modelName {
             if let modelEntity = loadModel(named: modelName) {
               let anchorEntity = AnchorEntity(plane: .any)
               anchorEntity.addChild(modelEntity)
               uiView.scene.addAnchor(anchorEntity)
            }
        }
    }
    
    func loadModel(named modelName: String) -> ModelEntity? {
        if let entity = try? ModelEntity.load(named: modelName) as? ModelEntity {
            return entity
        } else {
            return nil
        }
    }

}
 
