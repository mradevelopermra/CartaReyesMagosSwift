//
//  HomeCamaraView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 13/09/23.
//

import SwiftUI
import RealityKit
import LinkPresentation
import StoreKit
import Combine
import ARKit
import FocusEntity

struct HomeCamaraView: View {
    
    //@EnvironmentObject private var store: Store
    @State private var showMenu = false
    @EnvironmentObject var settings : Settings
    
    @State private var isARSessionRunning = true // Controla si ARSession está en funcionamiento
    @State private var modelPosition = CGPoint(x: 0.5, y: 0.5) // Posición inicial del modelo en el centro de la pantalla

    
    var body: some View {
 
        ZStack(alignment: .bottom){
            /*Button(action: {
                    if let product = store.product(for: store.allBooks[0].id){
                        store.purchaseProduct(product: product)
                    }
  
                print("editar")

            }){
                Label(title: {
                    Text("Buy all post cards")
                }, icon: {
                    Image(systemName: "pencil")
                })
            }.padding()
             .frame(width: UIScreen.main.bounds.width - 30 )
            .backgroundStyle(Color.blue)
            .cornerRadius(0)
            .buttonStyle(.borderedProminent)
            .tint(Color(hex: 0x2d572c))*/
            
             //ARViewContainer()
            //ARViewContainerTres()
            ARViewContainerMenu()
            if settings.selectedModel == nil {
                ControlView(showMenu: $showMenu)
            }else {
                CameraView()
            }
 
 
        }.onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        
        /*ZStack(alignment: .leading){
 
            Spacer()
            Button {
              
                // (Placeholder): Take a snapshot
                ARViewContainer.arView.snapshot(saveToHDR: false) { (image) in
                  
                  // Compress the image
                  let compressedImage = UIImage(data: (image?.pngData())!)
                  // Save in the photo album
                  UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
                }
              
              } label: {
                Image(systemName: "camera")
                  .frame(width:60, height:60)
                  .font(.title)
                  .background(.white.opacity(0.75))
                  .cornerRadius(30)
                  .padding()
              }
 
        }*/
    }
    
 
}

/* struct ARViewContainer: UIViewRepresentable {
    static var arView: ARView!
    @EnvironmentObject var settings: Settings

    // Declaración de modelEntity
    var modelEntity: ModelEntity?
     
     

    func makeUIView(context: Context) -> CustomARView {
        // Configura ARKit para detectar tanto planos horizontales como verticales.
        let config = ARWorldTrackingConfiguration()
        
         config.planeDetection = [.horizontal, .vertical]
        ARViewContainer.arView = CustomARView(frame: .zero)
        ARViewContainer.arView.environment.sceneUnderstanding.options.insert(.physics)

        if let modelEntity = modelEntity { // Verifica si modelEntity no es nulo
            // Habilitar gestos de pellizco y estiramiento para escalar el modelo
            ARViewContainer.arView.installGestures([.scale], for: modelEntity)

            // Habilitar gestos de pan para mover el modelo
            ARViewContainer.arView.installGestures([.translation], for: modelEntity)
        }

        ARViewContainer.arView.session.run(config)

        settings.sceneObserver = ARViewContainer.arView.scene.subscribe(to: SceneEvents.Update.self, { event in
            sceneUpdate(arView: ARViewContainer.arView as! CustomARView)
        })
        return ARViewContainer.arView as! CustomARView
    }

    func updateUIView(_ uiView: CustomARView, context: Context) {
        // No se requiere implementación para esta función en este momento
    }

    func sceneUpdate(arView: CustomARView) {
        arView.focusEntity?.isEnabled = settings.selectedModel != nil
 

        
        if let confirmModel = settings.confirmedModel, let modelEntity = confirmModel.modelEntity {
            plane(modelEntity: modelEntity, arView: arView)
            settings.confirmedModel = nil
        }
    }

    func plane(modelEntity: ModelEntity, arView: ARView) {
        let clonedEntity = modelEntity.clone(recursive: true)
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .translation], for: clonedEntity)

        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        arView.scene.addAnchor(anchorEntity)
    }

    func saveImage() {
        
        // getting image from Canvas
        let image = CustomARView.Image()
 
        // saving to album
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
 
    }
} */
 
/*import SwiftUI
import ARKit
import RealityKit*/
 
struct ARViewContainerMenu: UIViewRepresentable {
     static var arView: ARView!
    @EnvironmentObject var settings : Settings
    // Declaración de modelEntity
    var modelEntity: ModelEntity?
    
    func makeUIView(context: Context) -> CustomARView {
        // Configura ARKit en modo worldTracking para permitir cualquier orientación de la cámara.
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical] // Detectar planos horizontales y verticales

