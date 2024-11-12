//
//  ARFaceTrackingView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 19/09/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ARFaceTrackingView: View {
    @State private var arView = ARView()
    
    var body: some View {
        ARViewContainerView(arView: $arView)
            .edgesIgnoringSafeArea(.all)
    }
}

 
struct ARViewContainerView: UIViewControllerRepresentable {
    @Binding var arView: ARView
    
    func makeUIViewController(context: Context) -> CustomARViewController {
        let viewController = CustomARViewController()
        viewController.arView = arView
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: CustomARViewController, context: Context) {
        // No se necesita actualización en este momento
    }
}

class CustomARViewController: UIViewController, ARSessionDelegate {
    var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("La detección facial no es compatible con este dispositivo.")
        }
        
        let configuration = ARFaceTrackingConfiguration()
        arView?.session.run(configuration)
        
        arView?.session.delegate = self
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        // Implementa la lógica para seguir la cara del usuario y colocar un sombrero u objeto en la cabeza aquí.
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! GorroNavidad.loadEscena()
        arView.scene.anchors.append(boxAnchor)
 
  
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arView.session.pause()
    }
}

