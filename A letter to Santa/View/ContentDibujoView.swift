//
//  ContentDibujoView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 22/09/23.
//
import SwiftUI
import PencilKit
import LinkPresentation
import StoreKit
import Combine

struct ContentDibujoView: View {
    @EnvironmentObject private var store: Store
    @State var shouldHide = false
    @State private var showingAlert = false
 
 
    var body: some View {
 
        VStack{
 
            if !validaCompra() {
                Button(action: {
                        if let product = store.product(for: store.allBooks[0].id){
                            store.purchaseProduct(product: product)
                        }
      
                    print("editar")

                }){
                    Label(title: {
                        Text("Versión Pro: Todas las herramientas y el seguimiento de los reyes mapas por $0.99")
                    }, icon: {
                        Image(systemName: "pencil")
                    })
                }.padding()
                 .frame(width: UIScreen.main.bounds.width - 30 )
                .backgroundStyle(Color.blue)
                .cornerRadius(0)
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: 0x2d572c))
 
                Button("Restore purchase"){
                    store.restorePurchase()
                }
                
            }else{

 
            } 
 
            NavigationStack {
 
                List(lista) { item in
                    if validaCompra(){
                        NavigationLink(
                            destination:         DrawingDibujoView(backgroundImage: UIImage(named: item.emoji)!, items: item)){
                               VStack{
                                   emoji(emoji: item)
                                   //Text(item.nombre)
                                   Text("")
                                       .font(.title).bold().foregroundColor(.white)
                                       .background(Color(hex: 0xb8000e))
                                       .frame(width: UIScreen.screenWidth, height: 50, alignment: .center )
                               }
                            }
                    }else{
                        NavigationLink(
                            destination:         DrawingDemoDibujoView(backgroundImage: UIImage(named: item.emoji)!, items: item)){
                               VStack{
                                   emoji(emoji: item)
                                   //Text(item.nombre)
                                   Text("")
                                       .font(.title).bold().foregroundColor(.white)
                                       .background(Color(hex: 0xb8000e))
                                       .frame(width: UIScreen.screenWidth, height: 50, alignment: .center )
                               }
                            }
                    }

                    
                    /*if validaCompra(){
                        NavigationLink(
                           destination: VistaDetalle(items: item)){
                               VStack{
                                   emoji(emoji: item)
                                   Text(item.nombre)
                                       .font(.subheadline)
                               }
                            }
                    }else{
                        NavigationLink(
                           destination: VistaDetalleDemo(items: item)){
                               VStack{
                                   emoji(emoji: item)
                                   Text(item.nombre)
                                       .font(.subheadline)
                               }
                            }
                    }*/

                }.navigationTitle("Selecciona una tarjeta")
                    .listStyle(PlainListStyle())
                    .navigationViewStyle(StackNavigationViewStyle())
                    
 
            }
 
        }.padding()
            .background(Color(hex: 0xb8000e))
            .listStyle(PlainListStyle())
        
        
    }
    
    func validaCompra() -> Bool {
       var compro = false
        if  (store.allBooks[0].lock) {
            print("producto no comprado")
            compro = false
        }else{
            print("producto si comprado")
            compro = true
        }
       return compro
    }
    
 
}


/*struct ContentDibujoView: View {
    var body: some View {
        //NavigationView {
        DrawingDibujoView(backgroundImage: UIImage(named: "duende_esfera_dots")!, items: <#ModeloLista#>)
                .navigationBarTitle("Colorear")
        //}
    }
}*/

struct DrawingDibujoView: View {
    @State private var canvas = PKCanvasView()
    @State private var isDrawing = true
    @State private var drawingColor = Color.black
    @State var type: PKInkingTool.InkType = .pencil
    // Esta será la imagen de fondo
    let backgroundImage: UIImage
    @Environment(\.undoManager) private var undoManager
    @State var isdraw = true
    @State private var showingAlertSave = false
    let items : ModeloLista
    @State private var finalImage: UIImage?
    @State private var showShareSheet = false
    @State private var rect: CGRect = .zero
    @State private var uiImage: UIImage? = nil
    