        ARViewContainer.arView = CustomARView(frame: .zero)
        ARViewContainer.arView.environment.sceneUnderstanding.options.insert(.physics)

        if let modelEntity = modelEntity { // Verifica si modelEntity no es nulo
            // Habilitar gestos de pellizco y estiramiento para escalar el modelo
            ARViewContainer.arView.installGestures([.scale], for: modelEntity)

            // Habilitar gestos de pan para mover el modelo
            ARViewContainer.arView.installGestures([.translation], for: modelEntity)
        }

        ARViewContainer.arView.session.run(config)

        settings.sceneObserver = ARViewContainer.arView.scene.subscribe(to: SceneEvents.Update.self, { event in
            sceneUpdate(arView: ARViewContainer.arView as! CustomARView)
        })
        return ARViewContainer.arView as! CustomARView
    }

    /*func makeUIView(context: Context) -> CustomARView {
         //ARViewContainer.arView = ARView(frame: .zero)
        ARViewContainer.arView = CustomARView(frame: .zero)
        
        settings.sceneObserver = ARViewContainer.arView.scene.subscribe(to: SceneEvents.Update.self, { event in
            sceneUpdate(arView: ARViewContainer.arView as! CustomARView )
        })
        return ARViewContainer.arView as! CustomARView
    }*/
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
    
    }
    
    func sceneUpdate(arView: CustomARView){
        arView.focusEntity?.isEnabled = settings.selectedModel != nil
        if let confirmModel = settings.confirmedModel, let modelEntity = confirmModel.modelEntity {
            plane(modelEntity: modelEntity, arView: arView)
            settings.confirmedModel = nil
             saveImage()
        }
    }
    
    /*func plane(modelEntity: ModelEntity, arView : ARView){
        let clonedEntity = modelEntity.clone(recursive: true)
        
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .translation], for: clonedEntity)
        
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        arView.scene.addAnchor(anchorEntity)
    }*/
    
    func plane(modelEntity: ModelEntity, arView : ARView){
        let clonedEntity = modelEntity.clone(recursive: true)
        
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .translation], for: clonedEntity)
        
        let anchorEntity = AnchorEntity(world: .zero)
        anchorEntity.addChild(clonedEntity)
        arView.scene.addAnchor(anchorEntity)
    }
    
    func placeModelInCenter(modelEntity: ModelEntity, arView: ARView) {
        let clonedEntity = modelEntity.clone(recursive: true)
        
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .translation], for: clonedEntity)
        
        // Obtiene la matriz de transformación de la cámara
        let cameraTransform = arView.cameraTransform
        
        // Extrae la posición de la cámara de la matriz de transformación
        let cameraPosition = cameraTransform.translation
        
        // Obtiene las dimensiones de la pantalla
        let screenSize = arView.bounds.size
        
        // Calcula la posición en el centro de la pantalla en coordenadas 3D
        let centerPosition = cameraPosition
        
        // Calcula la escala para que el objeto tenga la mitad del tamaño de la pantalla
        let scaleFactor: Float = 0.5 * min(Float(screenSize.width), Float(screenSize.height))
        
        // Aplica la escala al objeto
        clonedEntity.scale = SIMD3<Float>(repeating: scaleFactor)
        
        // Mueve el objeto al centro de la pantalla
        clonedEntity.position = centerPosition
        
        let anchorEntity = AnchorEntity(world: centerPosition)
        anchorEntity.addChild(clonedEntity)
        arView.scene.addAnchor(anchorEntity)
    }
    
    
    func saveImage() {
        
        // getting image from Canvas
        let image = CustomARView.Image()
 
 
        // saving to album
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
 
    }

}
 


 
///Funciona
 struct ARViewContainer: UIViewRepresentable {
    static var arView: ARView!
    @EnvironmentObject var settings: Settings

    // Declaración de modelEntity
    var modelEntity: ModelEntity?

    func makeUIView(context: Context) -> CustomARView {
        // Configura ARKit en modo worldTracking para permitir cualquier orientación de la cámara.
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical] // Detectar planos horizontales y verticales

        ARViewContainer.arView = CustomARView(frame: .zero)
        ARViewContainer.arView.environment.sceneUnderstanding.options.insert(.physics)

        if let modelEntity = modelEntity { // Verifica si modelEntity no es nulo
            // Habilitar gestos de pellizco y estiramiento para escalar el modelo
            ARViewContainer.arView.installGestures([.scale], for: modelEntity)

            // Habilitar gestos de pan para mover el modelo
            ARViewContainer.arView.installGestures([.translation], for: modelEntity)
        }

        ARViewContainer.arView.session.run(config)

        settings.sceneObserver = ARViewContainer.arView.scene.subscribe(to: SceneEvents.Update.self, { event in
            sceneUpdate(arView: ARViewContainer.arView as! CustomARView)
        })
        return ARViewContainer.arView as! CustomARView
    }

    func updateUIView(_ uiView: CustomARView, context: Context) {
        // No se requiere implementación para esta función en este momento.
    }

    func sceneUpdate(arView: CustomARView) {
        arView.focusEntity?.isEnabled = settings.selectedModel != nil

        if let confirmModel = settings.confirmedModel, let modelEntity = confirmModel.modelEntity {
            placeModelInCenter(modelEntity: modelEntity, arView: arView)
            if isModelOnScreen(model: confirmModel.modelEntity!, arView: arView) {
                print("El modelo esta en la pantalla.")
               
                // Realiza acciones específicas para planos verticales, si es necesario.
            } else {
                print("El modelo NO esta en la pantalla.")
                
                // Realiza acciones específicas para planos horizontales, si es necesario.
            }
            settings.confirmedModel = nil
        }
    }
     
     func placeModelInCenter(modelEntity: ModelEntity, arView: ARView) {
         let clonedEntity = modelEntity.clone(recursive: true)
         
         clonedEntity.generateCollisionShapes(recursive: true)
         arView.installGestures([.rotation, .translation], for: clonedEntity)
         
         // Obtiene la matriz de transformación de la cámara
         let cameraTransform = arView.cameraTransform
         
         // Extrae la posición de la cámara de la matriz de transformación
         let cameraPosition = cameraTransform.translation
         
         // Obtiene las dimensiones de la pantalla
         let screenSize = arView.bounds.size
         
         // Calcula la posición en el centro de la pantalla en coordenadas 3D
         let centerPosition = cameraPosition
         
         // Calcula la escala para que el objeto tenga la mitad del tamaño de la pantalla
         let scaleFactor: Float = 0.5 * min(Float(screenSize.width), Float(screenSize.height))
         
         // Aplica la escala al objeto
         clonedEntity.scale = SIMD3<Float>(repeating: scaleFactor)
         
         // Mueve el objeto al centro de la pantalla
         clonedEntity.position = centerPosition
         
         let anchorEntity = AnchorEntity(world: centerPosition)
         anchorEntity.addChild(clonedEntity)
         arView.scene.addAnchor(anchorEntity)
     }

    
    func plane(modelEntity: ModelEntity, arView : ARView){
        let clonedEntity = modelEntity.clone(recursive: true)
        
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .translation], for: clonedEntity)
        
        let anchorEntity = AnchorEntity(world: .zero)
        anchorEntity.addChild(clonedEntity)
        arView.scene.addAnchor(anchorEntity)
    }
    
 
 




  /*func placeModel(modelEntity: ModelEntity, arView: ARView) {
        let clonedEntity = modelEntity.clone(recursive: true)
        clonedEntity.generateCollisionShapes(recursive: true)

        // Habilita el raycasting para colocar objetos en cualquier lugar
        let raycastResult = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .any)

        if let firstResult = raycastResult.first {
            let anchorEntity = AnchorEntity(raycastResult: firstResult)
            anchorEntity.addChild(clonedEntity)
            arView.installGestures([.rotation, .translation], for: clonedEntity)
            arView.scene.addAnchor(anchorEntity)

            // Obtén la matriz de transformación del resultado del raycasting
            let worldTransform = firstResult.worldTransform

            // Extrae la dirección "arriba" de la matriz de transformación
            let upDirection = worldTransform.columns.1

            // Verifica la orientación del plano
            let isVertical = abs(upDirection.y) > abs(upDirection.x) && abs(upDirection.y) > abs(upDirection.z)

            if isVertical {
                print("El modelo se colocó en un plano vertical.")
                // Realiza acciones específicas para planos verticales, si es necesario.
            } else {
                print("El modelo se colocó en un plano horizontal.")
                // Realiza acciones específicas para planos horizontales, si es necesario.
            }
  
        }
    }*/
    
    
    func isModelOnScreen(model: ModelEntity, arView: ARView) -> Bool {
        // Obtiene la posición del modelo en el mundo
        let modelPosition = model.transform.translation

        // Obtiene las dimensiones de la pantalla en puntos (coordenadas 2D)
        let screenSize = arView.frame.size
        let screenBounds = CGRect(origin: .zero, size: screenSize)

        // Convierte la posición del modelo en coordenadas 2D
        let modelScreenPoint = arView.project(modelPosition)

        // Verifica si la posición proyectada del modelo está dentro de los límites de la pantalla
        return screenBounds.contains(CGPoint(x: Double(modelScreenPoint!.x), y: Double(modelScreenPoint!.y)))
    }
 

    func saveImage() {
        // Obtiene la imagen desde la vista AR
        let image = CustomARView.Image()

        // Guarda la imagen en el álbum
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}






