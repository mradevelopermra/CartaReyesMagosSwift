//
//  ARModelView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 22/12/23.
//
/*import SwiftUI
import RealityKit
import AVFoundation
import ARKit
import UIKit
import Photos

struct ARModelView: View {
    @State private var isCapturing = false
    @State private var capturedImage: UIImage?
    @State private var textInput: String = ""
    @State private var isEditing = false
    private let photoProcessor = PhotoCaptureProcessor()

    var body: some View {
        ZStack {
            ARViewContainerFaceDos()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                if let capturedImage = capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            VStack {
                                Text("Add Text")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                TextField("Enter Text", text: $textInput)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .opacity(isEditing ? 1 : 0)
                            }
                        )
                        .onTapGesture {
                            isEditing.toggle()
                        }
                        .onAppear {
                            addTextToImage()
                        }
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        isCapturing.toggle()
                        if isCapturing {
                            photoProcessor.captureImage { image in
                                DispatchQueue.main.async {
                                    self.capturedImage = image
                                }
                            }
                        }
                    }) {
                        Image(systemName: isCapturing ? "camera.fill" : "camera")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .padding(.trailing)
                }
            }
        }
        .onAppear {
            isCapturing = true
        }
        .onDisappear {
            isCapturing = false
        }
    }
    
    func addTextToImage() {
        guard let capturedImage = capturedImage else { return }
        
        UIGraphicsBeginImageContextWithOptions(capturedImage.size, false, 0)
        let rect = CGRect(x: 0, y: 0, width: capturedImage.size.width, height: capturedImage.size.height)
        capturedImage.draw(in: rect)
        
        let textRect = CGRect(x: 20, y: 20, width: capturedImage.size.width - 40, height: 100)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 40),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ]
        textInput.draw(in: textRect, withAttributes: attributes)
        
        self.capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

struct ARViewContainerFaceDos: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let faceScene = try! SantasHatNueve.loadEscena()
        arView.scene.anchors.append(faceScene)
        
        let arConfig = ARFaceTrackingConfiguration()
        arView.session.run(arConfig)
 
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
 

class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?
    private var photoCaptureCompletion: ((UIImage?) -> Void)?
    
    func captureImage(completion: @escaping (UIImage?) -> Void) {
        self.photoCaptureCompletion = completion
        
        // Crear sesión de captura
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            completion(nil)
            return
        }
        
        self.captureSession = AVCaptureSession()
        self.captureSession?.addInput(input)
        
        // Configurar la salida para la captura de fotos
        self.photoOutput = AVCapturePhotoOutput()
        self.photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if let photoOutput = self.photoOutput, self.captureSession?.canAddOutput(photoOutput) ?? false {
            self.captureSession?.addOutput(photoOutput)
            
            // Realizar la captura de la foto
            let photoSettings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        } else {
            completion(nil)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(),
           let image = UIImage(data: imageData) {
            // Guardar la imagen en la biblioteca de fotos
            self.saveImageToPhotoLibrary(image)
            self.photoCaptureCompletion?(image)
        } else {
            self.photoCaptureCompletion?(nil)
        }
    }
    
    func saveImageToPhotoLibrary(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if let error = error {
                    print("Error al guardar la imagen en el álbum de fotos: \(error.localizedDescription)")
                } else {
                    print("La imagen se ha guardado correctamente en el álbum de fotos.")
                }
            }
        }
    }
}*/
import SwiftUI
import RealityKit
import AVFoundation
import Photos
import ARKit

struct ARModelView: View {
    let modelName: String
    let onClose: () -> Void
    @State private var isCapturing = false
    @State private var capturedImage: UIImage?
    private let photoProcessor = PhotoCaptureProcessor()
    @State private var selectedModel: String = "cute_crown" // Modelo predeterminado
    @ObservedObject var arViewModel = ARViewModel()
    @State private var showAlert = false
       @State private var alertMessage = ""
    
    init(modelName: String, onClose: @escaping () -> Void) {
            self.modelName = modelName
            self.onClose = onClose
            _selectedModel = State(initialValue: modelName)
        }
 
