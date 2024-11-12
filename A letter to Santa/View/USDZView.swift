//
//  USDZView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 18/09/23.
//

import SwiftUI
import RealityKit
import ARKit

struct USDZView: View {
    @State private var isARSessionRunning = false
   
    var body: some View {
        ZStack {
            ARViewContainerVIEW(isARSessionRunning: $isARSessionRunning)
                .edgesIgnoringSafeArea(.all)
           
            VStack {
                if !isARSessionRunning {
                    Text("Toque aquí para iniciar AR")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .onTapGesture {
                            isARSessionRunning = true
                        }
                }
            }
        }
    }
}

struct ARViewContainerVIEW: UIViewRepresentable {
    @Binding var isARSessionRunning: Bool
   
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.environment.sceneUnderstanding.options.insert(.physics)
        arView.session.delegate = context.coordinator
        return arView
    }
   
    func updateUIView(_ uiView: ARView, context: Context) {
        if isARSessionRunning {
            let usdzEntity = try? Entity.load(named: "Christmas_Lights.usdz")
            let anchorEntity = AnchorEntity(.plane(.any, classification: .any, minimumBounds: [0.2, 0.2]))
            anchorEntity.addChild(usdzEntity!)
            uiView.scene.addAnchor(anchorEntity)
        }
    }
   
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
   
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainerVIEW
       
        init(_ parent: ARViewContainerVIEW) {
            self.parent = parent
            super.init()
        }
       
        func session(_ session: ARSession, didFailWithError error: Error) {
            // Manejar errores de la sesión AR si es necesario
        }
       
        func sessionWasInterrupted(_ session: ARSession) {
            // Manejar interrupciones de la sesión AR si es necesario
        }
       
        func sessionInterruptionEnded(_ session: ARSession) {
            // Manejar el fin de las interrupciones de la sesión AR si es necesario
        }
    }
}
 
 
