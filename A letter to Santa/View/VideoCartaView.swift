//
//  VideoCartaView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 30/10/23.
//
import SwiftUI
import AVFoundation
import AVKit
import RealityKit
import ARKit
import Photos

struct VideoCartaView: View {
    @State private var isRecording = false
    @State private var videoURL: URL?
    @State private var recorder: AVAssetWriter?
    @State private var selectedHatIndex = 0
    @State private var selectedHat: ModelEntity?
    @State private var hatOptions: [String] = ["santasHatNueve", "santasHatNueve"]
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    var formattedElapsedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all) // Fondo blanco
 
                ARViewContainerFace(isRecording: $isRecording, selectedHatIndex: $selectedHatIndex, hatOptions: hatOptions)
                    .frame(width: 500, height: 500)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(20)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                if isRecording {
                                    Button(action: stopRecording) {
                                        Text("Detener")
                                    }
                                } else {
                                    Button(action: startRecording) {
                                        Text("Grabar")
                                    }
                                }
                            }
                        }
                    )
                
                if let videoURL = videoURL {
                    VideoPlayer(player: AVPlayer(url: videoURL))
                        .onAppear {
                            if !isRecording {
                                self.videoURL = nil
                            }
                        }
                }
                
                // Mueve el Picker debajo de ARViewContainerFace
                 Picker("Selecciona un sombrero", selection: $selectedHatIndex) {
                     ForEach(0 ..< hatOptions.count, id: \.self) { index in
                         Text(hatOptions[index])
                     }
                 }
                 .position(x: geometry.size.width / 2, y: geometry.size.height - 100)
                
                // Contador de tiempo
                Text(formattedElapsedTime)
                    .font(.title)
                    .foregroundColor(.red)
                    .position(x: 50, y: 50)
            }
        }
        .onAppear {
            selectedHat = loadHatModel(named: hatOptions[selectedHatIndex])
        }
    }
    
    func loadHatModel(named modelName: String) -> ModelEntity? {
        if let realityFileURL = Bundle.main.url(forResource: modelName, withExtension: "reality") {
            do {
                let realityFile = try Entity.load(contentsOf: realityFileURL)
                if let modelEntity = realityFile as? ModelEntity {
                    return modelEntity
                } else {
                    print("El archivo de Reality Composer no es un ModelEntity válido.")
                }
            } catch {
                print("Error al cargar el archivo de Reality Composer: \(error.localizedDescription)")
            }
        } else {
            print("No se encontró el archivo de Reality Composer: \(modelName)")
        }
        return nil
    }

    func startRecording() {
        // Comienza la grabación de video
        guard !isRecording else {
            return
        }

        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videoURL = documentDirectory.appendingPathComponent("myVideo.mp4")

        if fileManager.fileExists(atPath: videoURL.path) {
            try? fileManager.removeItem(at: videoURL)
        }

        do {
            // Configura el AVAssetWriter con la configuración de video
            recorder = try AVAssetWriter(outputURL: videoURL, fileType: .mp4)
            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: 1920,
                AVVideoHeightKey: 1080,
            ]
            let videoOutput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)

            if recorder?.canAdd(videoOutput) == true {
                recorder?.add(videoOutput)
            } else {
                print("No se pudo agregar la salida de video a AVAssetWriter.")
                return
            }

            // Inicia la grabación
            recorder?.startWriting()
            recorder?.startSession(atSourceTime: .zero)

            isRecording = true

            startTimer()

            // Actualiza videoURL
            self.videoURL = videoURL
            
        } catch {
            print("Error al iniciar la grabación: \(error.localizedDescription)")
        }
    }


    func stopRecording() {
        // Detén la grabación de video
        guard isRecording else {
            return
        }
        isRecording = false
        guard let recorder = recorder, recorder.status == .writing else {
            print("La grabación no se estaba realizando.")
            return
        }

        // Detén el contador de tiempo
        timer?.invalidate()

        recorder.finishWriting {
            print("Recorder Status: \(recorder.status.rawValue)")
            switch recorder.status {
            case .completed:
                print("VideoURL: \(self.videoURL)")
                if let videoURL = self.videoURL {
                    self.videoURL = videoURL
                    // Guardar el video en la galería después de detener la grabación
                    saveVideoToLibrary()
                }
            case .failed:
                if let error = recorder.error {
                    print("Error en la escritura del video: \(error.localizedDescription)")
                } else {
                    print("Error desconocido en la escritura del video")
                }
            default:
                print("Estado inesperado del AVAssetWriter: \(recorder.status.rawValue)")
            }
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }

    func saveVideoToLibrary() {
        // Solicitar autorización de fotos
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                // Puedes guardar el video en la galería
                if let videoURL = self.videoURL {
                    PHPhotoLibrary.shared().performChanges {
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                    } completionHandler: { success, error in
                        if success {
                            // Video guardado en la galería
                            print("Video guardado en la galería.")
                        } else if let error = error {
                            // Error al guardar el video
                            print("Error al guardar el video en la galería: \(error.localizedDescription)")
                        }
                    }
                }
            case .denied, .restricted:
                // El usuario denegó el acceso o está restringido
                print("El acceso a la galería de fotos fue denegado o está restringido.")
            default:
                // No pudiste obtener una respuesta autorizada
                print("No se pudo obtener una respuesta autorizada para acceder a la galería de fotos.")
            }
        }
    }
}


/*struct ARViewContainerFace: UIViewRepresentable {
    @Binding var isRecording: Bool
    @Binding var selectedHatIndex: Int
    var hatOptions: [String]

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Carga la escena de AR
        let arConfig = ARFaceTrackingConfiguration()
        arView.session.run(arConfig)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if isRecording {
            // Configura la captura de video en ARKit cuando se inicia la grabación
        } else {
            // Detén la captura de video en ARKit cuando se detiene la grabación
        }
        
        // Agrega el sombrero seleccionado a la vista AR
        if selectedHatIndex < hatOptions.count {
            if let modelEntity = loadHatModel(named: hatOptions[selectedHatIndex]) {
                let anchor = AnchorEntity()
                anchor.addChild(modelEntity)
                uiView.scene.addAnchor(anchor)
            }
        }
    }

    func loadHatModel(named modelName: String) -> ModelEntity? {
        if let realityFileURL = Bundle.main.url(forResource: modelName, withExtension: "reality") {
            do {
                let realityFile = try Entity.load(contentsOf: realityFileURL)
                if let modelEntity = realityFile as? ModelEntity {
                    return modelEntity
                } else {
                    print("El archivo de Reality Composer no es un ModelEntity válido.")
                }
            } catch {
                print("Error al cargar el archivo de Reality Composer: \(error.localizedDescription)")
            }
        } else {
            print("No se encontró el archivo de Reality Composer: \(modelName)")
        }
        return nil
    }
}*/
 
struct ARViewContainerFace: UIViewRepresentable {
    @Binding var isRecording: Bool
    @Binding var selectedHatIndex: Int
    var hatOptions: [String]
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        //let boxAnchor = try! Experience.loadBox()
        let faceScene = try! SantasHatNueve.loadEscena()
        arView.scene.anchors.append(faceScene)
        
        // Add the box anchor to the scene
        let arConfig = ARFaceTrackingConfiguration()
        arView.session.run(arConfig)
 
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
