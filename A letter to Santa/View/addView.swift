//
//  addView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 17/08/23.
//

import SwiftUI
import PencilKit
import LinkPresentation
 
import Combine

class ImageBackground: ObservableObject {
    @Published var backgroundImage: UIImage?

        init() {
            // Inicializa la imagen de fondo con "fondo_carta_santa_cinco"
            self.backgroundImage = UIImage(named: "tarjeta_reyes_magos_cinco")
        }
}

struct addView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var model: ViewModel
    @State var options = ["Este año, me he portado" , "Muy bien", "A veces no tan bien"] // 1
    @State var selectedItem = "Muy bien"
    @State private var showingAlert = false
    @State var mensaje = "Información"
    @Environment(\.managedObjectContext) var context
    
    //Vatiabls para dibujar
     @State var canvas = PKCanvasView()
    
    @State var isdraw = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pencil
    @State var colorPicker = false
    
    @State private var rect: CGRect = .zero
    @State private var uiImage: UIImage? = nil
    @State private var showShareSheet = false
    @Environment(\.undoManager) private var undoManager
    @State private var showingAlertSave = false
    @State private var selectedOption = 0
    //Variables y funciones para el dibujo
    @State private var finalImage: UIImage?
    @State private var isImagePickerPresented = false
     @State private var selectedImage: String! // Almacena el nombre de la imagen seleccionada
    @State private var backgroundImage: UIImage?

    var availableImages: [String] = ["tarjeta_reyes_magos_cinco", "tarjeta_reyes_magos_seis", "tarjeta_reyes_magos_siete", "tarjeta_reyes_magos_ocho", "tarjeta_reyes_magos_nueve", "tarjeta_reyes_magos_diez", "tarjeta_reyes_magos_once", "tarjeta_reyes_magos_doce" ]
 
    @StateObject private var imageBackground = ImageBackground()
    @State private var selectedImageName: String = "tarjeta_reyes_magos_cinco"
    
    @EnvironmentObject private var store: Store
    @State public var selectedImageGaleria: UIImage? = nil
    let imagePickerDelegate = ImagePickerDelegate()
 
    func saveImage(){
        let image = textToImage(drawText: "\n\n\n\nQueridos reyes magos. \nEste año, Me he portado: \n" + model.sePorto + "\nAsi que, Me gustaria: \n"
                                + model.opcionUno + "\n"
                                + model.opcionDos + "\n"
                                + model.opcionTres + "\n"
                                + "\n"
                                + "\n"
                                + "\n"
                                + "Con cariño " + model.nombreNino, inImage: canvas.drawing.image(from: canvas.drawing.bounds, scale: 1), atPoint: CGPointMake(1, 1))
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func saveImageConFondo() {
        // Crea una imagen de fondo personalizada
        let backgroundImage = UIImage(named: "fondo_carta_reyes_magos_dos") // Reemplaza con el nombre de tu imagen de fondo
        
        // Asegúrate de que la imagen de fondo se haya cargado correctamente
        guard let background = backgroundImage else {
            print("Error al cargar la imagen de fondo.")
            return
        }
        
        // Crea un contexto gráfico con el tamaño de la imagen de fondo
        UIGraphicsBeginImageContextWithOptions(background.size, false, 0.0)
        
        // Dibuja la imagen de fondo en el contexto gráfico
        background.draw(in: CGRect(origin: .zero, size: background.size))
        
        // Configura las propiedades del texto
        let text = "\n\n\n\nDear our lovely Santa Claus. \nIn 2023, I have been: \n" + model.sePorto + "\nFor this year, I would like \n"
            + model.opcionUno + "\n"
            + model.opcionDos + "\n"
            + model.opcionTres + "\n"
            + "\n"
            + "\n"
            + "\n"
            + "All my love " + model.nombreNino
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20.0),
            .foregroundColor: UIColor.black,
            .paragraphStyle: textStyle
        ]
        
        // Calcula el tamaño necesario para el texto
        let textSize = text.size(withAttributes: attributes)
        
        // Dibuja el texto en el contexto gráfico centrado
        let textRect = CGRect(
            x: (background.size.width - textSize.width) / 2,
            y: (background.size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: textRect, withAttributes: attributes)
        
        // Extrae la imagen combinada del contexto gráfico
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // Finaliza el contexto gráfico
        UIGraphicsEndImageContext()
        
        // Guarda la imagen combinada en el álbum de fotos
        if let finalImage = combinedImage {
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            print("Imagen guardada con texto centrado.")
        } else {
            print("Error al combinar la imagen con el texto.")
        }
    }
    
    func saveImageFondoFinal() {
        // Carga la imagen de fondo
        guard let backgroundImage = UIImage(named: "fondo_carta_santa_cinco") else {
            print("Error al cargar la imagen de fondo.")
            return
        }
        
        // Renderiza el contenido del canvas en una imagen
        let canvasImage = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        
        // Configura el tamaño de la imagen resultante como el tamaño de la imagen de fondo
        let imageSize = backgroundImage.size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        
        // Dibuja la imagen de fondo
        backgroundImage.draw(in: CGRect(origin: .zero, size: imageSize))
        
        // Dibuja el contenido del canvas (dibujo del usuario)
        canvasImage.draw(in: CGRect(origin: .zero, size: imageSize))
        
        // Configura las propiedades del texto
        let text = "\n\n\n\nDear our lovely Santa Claus. \nIn 2023, I have been: \n" + model.sePorto + "\nFor this year, I would like \n"
            + model.opcionUno + "\n"
            + model.opcionDos + "\n"
            + model.opcionTres + "\n"
            + "\n"
            + "\n"
            + "\n"
            + "All my love " + model.nombreNino
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20.0),
            .foregroundColor: UIColor.black,
            .paragraphStyle: textStyle
        ]
        
        // Calcula el tamaño necesario para el texto
        let textSize = text.size(withAttributes: attributes)
        
        // Dibuja el texto en el contexto gráfico centrado
        let textRect = CGRect(
            x: (imageSize.width - textSize.width) / 2,
            y: (imageSize.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: textRect, withAttributes: attributes)
        
        // Extrae la imagen combinada del contexto gráfico
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // Finaliza el contexto gráfico
        UIGraphicsEndImageContext()
        
        // Guarda la imagen combinada en el álbum de fotos
        if let finalImage = combinedImage {
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            print("Imagen guardada con texto centrado y contenido del canvas.")
            
            ShareSheet(photo: finalImage)
            
            
        } else {
            print("Error al combinar la imagen con el texto y el contenido del canvas.")
        }
    }
 
    /*func saveImageFondoFinalColorDinamico(completion: @escaping (UIImage?) -> Void) {
        // Accede a la imagen de fondo seleccionada en imageBackground
        guard let backgroundImage = imageBackground.backgroundImage else {
            print("Error: No se ha seleccionado una imagen de fondo.")
            completion(nil)
            return
        }
        
        print("Ya cambio la imagen.")

        // Renderiza el contenido del canvas en una imagen
        let canvasImage = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)

        // Configura el tamaño de la imagen resultante como el tamaño de la imagen de fondo
        let imageSize = backgroundImage.size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)

        // Dibuja la imagen de fondo
        backgroundImage.draw(in: CGRect(origin: .zero, size: imageSize))

        // Configura las propiedades del texto
        let fullText = "\n\n\n\n\n\n\n\nQueridos reyes magos. \nEste año, Me he portado: \n" + model.sePorto + "\nAsi que, Me gustaria: \n"
        + model.opcionUno + "\n"
        + model.opcionDos + "\n"
        + model.opcionTres + "\n"
        + "\n"
        + "\n"
        + "\n"
        + "Con cariño " + model.nombreNino

        // Divide el texto en líneas
        let lines = fullText.components(separatedBy: "\n")

        // Define los colores que deseas aplicar a cada línea (puedes cambiarlos según tus preferencias)
        let lineColors: [UIColor] = [
            .red, .green, .blue, .orange, .purple, .yellow, .cyan, .magenta, .brown
        ]

        // Calcula el tamaño necesario para el texto y dibújalo
        var yOffset: CGFloat = 0.0
        for (index, line) in lines.enumerated() {
            let color = lineColors[index % lineColors.count]
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20.0),
                .foregroundColor: color,
                .paragraphStyle: NSMutableParagraphStyle()
            ]
            let textSize = line.size(withAttributes: attributes)

            // Dibuja el texto en el contexto gráfico con el color correspondiente
            let textRect = CGRect(
                x: (imageSize.width - textSize.width) / 2,
                y: yOffset,
                width: textSize.width,
                height: textSize.height
            )
            line.draw(in: textRect, withAttributes: attributes)

            // Incrementa la posición vertical para la siguiente línea
            yOffset += textSize.height
        }

        // Dibuja el contenido del canvas (dibujo del usuario)
        canvasImage.draw(in: CGRect(origin: .zero, size: imageSize))

        // Finaliza el contexto gráfico
        guard let combinedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            print("Error al combinar la imagen con el texto y el contenido del canvas.")
            completion(nil)
            return
        }

        // Llama a completion con la imagen generada
        completion(combinedImage)
    }*/

    func saveImageFondoFinalColorDinamico(completion: @escaping (UIImage?) -> Void) {
        // Accede a la imagen de fondo seleccionada en imageBackground
        guard let backgroundImage = imageBackground.backgroundImage else {
            print("Error: No se ha seleccionado una imagen de fondo.")
            completion(nil)
            return
        }

        // Renderiza el contenido del canvas en una imagen
        let canvasImage = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)

        // Configura el tamaño de la imagen resultante como el tamaño de la imagen de fondo
        let imageSize = backgroundImage.size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)

        // Dibuja la imagen de fondo
        backgroundImage.draw(in: CGRect(origin: .zero, size: imageSize))

        // Dibuja la imagen seleccionada en la parte superior izquierda
        if let selectedImage = selectedImageGaleria {
            let imageWidth: CGFloat = 150
            let imageHeight: CGFloat = 200
            let imageRect = CGRect(x: 10, y: 10, width: imageWidth, height: imageHeight)
            selectedImage.draw(in: imageRect)
        }

        // Configura las propiedades del texto
        let fullText = "\n\n\n\n\n\n\n\nQueridos reyes magos. \nEste año, Me he portado: \n" + model.sePorto + "\nAsi que, Me gustaria: \n"
            + model.opcionUno + "\n"
            + model.opcionDos + "\n"
            + model.opcionTres + "\n"
            + "\n"
            + "\n"
            + "\n"
            + "Con cariño " + model.nombreNino

        // Divide el texto en líneas
        let lines = fullText.components(separatedBy: "\n")

        // Define los colores que deseas aplicar a cada línea (puedes cambiarlos según tus preferencias)
        let lineColors: [UIColor] = [
            .red, .green, .blue, .orange, .purple, .yellow, .cyan, .magenta, .brown
        ]

        // Calcula el tamaño necesario para el texto y dibújalo
        var yOffset: CGFloat = 0.0
        for (index, line) in lines.enumerated() {
            let color = lineColors[index % lineColors.count]
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20.0),
                .foregroundColor: color,
                .paragraphStyle: NSMutableParagraphStyle()
            ]
            let textSize = line.size(withAttributes: attributes)

            // Dibuja el texto en el contexto gráfico con el color correspondiente
            let textRect = CGRect(
                x: (imageSize.width - textSize.width) / 2,
                y: yOffset,
                width: textSize.width,
                height: textSize.height
            )
            line.draw(in: textRect, withAttributes: attributes)

            // Incrementa la posición vertical para la siguiente línea
            yOffset += textSize.height
        }

        // Dibuja el contenido del canvas (dibujo del usuario)
        canvasImage.draw(in: CGRect(origin: .zero, size: imageSize))

        // Finaliza el contexto gráfico
        guard let combinedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            print("Error al combinar la imagen con el texto y el contenido del canvas.")
            completion(nil)
            return
        }

        // Llama a completion con la imagen generada
        completion(combinedImage)
    }

    
    func saveImageFondoFinalColor(completion: @escaping (UIImage?) -> Void) {
        // Tu código para generar la imagen final
        


        // Carga la imagen de fondo
        guard let backgroundImage = UIImage(named: "fondo_carta_santa_cinco") else {
            print("Error al cargar la imagen de fondo.")
            return
        }
        
        
        // Renderiza el contenido del canvas en una imagen
        let canvasImage = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        
        // Configura el tamaño de la imagen resultante como el tamaño de la imagen de fondo
        let imageSize = backgroundImage.size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        
        // Dibuja la imagen de fondo
        backgroundImage.draw(in: CGRect(origin: .zero, size: imageSize))
        
        // Configura las propiedades del texto
        let fullText = "\n\n\n\n\n\n\n\nQueridos reyes magos. \nEste año, Me he portado: \n" + model.sePorto + "\nAsi que, Me gustaria: \n"
        + model.opcionUno + "\n"
        + model.opcionDos + "\n"
        + model.opcionTres + "\n"
        + "\n"
        + "\n"
        + "\n"
        + "Con cariño " + model.nombreNino
        
        // Divide el texto en líneas
        let lines = fullText.components(separatedBy: "\n")
        
        // Define los colores que deseas aplicar a cada línea (puedes cambiarlos según tus preferencias)
        let lineColors: [UIColor] = [
            .red, .green, .blue, .orange, .purple, .yellow, .cyan, .magenta, .brown
        ]
        
        // Calcula el tamaño necesario para el texto
        var yOffset: CGFloat = 0.0
        for (index, line) in lines.enumerated() {
            let color = lineColors[index % lineColors.count]
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20.0),
                .foregroundColor: color,
                .paragraphStyle: NSMutableParagraphStyle()
            ]
            let textSize = line.size(withAttributes: attributes)
            
            // Dibuja el texto en el contexto gráfico con el color correspondiente
            let textRect = CGRect(
                x: (imageSize.width - textSize.width) / 2,
                y: yOffset,
                width: textSize.width,
                height: textSize.height
            )
            line.draw(in: textRect, withAttributes: attributes)
            
            // Incrementa la posición vertical para la siguiente línea
            yOffset += textSize.height
        }
        
        // Dibuja el contenido del canvas (dibujo del usuario)
        canvasImage.draw(in: CGRect(origin: .zero, size: imageSize))
        
        // Extrae la imagen combinada del contexto gráfico
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // Finaliza el contexto gráfico
        UIGraphicsEndImageContext()
        
        // Guarda la imagen combinada en el álbum de fotos
        if let finalImage = combinedImage {
            
            // Asigna la imagen a la propiedad finalImage
             self.finalImage = finalImage
            self.showShareSheet = true
         
            //FUNCION PARA GUARDAR LA IMAGEN
  /*UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            print("Imagen guardada con texto centrado y contenido del canvas.")*/
            

            
            // Llama a completion con la imagen generada o nil en caso de error
            completion(finalImage)
       
        } else {
            print("Error al combinar la imagen con el texto y el contenido del canvas.")
        }
    }

 
    func shareImageDos(_ image: UIImage) {
        // Crea un array con los elementos que deseas compartir
        let items: [Any] = [image]
        
        // Crea un ActivityViewController
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Personaliza el mensaje que se muestra al usuario
        activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.keyWindow
        
        // Muestra el ActivityViewController
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }


    
    func shareImage(_ image: UIImage) {
        // Crea un URL temporal para la imagen compartida
        let imagePath = NSTemporaryDirectory() + "sharedImage.png"
        let imageUrl = URL(fileURLWithPath: imagePath)
        
        do {
            // Guarda la imagen en el URL temporal
            try image.pngData()?.write(to: imageUrl)
            
            // Crea un ActivityViewController
            let activityViewController = UIActivityViewController(activityItems: [imageUrl], applicationActivities: nil)
            
            // Muestra el ActivityViewController
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        } catch {
            print("Error al guardar la imagen temporal: \(error)")
        }
    }


    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor(red: 1.58, green: 0.19, blue: 0.06, alpha: 1.00)
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
   
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
 
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
 
    @State private var showAlert = false
    
    var body: some View {
        
        VStack{
 
            if(model.dibujaCarta != nil){
 
              NavigationView { // ios 16 NavigationStack
                  ZStack {
                      // Muestra la imagen seleccionada por su nombre
                      Image(selectedImage ?? "tarjeta_reyes_magos_cinco")
                          .resizable()
                          .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight - (UIScreen.screenHeight / 3))



                CanvasView(canvas: $canvas, color: $color, type: $type, isDraw: $isdraw)
                                      .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight - (UIScreen.screenHeight / 3))
                              }
                      .navigationTitle("Draw")
                      .navigationBarTitleDisplayMode(.inline)
 
                        .toolbar {
                            HStack{
                                ColorPicker("", selection: $color)
                                // Botón "Selecciona una carta"
                                Button(action: {
                                    isImagePickerPresented = true
                                }) {
                                    Text("Selecciona una carta")
                                        .foregroundColor(.white)
                                        .frame(width: 180, height: 50) // Ancho y alto fijos del botón
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                                VStack { // Espaciado entre los botones
                                    // Botón "Galería"
                                    if validaCompra(){
                                        Button(action: {
                                            selectImageFromGallery()
                                        }) {
                                            Text("Agrega foto")
                                                .foregroundColor(.white)
                                                .frame(width: 180, height: 50) // Ancho y alto fijos del botón
                                                .background(Color.blue)
                                                .cornerRadius(8)
                                        }
                                        
                                        // Mostrar la imagen seleccionada
                                        if let image = selectedImageGaleria {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 100)
                                        }
                                    }else{
                                        HStack {
                                           
                                            Button("Agrega foto") {
                                                // Agrega aquí la acción para realizar la compra
                                                // Por ahora, mostraremos un Alert
                                                showAlert.toggle()
                                            }
                                            .alert(isPresented: $showAlert) {
                                                Alert(
                                                    title: Text("Agrega una imagen desde la galería"),
                                                    message: Text("Todas las herramientas con Compra única."),
                                                    primaryButton: .default(Text("OK")),
                                                    secondaryButton: .cancel()
                                                )
                                            }
                                        }.frame(maxWidth: .infinity, alignment: .center) // Centra el contenido del HStack en el espacio disponible
                                    }
                                    
                                    
                                    
                                }




                                
                         


 
                                Button(action: {
                                    self.uiImage = UIApplication.shared.windows[0].rootViewController?.view!.getImage(rect: self.rect)
                                    let dispatchGroup = DispatchGroup()
                                    dispatchGroup.enter()
                                    saveImageFondoFinalColorDinamico{ image in
                                    if let image = image {
                                       self.finalImage = image
                                       self.showShareSheet = true
                                    } else {
                                       print("No se pudo generar la imagen final")
                                    }
                                        dispatchGroup.leave()
                                    }
                                }) {
 
                                    Image(systemName: "square.and.arrow.up")

                                        .padding()
                                        .background(Color.white)
                                        .foregroundColor(Color(hex: 0xd8ae2d))
                                }
                                
                                .sheet(isPresented: self.$showShareSheet) {
                                     if let finalImage = finalImage {
                                         ShareSheet(photo: finalImage)
                                     } else {
                                         Text("No hay imagen para compartir")
                                     }
                                 }
                                 .id(finalImage)
 
                                BotonView(action: {
                                    undoManager?.undo()
                                }, icon: "arrow.uturn.backward")
                                
                                BotonView(action: {
                                    undoManager?.redo()
                                }, icon: "arrow.uturn.forward")
     
                                BotonView(action: {
                                    isdraw = false
                                    canvas.drawing = PKDrawing()
 
                                    isdraw.toggle()
                                }, icon: "pencil.slash")
                                
                                BotonView(action: {
                                    canvas.drawing = PKDrawing()
                                }, icon: "trash")
                            }.frame(height: 200)
                        }
                }.navigationViewStyle(StackNavigationViewStyle())
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePickerView(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented, imageBackground: imageBackground)
                    }
                    .onAppear {
                                // Asignar la vista actual como el contentView del ImagePickerDelegate
                                imagePickerDelegate.contentView = self
                            }
                    /*.sheet(isPresented: .constant(true)) {
                          ImagePicker(imagePickerDelegate: imagePickerDelegate)
                           }*/
            }else  {
                
                Text(
 
                    model.updateItem != nil  ? "Actualiza tu carta" : "Escribe tu carta"
                )
                .font(.title).bold().foregroundColor(.white)
                .frame(width: UIScreen.screenWidth - (UIScreen.screenWidth / 4))
 
                TextField("Mi nombre es: ", text: $model.nombreNino)
                    .frame(width: UIScreen.screenWidth - (UIScreen.screenWidth / 4) ,height: 50)
                    .keyboardType(.default)
                    .background(Color.white)
                    .foregroundColor(.blue)
                
                TextField("Edad:", text: $model.edad)
                    .frame(width: UIScreen.screenWidth - (UIScreen.screenWidth / 4) ,height: 50)
                    .keyboardType(.numberPad)
                    .background(Color.white)
                    .foregroundColor(.blue)
                
                Text("Este año, me gustaría:")
                    .frame(width: UIScreen.screenWidth - (UIScreen.screenWidth / 4) ,height: 50)
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)

                .foregroundColor(.white)
            
                 TextField("* 1:", text: $model.opcionUno)
                    .frame(width: UIScreen.screenWidth - (UIScreen.screenWidth / 4) ,height: 50)
                    .keyboardType(.default)
                    .background(Color.white)
                    .foregroundColor(.blue)
     
                TextField("* 2:", text: $model.opcionDos)
                    .frame(width: UIScreen.screenWidth - (UIScreen.screenWidth / 4) ,height: 50)
                    .keyboardType(.default)
                    .background(Color.white)
                    .foregroundColor(.blue)
     
                TextField("* 3:", text: $model.opcionTres)
                    .frame(width: UIScreen.screenWidth - (UIScreen.screenWidth / 4) ,height: 50)
                    .keyboardType(.default)
                    .background(Color.white)
                    .foregroundColor(.blue)
     
 
     
                Picker("Este año, me he portado:", selection: $model.sePorto) { // 3
                         ForEach(options, id: \.self) { item in // 4
                             Text(item)
                                 .bold()
                                 .tint(Color(hex: 0xfafbfd))
                                 .frame(height: 50)// 5
                         }
                     }.tint(Color(hex: 0xfafbfd))
                
                VStack{
                Spacer()
                Button(action: {
                    if(!model.nombreNino.isEmpty){
                        if(!model.edad.isEmpty){
                            if(!model.opcionUno.isEmpty){
                                if(!model.opcionDos.isEmpty){
                                    if(!model.opcionTres.isEmpty){
                                        if(!model.sePorto.elementsEqual(options[0])
                                           && !model.sePorto.isEmpty){
                                            self.printUI(model.sePorto)
                                            if(model.updateItem != nil){
                                                model.editData(context: context)
                                            }else{
                                                model.saveData(context: context)
                                            }
                                            
                                        }else{
                                            showingAlert = true
                                            mensaje = "¡Selecciona como te portaste!"
                                        }
                                    }else{
                                        showingAlert = true
                                         mensaje = "¡Agrega tu primer deseo!"
                                    }
                                }else{
                                    showingAlert = true
                                    mensaje = "¡Agrega tu segundo deseo!"
                                }
                            }else{
                                showingAlert = true
                                mensaje = "¡Agrega tu tercer deseo!"
                            }
                        }else{
                            showingAlert = true
                            mensaje = "¡Agrega tu edad!"
                        }
                    }else{
                        print("Nombre del niño esta vacio")
                                          showingAlert = true
                                          mensaje = "¡Agrega tu nombre!"
                    }
                }){
                    Text(model.updateItem != nil  ? "Actualiza carta" : "Guarda tu carta")
                        .foregroundColor(.white).bold()
                }.padding()
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .backgroundStyle(Color.blue)
                    .background(Color(hex: 0x2d572c))
                    //.tint(Color(hex: 0x2d572c))
                    .cornerRadius(0)
                    .alert(mensaje, isPresented: $showingAlert) {
                                Button("OK", role: .cancel) { }
                            }
                }.padding()
                    .background(Color(hex: 0xb8000e))
            }
        }.padding()
            .background(Color(hex: 0xb8000e))
    }
   // let imagePickerDelegate = ImagePickerDelegate()
   //     @State var selectedImageGaleria: UIImage?
 
    func selectImageFromGallery() {
           let imagePicker = UIImagePickerController()
           imagePicker.sourceType = .photoLibrary
           imagePicker.delegate = imagePickerDelegate
           
           // Obtener el controlador de vista actualmente visible en la pantalla
           guard var topViewController = UIApplication.shared.windows.first?.rootViewController else { return }
           while let presentedViewController = topViewController.presentedViewController {
               topViewController = presentedViewController
           }
           
           // Presentar el controlador de vista de la galería desde el controlador de vista actualmente visible
           topViewController.present(imagePicker, animated: true, completion: nil)
       }

    func validaCompra() -> Bool {
        var compro = false
        if store.allBooks.isEmpty {
            print("El array de libros está vacío")
            compro = false
        } else if store.allBooks[0].lock {
            print("Producto no comprado")
            compro = false
        } else {
            print("Producto sí comprado")
            compro = true
        }
        return compro
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    let imagePickerDelegate: ImagePickerDelegate
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = imagePickerDelegate
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
 
class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var contentView: addView?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            print("Selected image: \(selectedImage)")
            contentView?.selectedImageGaleria = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
 
extension UIView {
    func getImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct ImagePickerView: View {
    @EnvironmentObject private var store: Store
    @Binding var selectedImage: String?
    @Binding var isImagePickerPresented: Bool
    @ObservedObject var imageBackground: ImageBackground
    var availableImages: [String] = ["tarjeta_reyes_magos_cinco", "tarjeta_reyes_magos_seis", "tarjeta_reyes_magos_siete", "tarjeta_reyes_magos_ocho", "tarjeta_reyes_magos_nueve", "tarjeta_reyes_magos_diez", "tarjeta_reyes_magos_once", "tarjeta_reyes_magos_doce" ]
    @State private var showingAlert = false
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            List {
                ForEach(availableImages, id: \.self) { imageName in
                     if validaCompra(){
                        Button(action: {
                            selectedImage = imageName
                            isImagePickerPresented = false
                            imageBackground.backgroundImage = UIImage(named: imageName)
                        }) {
                            HStack {
                                Image(imageName)
                                    .resizable()
                                    .frame(width: 250, height: 250)
                                    .aspectRatio(contentMode: .fit)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }else{
                        HStack {
                            Image(imageName)
                                .resizable()
                                .frame(width: 250, height: 250)
                                .aspectRatio(contentMode: .fit)
                            Button("Compra única") {
                                // Agrega aquí la acción para realizar la compra
                                // Por ahora, mostraremos un Alert
                                showAlert.toggle()
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Compra única"),
                                    message: Text("Todas las herramientas con Compra única."),
                                    primaryButton: .default(Text("OK")),
                                    secondaryButton: .cancel()
                                )
                            }
                        }.frame(maxWidth: .infinity, alignment: .center) // Centra el contenido del HStack en el espacio disponible
                    }
                }
            }
            .navigationBarTitle("Selecciona")
            .navigationBarItems(leading: Button("Cancel") {
                isImagePickerPresented = false
            })
        }
    }
    func validaCompra() -> Bool {
        var compro = false
        if store.allBooks.isEmpty {
            print("El array de libros está vacío")
            compro = false
        } else if store.allBooks[0].lock {
            print("Producto no comprado")
            compro = false
        } else {
            print("Producto sí comprado")
            compro = true
        }
        return compro
    }
}

/*struct DrawingView: UIViewRepresentable {
    // to capture drawings for saving into albums
    @Binding var canvas: PKCanvasView
    @Binding var isdraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
 
    // Updating inktype
    
     var ink : PKInkingTool {
        
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.drawingPolicy = .anyInput
        canvas.tool = isdraw ? ink : eraser
        canvas.sizeToFit()
  
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // updating the tool whenever the view updates
        
        uiView.tool = isdraw ? ink : eraser
        
    }
}*/
 
struct ShareSheet: UIViewControllerRepresentable {
 
    //let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
    let photo: UIImage
 
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let text = "Share your image"
        let itemSource = ShareActivityItemSource(shareText: text, shareImage: photo)
        
        let activityItems: [Any] = [photo, text, itemSource]
        
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil)
        
        return controller
    }
      
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {
    }
    

}

