//
//  EnviaCartaUIView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 21/03/24.
//

import SwiftUI
import PencilKit
import LinkPresentation
import Combine

struct EnviaCartaUIView: View {
    
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

    var availableImages: [String] = ["fondo_carta_reyes_magos_dos", "fondo_carta_reyes_magos_tres", "fondo_carta_reyes_magos_uno" ]
 
    @StateObject private var imageBackground = ImageBackground()
    @State private var selectedImageName: String = "fondo_carta_reyes_magos_dos"
    
    @EnvironmentObject private var store: Store
    @State public var selectedImageGaleriaEnvia: UIImage? // Esta variable se movió fuera del cuerpo de la vista
    let imagePickerDelegate = ImagePickerDelegateEnvia()
 
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
 
    func saveImageFondoFinalColorDinamico(completion: @escaping (UIImage?) -> Void) {
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
    
    var body: some View {
        NavigationView { // ios 16 NavigationStack
            ZStack {
                // Muestra la imagen seleccionada por su nombre
                Image(selectedImage ?? "fondo_carta_reyes_magos_dos")
                    .resizable()
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight - (UIScreen.screenHeight / 4))



          CanvasView(canvas: $canvas, color: $color, type: $type, isDraw: $isdraw)
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight - (UIScreen.screenHeight / 4))
                        }
                .navigationTitle("Draw")
                .navigationBarTitleDisplayMode(.inline)

                  .toolbar {
                      HStack{
                          ColorPicker("", selection: $color)
                          
                          Button(action: {
                              selectImageFromGallery()
                          }) {
                              Text("Selecciona una imagen desde la galería")
                          }
                          .padding()

                          
                          Button(action: {
                                          isImagePickerPresented = true
                                      }) {
                                          Text("Selecciona una carta")
                                      }
                                      .padding()
                          // Mostrar la imagen seleccionada
                                      if let image = selectedImageGaleriaEnvia {
                                          Image(uiImage: image)
                                              .resizable()
                                              .aspectRatio(contentMode: .fit)
                                              .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight - (UIScreen.screenHeight / 4))
                                      }

                          
                          Button(action: {
                              self.uiImage = UIApplication.shared.windows[0].rootViewController?.view!.getImageEnvia(rect: self.rect)

                              let dispatchGroup = DispatchGroup()

                              dispatchGroup.enter() // Ingresa al grupo

                              // Llama a la función saveImageFondoFinalColor y espera a que termine
                              saveImageFondoFinalColorDinamico{ image in
                                  if let image = image {
                                      self.finalImage = image
                                      
                                      // Force view update
                                      self.showShareSheet = true // Mostrar la hoja de compartir después de guardar la imagen
                                  } else {
                                      // Maneja el caso en que finalImage sea nil
                                      print("No se pudo generar la imagen final")
                                  }

                                  dispatchGroup.leave() // Sale del grupo cuando la operación ha terminado
                                  // Cerrar addView
                                 //
                              }
                          }) {
                              // Contenido del botón
                              Image(systemName: "square.and.arrow.down.fill")
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

                      }
                  }
              
          }.navigationViewStyle(StackNavigationViewStyle())
              .sheet(isPresented: $isImagePickerPresented) {
                  ImagePickerViewEnvia(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented, imageBackground: imageBackground)
              }
        
 
      
    }
    
    func selectImageFromGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        // Asigna el delegado del controlador de imagen
        // Asegúrate de que imagePickerDelegate esté disponible en este ámbito
        // imagePicker.delegate = imagePickerDelegate

        if let presentingViewController = UIApplication.shared.windows.first?.rootViewController {
            if let presentedViewController = presentingViewController.presentedViewController {
                presentedViewController.dismiss(animated: false) {
                    presentingViewController.present(imagePicker, animated: true, completion: nil)
                }
            } else {
                presentingViewController.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
}

 
class ImagePickerDelegateEnvia: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var contentView: EnviaCartaUIView?
  

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            contentView?.selectedImageGaleriaEnvia = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
 
extension UIView {
    func getImageEnvia(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct ImagePickerViewEnvia: View {
    @EnvironmentObject private var store: Store
    @Binding var selectedImage: String?
    @Binding var isImagePickerPresented: Bool
    @ObservedObject var imageBackground: ImageBackground
    var availableImages: [String] = ["fondo_carta_reyes_magos_dos", "fondo_carta_reyes_magos_tres", "fondo_carta_reyes_magos_uno" ]
    @State private var showingAlert = false
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            List {
                ForEach(availableImages, id: \.self) { imageName in
                    //if validaCompra(){
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
                            .frame(maxWidth: .infinity, alignment: .center) // Centra el contenido del HStack en el espacio disponible


                        }
                   /* }else{
                        
                        HStack {
                            Image(imageName)
                                .resizable()
                                .frame(width: 250, height: 250)
                                .aspectRatio(contentMode: .fit)
                            
                            Button("Purchase Lifetime") {
                                // Agrega aquí la acción para realizar la compra
                                // Por ahora, mostraremos un Alert
                                showAlert.toggle()
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Purchase Lifetime"),
                                    message: Text("All tools are available with a Lifetime purchase."),
                                    primaryButton: .default(Text("OK")),
                                    secondaryButton: .cancel()
                                )
                            }
                        }.frame(maxWidth: .infinity, alignment: .center) // Centra el contenido del HStack en el espacio disponible
                    }*/
                    
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