    var body: some View {
        VStack {
            // Botón para guardar
            /*Button(action: saveDrawingCanvas) {
                Text("Guardar")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }*/
 
 
            VStack {
                HStack{
                    NavigationView {
            // Área de dibujo con PencilKit
            CanvasDibujoView(canvas: $canvas, isDrawing: $isDrawing, drawingColor: $drawingColor, type: $type, items: items, backgroundImageSize: CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight - (UIScreen.screenHeight / 3)))
                            .navigationTitle("Dibujar")
                            .navigationBarTitleDisplayMode(.inline)
                            .background(
                                Image(uiImage: UIImage(named: items.emoji)!)
                                    .resizable()
                                    .frame(
                                        width: UIScreen.screenWidth, height: UIScreen.screenHeight - (UIScreen.screenHeight / 3)
                                    )
                            )
              .toolbar {
                    HStack{
                        ColorPicker("", selection: $drawingColor)

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
                        
                        /*BotonView(action: {
                            saveDrawingCanvas()
                            showingAlertSave = true
                        }, icon: "square.and.arrow.down.fill").alert(isPresented:$showingAlertSave) {
                            Alert(
                                title: Text("Imagen guardada"),
                                message: Text( "La imagen fue guardada en la galeria"),
                                dismissButton: .default(Text("OK" )))
       
                        }*/
                        
                        
                        Button(action: {
                            self.uiImage = UIApplication.shared.windows[0].rootViewController?.view!.getImage(rect: self.rect)

                            let dispatchGroup = DispatchGroup()

                            dispatchGroup.enter() // Ingresa al grupo

                            // Llama a la función saveImageFondoFinalColor y espera a que termine
                            saveDrawingCanvasFinal { image in
                                if let image = image {
                                    self.finalImage = image
                                    
                                    // Force view update
                                    self.showShareSheet = true // Mostrar la hoja de compartir después de guardar la imagen
                                } else {
                                    // Maneja el caso en que finalImage sea nil
                                    print("No se pudo generar la imagen final")
                                }
                                
                                dispatchGroup.leave() // Sale del grupo cuando la operación ha terminado
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
                                // Maneja el caso en que finalImage sea nil
                                Text("No hay imagen para compartir")
                            }
                        }
                        .id(finalImage) // Force view update when finalImage changes
                        
                    }
                }
                    }.navigationViewStyle(StackNavigationViewStyle())
     
                }
                //Text(items.descripcion).padding(.top)
 
            }
 
            

        }
    }
    
    func saveDrawingCanvasFinal(completion: @escaping (UIImage?) -> Void) {
        // Captura la imagen de la vista que contiene tanto el canvas como la imagen de fondo
        guard let backgroundImage = UIImage(named: items.emojiFinal) else {
            print("Error al cargar la imagen de fondo.")
            completion(nil) // Llama a completion con nil para indicar un error
            return
        }

        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = canvas.frame
        canvas.addSubview(backgroundImageView)
        canvas.sendSubviewToBack(backgroundImageView)

        // Combinar las imágenes (backgroundImage y canvas)
        guard let combinedImage = canvas.superview?.asImage() else {
            print("Error al combinar la imagen con el texto y el contenido del canvas.")
            completion(nil) // Llama a completion con nil para indicar un error
            return
        }

        // Guardar en el álbum de fotos
        self.finalImage = combinedImage
        self.showShareSheet = true
        //UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)

        // Remover el UIImageView del canvas
        for subview in canvas.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }

        // Llamar a completion con la imagen generada
        completion(combinedImage)
    }

    
    func saveDrawingCanvas() {
        // Captura la imagen de la vista que contiene tanto el canvas como la imagen de fondo
        if let backgroundImage = UIImage(named: items.emojiFinal) {
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.frame = canvas.frame
            canvas.addSubview(backgroundImageView)
            canvas.sendSubviewToBack(backgroundImageView)
        }
        
        if let combinedImage = canvas.superview?.asImage() {
            // Guarda la imagen combinada en la galería de fotos
            UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
        }
        
        // Remueve el UIImageView del canvas
        for subview in canvas.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
    }

    
    /*func saveDrawingCanvas() {
        // Captura la imagen de la vista que contiene tanto el canvas como la imagen de fondo
        if let backgroundImage = UIImage(named: "duende_esfera") {
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.frame = canvas.frame
             canvas.addSubview(backgroundImageView)
             canvas.sendSubviewToBack(backgroundImageView)
        }
        if let combinedImage = canvas.superview?.asImage() {
            self.printUI("saveDrawingCanvas")
            self.printUI(self.canvas.superview?.bounds)
            
            // Guarda la imagen combinada en la galería de fotos
            UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
        }
        
    }*/

    
    // Función para guardar la imagen y el dibujo
    func saveDrawing() {
        // Captura la imagen del canvas
        let drawingImage = canvas.drawing.image(from: canvas.bounds, scale: UIScreen.main.scale)
        
        // Combina la imagen de fondo y el dibujo
        let combinedImage = combineImages(background: backgroundImage, drawing: drawingImage)
        
        // Guarda la imagen combinada en la galería de fotos
        UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
    }
    
    // Función para combinar la imagen de fondo y el dibujo
    func combineImages(background: UIImage, drawing: UIImage) -> UIImage {
        let size = background.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        background.draw(in: CGRect(origin: CGPoint.zero, size: size))
        drawing.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage ?? UIImage()
    }
}

 
struct CanvasDibujoView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var isDrawing: Bool
    @Binding var drawingColor: Color
    @Binding var type : PKInkingTool.InkType
    let items : ModeloLista
    var backgroundImageSize: CGSize? // Agrega esta propiedad
 
    @State var tootlPicker = PKToolPicker()
 
 
    var pencil : PKInkingTool {
        PKInkingTool(type, color: UIColor(drawingColor) )
    }
    
    let eraser = PKEraserTool(.bitmap)

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.tool = PKInkingTool(.pencil, color: UIColor(drawingColor))
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear

        // Ajusta el tamaño del PKCanvasView para que coincida con el tamaño de la imagen de fondo
 
            let size = CGSize(width: UIScreen.screenWidth , height: UIScreen.screenHeight - (UIScreen.screenHeight / 3)) // Establece el tamaño deseado
        canvas.frame = CGRect(origin: .zero, size: backgroundImageSize!)
 

        // Agregar una imagen de fondo
        if let backgroundImage = UIImage(named: items.emojiFinal) {
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.frame = canvas.frame
             //canvas.addSubview(backgroundImageView)
             //canvas.sendSubviewToBack(backgroundImageView)
        }
        
        showToolPicker()
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Actualizar la herramienta y el color de dibujo en tiempo real
        uiView.tool = PKInkingTool(.pencil, color: UIColor(drawingColor))
        uiView.isOpaque = false
        uiView.backgroundColor = UIColor.clear
        uiView.isUserInteractionEnabled = isDrawing
    }
}

extension CanvasDibujoView {
    func showToolPicker() {
        tootlPicker.setVisible(true, forFirstResponder: canvas)
        tootlPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}


struct DrawingDemoDibujoView: View {
    @State private var canvas = PKCanvasView()
    @State private var isDrawing = true
    @State private var drawingColor = Color.black
    @State var type: PKInkingTool.InkType = .pencil
    // Esta será la imagen de fondo
    let backgroundImage: UIImage
    @Environment(\.undoManager) private var undoManager
    @State var isdraw = true
    @State private var showingAlertSave = false
    let items : ModeloLista
    @State private var showingAlert = false
    
    @EnvironmentObject private var store: Store
    
    @State private var finalImage: UIImage?
    @State private var showShareSheet = false
    @State private var rect: CGRect = .zero
    @State private var uiImage: UIImage? = nil
    