class ShareActivityItemSource: NSObject, UIActivityItemSource {
    
    var shareText: String
    var shareImage: UIImage
    var linkMetaData = LPLinkMetadata()
    
    init(shareText: String, shareImage: UIImage) {
        self.shareText = shareText
        self.shareImage = shareImage
        linkMetaData.title = shareText
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: "AppIcon ") as Any
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetaData
    }
    
 

}

 
struct BotonView: View {
    
    var action : (() -> Void)
    var icon : String
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
        }

    }
}

struct CanvasView : UIViewRepresentable {
    
    @Binding var canvas : PKCanvasView
    @Binding var color : Color
    @Binding var type : PKInkingTool.InkType
    @Binding var isDraw : Bool
    @State var tootlPicker = PKToolPicker()
    
    //let pencil = PKInkingTool(.marker, color: .red)
    
    var pencil : PKInkingTool {
        PKInkingTool(type, color: UIColor(color) )
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? pencil : eraser
        canvas.backgroundColor = .clear
        showToolPicker()
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDraw ? pencil : eraser
    }
    
}
 

extension CanvasView {
    func showToolPicker() {
        tootlPicker.setVisible(true, forFirstResponder: canvas)
        tootlPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
    }
}

extension UIColor {
    func interpolateRGBColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor? {
        let f = min(max(0, fraction), 1)

        guard let c1 = self.cgColor.components, let c2 = end.cgColor.components else { return nil }

        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