    var body: some View {
        ZStack {
            ARViewContainerFaceDos(capturedImage: $capturedImage, isCapturing: $isCapturing, selectedModelName: $selectedModel, arViewModel: arViewModel)
                            .edgesIgnoringSafeArea(.all)
            // Aquí puedes mostrar el nombre del modelo seleccionado
                       VStack {
                           Spacer()
                           /*Text("Modelo seleccionado: \(selectedModel)")
                               .foregroundColor(.white)
                               .padding()*/
                           // Otros elementos de la interfaz de usuario si es necesario
                           Spacer()
                           Button(action: {
                               onClose()
                               showAlert = true
                           }) {
                               Text("Cerrar")
                                   .foregroundColor(.white)
                                   .padding()
                                   .background(Color.blue)
                                   .cornerRadius(8)
                           }
                           .padding()
                       }
                       
            VStack {
                Spacer()
                if let capturedImage = capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
 
                Button(action: {
                    DispatchQueue.main.async {
                        ARViewContainerFaceDos.captureImageAndSave()
                        showAlert = true
                    }
                }) {
                    Text("Capture and Save")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                        Alert(title: Text("La imagen se ha guardado correctamente en el álbum de fotos."), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
            .alignmentGuide(.bottom) { _ in
                UIScreen.main.bounds.height / 2
            }
            
            
            // Imágenes a los lados izquierdo y derecho
                      /*HStack {
                          Spacer()
                          Button(action: {
                              DispatchQueue.main.async {
                                  print("Cambiar a cute_crown")
                                  arViewModel.selectedModelName = "cute_crown"
                              }
                          }) {
                              Image(systemName: "camera")
                                  .resizable()
                                  .frame(width: 50, height: 50)
                                  .padding()
                          }

                          Spacer()
                          Button(action: {
                              DispatchQueue.main.async {
                                  print("Cambiar a cute_crown")
                                  arViewModel.selectedModelName = "coronaAzul"
                              }
                          }) {
                              Image(systemName: "photo")
                                  .resizable()
                                  .frame(width: 50, height: 50)
                                  .padding()
                          }

                          Spacer()
                      }*/
 
        }
    }
}



struct ModelIcon: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 80, height: 50)
            .padding()
            .onTapGesture {
                action()
            }
    }
}

class ARViewModel: ObservableObject {
    @Published var selectedModelName: String = "coronaAzul"
 
    func loadSceneForModel(_ modelName: String) -> Entity {
        switch modelName {
        case "tiara":
            return try! Tiaramorada.loadEscena()
        case "sombrero_bruja_morado":
            return try! Sombrerobruja.loadEscena()
        case "gorro_santa_roblox":
            return try! Gorroroblox.loadEscena()
        case "gorro_luces":
            return try! SantasHatTrece.loadEscena()
        case "gorro_cuadrado_orejas":
            return try! Gorroorejas.loadEscena()
        case "gorro_bolita_santa":
            return try! Gorrobolitas.loadEscena()
        case "cute_crown":
            return try! CuteCrown.loadEscena()
        case "corona_rosa":
            return try! Coronaguinda.loadEscena()
        case "corona_p_rojas":
            return try! CoronaPRojas.loadEscena()
        case "corona_colores":
            return try! Coronarosa.loadEscena()
        case "corona_bowsete":
            return try! Coronabowsete.loadEscena()
        case "corona_azul":
            return try! CoronaAzul.loadEscena()
        default:
            return try! SantasHatCatorce.loadEscena()
            //fatalError("Modelo no reconocido")
        }
    }
}
 
struct ARViewContainerFaceDos: UIViewRepresentable {
    @Binding var capturedImage: UIImage?
    @Binding var isCapturing: Bool
    @Binding var selectedModelName: String
    @ObservedObject var arViewModel: ARViewModel

    func makeUIView(context: Context) -> ARView {
        print("makeUIView llamado. Modelo actual: \(selectedModelName)")
        let arView = ARView(frame: .zero)
        let faceScene = arViewModel.loadSceneForModel(selectedModelName)
        let arAnchor = AnchorEntity(world: [0, 0, -1])
        arAnchor.addChild(faceScene)
        arView.scene.addAnchor(arAnchor)
        let arConfig = ARFaceTrackingConfiguration()
        arConfig.worldAlignment = .camera
        arView.session.run(arConfig)
        return arView
    }


    func updateUIView(_ uiView: ARView, context: Context) {
        print("updateUIView llamado. Nuevo modelo: \(selectedModelName)")
        updateScene(for: uiView, modelName: selectedModelName)
    }


    
    private func updateScene(for arView: ARView, modelName: String) {
        let scene = arViewModel.loadSceneForModel(modelName) // Usar arViewModel directamente
        let anchor = AnchorEntity(world: .zero)
        anchor.addChild(scene)
        arView.scene.anchors.removeAll()
        arView.scene.anchors.append(anchor)
    }


     func loadSceneForModel(_ modelName: String) -> Entity {
           switch modelName {
           case "coronaAzul":
               return try! CoronaAzul.loadEscena()
           case "cute_crown":
               return try! CuteCrown.loadEscena()
           // Agrega más casos según sea necesario para otros modelos
           default:
               fatalError("Modelo no reconocido")
           }
       } 

    static func captureImageAndSave() {
        guard let mainWindow = UIApplication.shared.windows.first,
              let arView = findARView(in: mainWindow) else {
            print("No se pudo encontrar ARView")
            return
        }
        
        let screenSize = UIScreen.main.bounds.size
        let scale: CGFloat = 2.0 // Ajusta el factor de escala según sea necesario
        let captureWidth = Int(screenSize.width * scale)
        let captureHeight = Int(screenSize.height * scale)

        arView.snapshot(saveToHDR: false) { image in
            if let image = image {
                // Redimensiona la imagen capturada con un factor de escala mayor
                let resizedImage = image.resized(to: CGSize(width: captureWidth, height: captureHeight))

                // La captura de la imagen fue exitosa
                PhotoCaptureProcessor().saveImageToPhotoLibrary(resizedImage)
                PhotoCaptureProcessor().saveImage(resizedImage)
            } else {
                // Hubo un error al capturar la imagen
                print("Error al capturar la imagen.")
            }
        }

    }