    var body: some View {
        VStack {
            // Botón para guardar
            /*Button(action: saveDrawingCanvas) {
                Text("Guardar")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }*/
 
 
            VStack {
                HStack{
                    NavigationView {
            // Área de dibujo con PencilKit
            CanvasDibujoView(canvas: $canvas, isDrawing: $isDrawing, drawingColor: $drawingColor, type: $type, items: items, backgroundImageSize: CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight - (UIScreen.screenHeight / 3)))
                            .navigationTitle("Dibujar")
                            .navigationBarTitleDisplayMode(.inline)
                            .background(
                                Image(uiImage: UIImage(named: items.emoji)!)
                                    .resizable()
                                    .frame(
                                        width: UIScreen.screenWidth, height: UIScreen.screenHeight - (UIScreen.screenHeight / 3)
                                    )
                            )
              .toolbar {
                    HStack{
                        ColorPicker("", selection: $drawingColor)

                        BotonView(action: {
                            if validaCompra(){
                                undoManager?.undo()
                            }else {
                                showingAlert = true
                            }
                            
                        }, icon: "arrow.uturn.backward")
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Pro"),
                                message: Text( "Para utilizar todas las herramientas, por favor, adquiere la versión pro."),
                                dismissButton: .default(Text("OK" )))
       
                        }
                        /*.alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Buy it!"),
                                message: Text( "Post cards, 3D Images and Santa Tracker for $1.99."),
                                primaryButton: .destructive(Text("Buy")) {
                                    if let product = store.product(for: store.allBooks[0].id){
                                        store.purchaseProduct(product: product)
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }*/
                        
                        BotonView(action: {
                            if validaCompra(){
                                undoManager?.redo()
                            }else {
                                showingAlert = true
                            }
                            
                        }, icon: "arrow.uturn.forward")
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Pro"),
                                message: Text( "Para utilizar todas las herramientas, por favor, adquiere la versión pro."),
                                dismissButton: .default(Text("OK" )))
       
                        }
                        /*.alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Buy it!"),
                                message: Text( "Post cards, 3D Images and Santa Tracker for $1.99."),
                                primaryButton: .destructive(Text("Buy")) {
                                    if let product = store.product(for: store.allBooks[0].id){
                                        store.purchaseProduct(product: product)
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }*/

                        BotonView(action: {
                            if validaCompra(){
                                isdraw = false
                                canvas.drawing = PKDrawing()
                                isdraw.toggle()
                            }else {
                                showingAlert = true
                            }

                        }, icon: "pencil.slash")
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Pro"),
                                message: Text( "Para utilizar todas las herramientas, por favor, adquiere la versión pro."),
                                dismissButton: .default(Text("OK" )))
       
                        }
                        /*.alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Buy it!"),
                                message: Text( "Post cards, 3D Images and Santa Tracker for $1.99."),
                                primaryButton: .destructive(Text("Buy")) {
                                    if let product = store.product(for: store.allBooks[0].id){
                                        store.purchaseProduct(product: product)
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }*/
                        