/*struct ARViewContainer: UIViewRepresentable {
    static var arView: ARView!
    @EnvironmentObject var settings: Settings
    var modelEntity: ModelEntity?

    func makeUIView(context: Context) -> CustomARView {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        ARViewContainer.arView = CustomARView(frame: .zero)
        ARViewContainer.arView.environment.sceneUnderstanding.options.insert(.physics)

        if let modelEntity = modelEntity {
            ARViewContainer.arView.installGestures([.scale, .translation], for: modelEntity)
        }

        ARViewContainer.arView.session.run(config)

        settings.sceneObserver = ARViewContainer.arView.scene.subscribe(to: SceneEvents.Update.self, { event in
            sceneUpdate(arView: ARViewContainer.arView as! CustomARView, settings: settings, modelEntity: modelEntity)
        })
        return ARViewContainer.arView as! CustomARView
    }

    func updateUIView(_ uiView: CustomARView, context: Context) {
        // No se requiere implementación para esta función en este momento.
    }

    func sceneUpdate(arView: CustomARView, settings: Settings, modelEntity: ModelEntity?) {
        arView.focusEntity?.isEnabled = settings.selectedModel != nil

        if let confirmModel = settings.confirmedModel, let modelEntity = confirmModel.modelEntity {
            placeModel(modelEntity: modelEntity, arView: arView)
            settings.confirmedModel = nil
        }
    }

 
    
    func placeModel(modelEntity: ModelEntity, arView: ARView) {
        let clonedEntity = modelEntity.clone(recursive: true)
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .translation], for: clonedEntity)

        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        arView.scene.addAnchor(anchorEntity)
    }


    func saveImage() {
        let image = CustomARView.Image()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}*/





 
 
 /*struct ARViewContainer: UIViewRepresentable {
     static var arView: ARView!
    @EnvironmentObject var settings : Settings
 
        // Declaración de modelEntity
        var modelEntity: ModelEntity?
 

    
    func makeUIView(context: Context) -> CustomARView {
        // Configura ARKit para detectar tanto planos horizontales como verticales.
       let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
         //ARViewContainer.arView = ARView(frame: .zero)
        ARViewContainer.arView = CustomARView(frame: .zero)
        ARViewContainer.arView.environment.sceneUnderstanding.options.insert(.physics)
        
        if let modelEntity = modelEntity {
            // Habilitar gestos de pellizco y estiramiento para escalar el modelo
            ARViewContainer.arView.installGestures([.scale], for: modelEntity)
            
            // Habilitar gestos de pan para mover el modelo
            ARViewContainer.arView.installGestures([.translation], for: modelEntity)
        }
 
        ARViewContainer.arView.session.run(config)
        
        settings.sceneObserver = ARViewContainer.arView.scene.subscribe(to: SceneEvents.Update.self, { event in
            sceneUpdate(arView: ARViewContainer.arView as! CustomARView )
        })
        return ARViewContainer.arView as! CustomARView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
 
    }
    
 
    
     func sceneUpdate(arView: CustomARView){
        arView.focusEntity?.isEnabled = settings.selectedModel != nil
         
        if let confirmModel = settings.confirmedModel, let modelEntity = confirmModel.modelEntity {
            plane(modelEntity: modelEntity, arView: arView)
            settings.confirmedModel = nil
 
        }
         
 
    }
    
    func plane(modelEntity: ModelEntity, arView : ARView){
        let clonedEntity = modelEntity.clone(recursive: true)
 
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .translation], for: clonedEntity)
        
         let anchorEntity = AnchorEntity(plane: .any)
 
        anchorEntity.addChild(clonedEntity)
        arView.scene.addAnchor(anchorEntity)
 
    }
 
    
    func saveImage() {
        
        // getting image from Canvas
        let image = CustomARView.Image()
 
 
        // saving to album
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
 
    }
    
    

}*/




 
 

struct ARViewContainerVIEWHome: UIViewRepresentable {
    @Binding var isARSessionRunning: Bool
    static var arView: ARView!
    @EnvironmentObject var settings : Settings
   
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
        var parent: ARViewContainerVIEWHome
       
        init(_ parent: ARViewContainerVIEWHome) {
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
 