    static func findARView(in view: UIView) -> ARView? {
        // Buscar ARView en la vista actual
        if let arView = view as? ARView {
            return arView
        }
        
        // Recorrer las subvistas para encontrar ARView
        for subview in view.subviews {
            if let arView = findARView(in: subview) {
                return arView
            }
        }
        
        // No se encontró ARView en ninguna subvista
        return nil
    }
}

// Protocolo privado para limitar el alcance de la extensión de UIImage
private protocol ARViewContainerFaceDosCompatible {}

// Extensión del protocolo para agregar la funcionalidad deseada
extension ARViewContainerFaceDos {
    func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


// Conformidad de la estructura a este protocolo para activar la extensión
extension ARViewContainerFaceDos: ARViewContainerFaceDosCompatible {}
 
class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    var completion: ((UIImage?) -> Void)?

    func captureImage(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
 
        DispatchQueue.global(qos: .background).async {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                print("No se pudo acceder a la cámara frontal.")
                completion(nil)
                return
            }

            do {
                let input = try AVCaptureDeviceInput(device: device)
                let captureSession = AVCaptureSession()

                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                } else {
                    print("No se pudo agregar la entrada de la cámara.")
                    completion(nil)
                    return
                }
                
                // Desactivar el ajuste automático de HDR
                         do {
                             try input.device.lockForConfiguration()
                             input.device.automaticallyAdjustsVideoHDREnabled = false
                             input.device.unlockForConfiguration()
                         } catch {
                             print("Error al configurar la captura de fotos: \(error.localizedDescription)")
                             completion(nil)
                         }

                let output = AVCapturePhotoOutput()
                if captureSession.canAddOutput(output) {
                    captureSession.addOutput(output)
                    captureSession.startRunning()
                    print("Cámara frontal iniciada")
                } else {
                    print("No se pudo agregar la salida de la cámara.")
                    completion(nil)
                    return
                }

                let settings = AVCapturePhotoSettings()
                output.capturePhoto(with: settings, delegate: self)
            } catch {
                print("Error al configurar la captura de fotos: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("Entró a la función photoOutput")
        if let error = error {
            print("Error en la captura de fotos: \(error.localizedDescription)")
            completion?(nil)
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("No se pudo convertir los datos de imagen a UIImage")
            completion?(nil)
            return
        }

        DispatchQueue.main.async {
            print("Foto capturada exitosamente")
            self.completion?(image)
            self.saveImageToPhotoLibrary(image)
            //self.saveImage(image)
        }
    }


    func saveImageToPhotoLibrary(_ image: UIImage) {
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("Permisos insuficientes para guardar en el álbum de fotos.")
                return
            }

            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if let error = error {
                                   print("Error al guardar la imagen en el álbum de fotos: \(error.localizedDescription)")
                                   // Muestra una alerta en caso de error
                    /*self.showAlert(message: "Error al guardar la imagen en el álbum de fotos: \(error.localizedDescription)")*/
                               } else {
                                   print("La imagen se ha guardado correctamente en el álbum de fotos.")
                                   // Muestra una alerta cuando se guarda correctamente
                    /*self.showAlert(message: "La imagen se ha guardado correctamente en el álbum de fotos.")*/
                               }
            }
        }
    }
 
    func showAlert(message: String) {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("No se puede acceder al controlador de vista raíz.")
            return
        }
        
        // Verificar si ya hay una alerta presentada
        if let _ = rootViewController.presentedViewController as? UIAlertController {
            print("Ya hay una alerta presentada.")
            return
        }

        // Si no hay una alerta presentada, mostramos la nueva alerta
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Asegurarse de que haya al menos una ventana visible
        guard let visibleWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            print("No hay una ventana visible para mostrar la alerta.")
            return
        }
        
        // Mostrar la alerta en la ventana visible
        visibleWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }



    func saveImage(_ image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            // Manejar el error si no se puede acceder al directorio de documentos
            return
        }
        
        let tarjetasDirectory = documentsDirectory.appendingPathComponent("Tarjetas")
        
        if !FileManager.default.fileExists(atPath: tarjetasDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: tarjetasDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                // Manejar el error si no se puede crear la carpeta "Tarjetas"
                return
            }
        }
        
        let imageURL = tarjetasDirectory.appendingPathComponent("nombre_de_la_imagen.jpg")
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            do {
                try imageData.write(to: imageURL)
                print("Imagen guardada con éxito en \(imageURL.path)")
            } catch {
                // Manejar el error si no se puede guardar la imagen
                return
            }
        }
    }


}