                        BotonView(action: {
                            if validaCompra(){
                                canvas.drawing = PKDrawing()
                            }else {
                                showingAlert = true
                            }
                            
                        }, icon: "trash")
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Pro"),
                                message: Text( "Para utilizar todas las herramientas, por favor, adquiere la versión pro."),
                                dismissButton: .default(Text("OK" )))
       
                        }
                        /*.alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Buy it!"),
                                message: Text( "Post cards, 3D Images and Santa Tracker for $1.99."),
                                primaryButton: .destructive(Text("Buy")) {
                                    if let product = store.product(for: store.allBooks[0].id){
                                        store.purchaseProduct(product: product)
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }*/
                        
                        BotonView(action: {
                             if validaCompra(){
                                 self.uiImage = UIApplication.shared.windows[0].rootViewController?.view!.getImage(rect: self.rect)

                                 let dispatchGroup = DispatchGroup()

                                 dispatchGroup.enter() // Ingresa al grupo

                                 // Llama a la función saveImageFondoFinalColor y espera a que termine
                                 saveDrawingCanvasFinal { image in
                                     if let image = image {
                                         self.finalImage = image
                                         
                                         // Force view update
                                         self.showShareSheet = true // Mostrar la hoja de compartir después de guardar la imagen
                                     } else {
                                         // Maneja el caso en que finalImage sea nil
                                         print("No se pudo generar la imagen final")
                                     }
                                     
                                     dispatchGroup.leave() // Sale del grupo cuando la operación ha terminado
                                 }
                             }else {
                                 showingAlert = true
                             }
                             
                             showingAlertSave = true
                         }, icon: "square.and.arrow.down.fill")
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Pro"),
                                message: Text( "Para utilizar todas las herramientas, por favor, adquiere la versión pro."),
                                dismissButton: .default(Text("OK" )))
       
                        }
                        .sheet(isPresented: self.$showShareSheet) {
                            if let finalImage = finalImage {
                                ShareSheet(photo: finalImage)
                            } else {
                                // Maneja el caso en que finalImage sea nil
                                Text("No hay imagen para compartir")
                            }
                        }
                        .id(finalImage) // Force view update when finalImage changes
                        
                        
                        /*BotonView(action: {
                            if validaCompra(){
                                saveDrawingCanvas()
                            }else {
                                showingAlert = true
                            }
                            
                            showingAlertSave = true
                        }, icon: "square.and.arrow.down.fill")
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Pro"),
                                message: Text( "Para utilizar todas las herramientas, por favor, adquiere la versión pro."),
                                dismissButton: .default(Text("OK" )))
       
                        }*/
                        /*.alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Buy it!"),
                                message: Text( "Post cards, 3D Images and Santa Tracker for $1.99."),
                                primaryButton: .destructive(Text("Buy")) {
                                    if let product = store.product(for: store.allBooks[0].id){
                                        store.purchaseProduct(product: product)
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }*/
                        /*.alert(isPresented:$showingAlertSave) {
                            Alert(
                                title: Text("Save"),
                                message: Text( "The image was saved in the gallery"),
                                dismissButton: .default(Text("OK" )))
       
                        }*/
                        
                    }
                }
                    }.navigationViewStyle(StackNavigationViewStyle())
     
                }
                //Text(items.descripcion).padding(.top)
            }
        }
    }
    
    func saveDrawingCanvasFinal(completion: @escaping (UIImage?) -> Void) {
        // Captura la imagen de la vista que contiene tanto el canvas como la imagen de fondo
        guard let backgroundImage = UIImage(named: items.emojiFinal) else {
            print("Error al cargar la imagen de fondo.")
            completion(nil) // Llama a completion con nil para indicar un error
            return
        }

        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = canvas.frame
        canvas.addSubview(backgroundImageView)
        canvas.sendSubviewToBack(backgroundImageView)

        // Combinar las imágenes (backgroundImage y canvas)
        guard let combinedImage = canvas.superview?.asImage() else {
            print("Error al combinar la imagen con el texto y el contenido del canvas.")
            completion(nil) // Llama a completion con nil para indicar un error
            return
        }

        // Guardar en el álbum de fotos
        self.finalImage = combinedImage
        self.showShareSheet = true
        //UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)

        // Remover el UIImageView del canvas
        for subview in canvas.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }

        // Llamar a completion con la imagen generada
        completion(combinedImage)
    }
    
    func saveDrawingCanvas() {
        // Captura la imagen de la vista que contiene tanto el canvas como la imagen de fondo
        if let backgroundImage = UIImage(named: items.emojiFinal) {
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.frame = canvas.frame
            canvas.addSubview(backgroundImageView)
            canvas.sendSubviewToBack(backgroundImageView)
        }
        
        if let combinedImage = canvas.superview?.asImage() {
            // Guarda la imagen combinada en la galería de fotos
            UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
        }
        
        // Remueve el UIImageView del canvas
        for subview in canvas.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
    }

    
    /*func saveDrawingCanvas() {
        // Captura la imagen de la vista que contiene tanto el canvas como la imagen de fondo
        if let backgroundImage = UIImage(named: "duende_esfera") {
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.frame = canvas.frame
             canvas.addSubview(backgroundImageView)
             canvas.sendSubviewToBack(backgroundImageView)
        }
        if let combinedImage = canvas.superview?.asImage() {
            self.printUI("saveDrawingCanvas")
            self.printUI(self.canvas.superview?.bounds)
            
            // Guarda la imagen combinada en la galería de fotos
            UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
        }
        
    }*/

    
    // Función para guardar la imagen y el dibujo
    func saveDrawing() {
        // Captura la imagen del canvas
        let drawingImage = canvas.drawing.image(from: canvas.bounds, scale: UIScreen.main.scale)
        
        // Combina la imagen de fondo y el dibujo
        let combinedImage = combineImages(background: backgroundImage, drawing: drawingImage)
        
        // Guarda la imagen combinada en la galería de fotos
        UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
    }
    
    // Función para combinar la imagen de fondo y el dibujo
    func combineImages(background: UIImage, drawing: UIImage) -> UIImage {
        let size = background.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        background.draw(in: CGRect(origin: CGPoint.zero, size: size))
        drawing.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage ?? UIImage()
    }
    
    func validaCompra() -> Bool {
       var compro = false
        if  (store.allBooks[0].lock) {
            print("producto no comprado")
            compro = false
        }else{
            print("producto si comprado")
            compro = true
        }
       return compro
    }
}
