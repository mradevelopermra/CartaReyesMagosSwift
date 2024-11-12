//
//  ListaPodCardsView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 29/08/23.
//

import SwiftUI
import PencilKit
import LinkPresentation
import StoreKit
import Combine


struct ListaPodCardsView: View {
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
                        Text("Buy all post cards")
                    }, icon: {
                        Image(systemName: "pencil")
                    })
                }.padding()
                 .frame(width: UIScreen.main.bounds.width - 30 )
                .backgroundStyle(Color.blue)
                .cornerRadius(0)
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: 0x2d572c)) 
                
                /*NavigationLink(
                    destination: VistaDetalle(items: lista[0])){
                       VStack{
                           emoji(emoji: lista[0] )
                           Text(lista[0].nombre)
                               .font(.subheadline)
                       }
                    }*/
                
            }else{

 
            }


            
            NavigationStack {
 
 
                List(lista) { item in
                    NavigationLink(
                       destination: VistaDetalle(items: item)){
                           VStack{
                               emoji(emoji: item)
                               Text(item.nombre)
                                   .font(.title).bold().foregroundColor(.white)
                                   .background(Color(hex: 0xb8000e))
                                   .frame(maxWidth: .infinity, maxHeight: .infinity)
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

                }.navigationTitle("Choose a post card")
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

struct emoji: View {
    let emoji : ModeloLista
    var body: some View{
        ZStack {
           /* Text(emoji.emoji)
                .shadow(radius: 3)
                .font(.largeTitle)
                .frame(width: 160, height: 160, alignment: .center)
                .overlay {
                    Circle().stroke(Color.purple, lineWidth: 3)
                }*/
            Image(uiImage: UIImage(named: emoji.emoji)!)
                .resizable()
                .frame(width: UIScreen.screenWidth - (UIScreen.screenWidth / 4), height: UIScreen.screenWidth - (UIScreen.screenWidth / 4))
            
        }
        
    }
    
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        let renderer = UIGraphicsImageRenderer(size: view!.bounds.size)
        return renderer.image { _ in
            view!.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}

struct VistaDetalle: View {
    
    //Vatiabls para dibujar
     @State var canvas = PKCanvasView()
    @State var isdraw = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pencil
    @State var colorPicker = false
    
    @State private var rect: CGRect = .zero
    @State private var uiImage: UIImage? = nil
    @State private var showShareSheet = false
    
    let items : ModeloLista
    @Environment(\.undoManager) private var undoManager
    @EnvironmentObject private var store: Store
 
    @State private var backgroundImage: UIImage?
    @State private var showingAlertSave = false
    
    @State var isCanvasModalPresented = false
    @State private var isSheetPresented = false
     @State private var capturedImage: UIImage?
 
    var body: some View{
 
        Button("Mostrar Canvas") {
            //adjustCanvasSize()
            capturedImage = captureScreen()
 
                    isCanvasModalPresented = true
 
                }
                .sheet(isPresented: $isCanvasModalPresented) {
                    CanvasModalView(
                        isPresented: $isCanvasModalPresented,
                        canvas: $canvas,
                        color: $color,
                        type: $type,
                        isDraw: $isdraw, capturedImage: $capturedImage,
                        backgroundImage: UIImage(named: items.emoji)!
                    )
                }
        
        VStack(alignment: .leading, spacing: 3, content: {
            HStack{
                Spacer()
                NavigationView {

                    CanvasViewCard(backgroundImage: UIImage(named: items.emoji)!, canvas: $canvas, color: $color, type: $type, isDraw: $isdraw, items: items)
                        .navigationTitle("Draw")
                        .navigationBarTitleDisplayMode(.inline)
                        .background(Image(uiImage: UIImage(named: items.emoji)!)
                             .resizable()
                              .frame(width: 612, height: 612)
                            )
                        .toolbar {
                            HStack{
                                ColorPicker("", selection: $color)
 
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
                                
                                BotonView(action: {
                                    saveImage()
                                    showingAlertSave = true
                                }, icon: "square.and.arrow.down.fill").alert(isPresented:$showingAlertSave) {
                                    Alert(
                                        title: Text("Save"),
                                        message: Text( "The image was saved in the gallery"),
                                        dismissButton: .default(Text("OK" )))
               
                                }
                                
                            }
                        }
                    
                }.navigationViewStyle(StackNavigationViewStyle())
 
            }
            Text(items.descripcion).padding(.top)
            Spacer()
        })
        .padding(.all)
        .navigationBarTitle("Dot to dot and fill")
        .onAppear {
                   // Cargar la imagen de fondo
                   backgroundImage = UIImage(named: items.emoji)
                    modificatamano()
               }
        

    }
    
    func adjustCanvasSize() {
            // Ajusta el tamaño del PKCanvasView según tus necesidades
            let canvasSize = CGSize(width: 400, height: 400)
         canvas.frame = CGRect(origin: .zero, size: canvasSize)
        }
        
   /*func captureScreen() -> UIImage? {
            let renderer = UIGraphicsImageRenderer(bounds:  canvas.bounds)
            return renderer.image { context in
                 canvas.drawHierarchy(in:  canvas.bounds, afterScreenUpdates: true)
            }
    }*/
    
    func captureScreen() -> UIImage {
        // Asegúrate de que ambos tengan el mismo tamaño
        let size = backgroundImage?.size ?? CGSize(width: 612, height: 612)

        // Captura una imagen de la vista CanvasViewCard
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            let context = UIGraphicsGetCurrentContext()!
            // Dibuja la imagen de fondo
            backgroundImage?.draw(in: CGRect(origin: .zero, size: size))
            // Dibuja el contenido del canvas
            canvas.layer.render(in: context)
        }

        return image
    }

 
    
    func cambioTamano(){
        backgroundImage = UIImage(named: items.emoji)!
         if let backgroundImage = backgroundImage {
            // Ajusta el marco del PKCanvasView para que coincida con las dimensiones de la imagen de fondo
            canvas.frame = CGRect(origin: .zero, size: backgroundImage.size)
        }
    }
    
    private var splashImageBackground: some View {
          GeometryReader { geometry in
              Image(items.emoji)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .edgesIgnoringSafeArea(.all)
                  .frame(width: geometry.size.width)
          }
      }
    
    func saveImage() {
        
        // getting image from Canvas
        //creaFondo()
        backgroundImage = UIImage(named: items.emoji)!
        if let backgroundImage = backgroundImage {
            // Ajusta el marco del PKCanvasView para que coincida con las dimensiones de la imagen de fondo
            canvas.frame = CGRect(origin: .zero, size: backgroundImage.size)
        }
        self.printUI("Guarda imagen")
        self.printUI(canvas.frame.size)
       self.printUI(backgroundImage!.size)
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        self.printUI("Antes de combinar la imagen")
        self.printUI(canvas.frame.size)
       self.printUI(backgroundImage!.size)
        let combinedImage = combineImages(background: backgroundImage!, drawing: image)
        // saving to album
        
        UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
 
    }
    
    func combineImages(background: UIImage, drawing: UIImage) -> UIImage {
        // Asegúrate de que ambos tengan el mismo tamaño
        let size = background.size
        
        // Redimensiona el dibujo al tamaño del fondo
        let resizedDrawing = drawing.resized(to: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        background.draw(in: CGRect(origin: CGPoint.zero, size: size))
        resizedDrawing.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        self.printUI("combineImages")
        self.printUI(background.size)
        self.printUI(resizedDrawing.size)
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.printUI("despues_combinedImage")
        self.printUI(combinedImage!.size)
        return combinedImage ?? UIImage()
    }



    
    /* func combineImages(background: UIImage, drawing: UIImage) -> UIImage {
        let size = background.size

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        background.draw(in: CGRect(origin: CGPoint.zero, size: size))
        drawing.draw(in: CGRect(origin: CGPoint.zero, size: size))

        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage ?? UIImage()
    }*/
    

    
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
    
    func creaFondo(){
        backgroundImage = UIImage(named: items.emoji)!
    }
    
    func modificatamano(){
        backgroundImage = UIImage(named: items.emoji)!
        if let backgroundImage = backgroundImage {
            // Ajusta el marco del PKCanvasView para que coincida con las dimensiones de la imagen de fondo
            canvas.frame = CGRect(origin: .zero, size: backgroundImage.size)

        }
    }
}



 

struct CanvasModalView: View {
    @Binding var isPresented: Bool
    @Binding var canvas : PKCanvasView
    @Binding var color : Color
    @Binding var type : PKInkingTool.InkType
    @Binding var isDraw : Bool
    @Binding var capturedImage: UIImage?
    let backgroundImage: UIImage
    @State private var combinedImage: UIImage?
 
    var body: some View {
        VStack {
 
            Image(uiImage: combinedImage!)
             /*Image(uiImage: combineImages(background: backgroundImage, drawing: canvas.drawing.image(from: canvas.drawing.bounds, scale: UIScreen.main.scale)))*/
            
          /*Image(uiImage: combineImages(background: backgroundImage, drawing: canvas.drawing.image(from: canvas.drawing.bounds, scale: UIScreen.main.scale)))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width)*/
            
            /*CanvasView(canvas: $canvas, color: $color, type: $type, isDraw: $isDraw)*/
 
            /*Button("Guardar") {
                // Aquí puedes implementar la lógica para guardar la imagen con el dibujo en el canvas
                // y luego cerrar la ventana modal
                isPresented = false
            }
            .padding()*/
        }
 
 
    }
    
    func muestraImagenConbinada(){
        combinedImage = combineImages(background: backgroundImage, drawing: canvas.drawing.image(from: canvas.drawing.bounds, scale: UIScreen.main.scale))
    }
    
    func combineImages(background: UIImage, drawing: UIImage) -> UIImage {
        let size = background.size
        // Redimensiona el dibujo al tamaño del fondo
        let resizedDrawing = drawing.resized(to: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
         background.draw(in: CGRect(origin: CGPoint.zero, size: size))
         resizedDrawing.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        self.printUI("background_modal")
        self.printUI(background.size)
        self.printUI(resizedDrawing.size)
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage ?? UIImage()
    }

}



extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}


struct VistaDetalleDemo: View {
    
    //Vatiabls para dibujar
     @State var canvas = PKCanvasView()
    @State var isdraw = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pencil
    @State var colorPicker = false
    
    @State private var rect: CGRect = .zero
    @State private var uiImage: UIImage? = nil
    @State private var showShareSheet = false
    
    @State private var showingAlert = false
    
    let items : ModeloLista
    @Environment(\.undoManager) private var undoManager

    @EnvironmentObject private var store: Store
    
    var body: some View{
        VStack(alignment: .leading, spacing: 3, content: {
            HStack{
 
                Spacer()
                
                NavigationView { // ios 16 NavigationStack
                    CanvasViewCard(backgroundImage: UIImage(named: items.emoji)!, canvas: $canvas, color: $color, type: $type, isDraw: $isdraw, items: items)
                        .navigationTitle("Draw")
                        .navigationBarTitleDisplayMode(.inline)
                        .background(Image(uiImage: UIImage(named: items.emoji)!)
                            .resizable()
                            .frame(width: UIScreen.screenWidth - 50)
                        
                            )
                        .toolbar {
                            HStack{
                                ColorPicker("", selection: $color)
                                
                                /*BotonView(action: {
                                    type = .pencil
                                }, icon: "pencil")
                                
                                BotonView(action: {
                                    type = .pen
                                }, icon: "pencil.tip")
                                
                                BotonView(action: {
                                    type = .marker
                                }, icon: "highlighter")*/
                                
                                BotonView(action: {
                                    if validaCompra(){
                                        undoManager?.undo()
                                    }else {
                                        showingAlert = true
                                    }
                                    
                                }, icon: "arrow.uturn.backward")
                                .alert(isPresented:$showingAlert) {
                                    Alert(
                                        title: Text("Draw"),
                                        message: Text( "Please buy post cards, before to draw"),
                                        primaryButton: .destructive(Text("Buy")) {
                                            if let product = store.product(for: store.allBooks[0].id){
                                                store.purchaseProduct(product: product)
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                
                                BotonView(action: {
                                    if validaCompra(){
                                        undoManager?.redo()
                                    }else {
                                        showingAlert = true
                                    }
                                    
                                }, icon: "arrow.uturn.forward")
                                .alert(isPresented:$showingAlert) {
                                    Alert(
                                        title: Text("Draw"),
                                        message: Text( "Please buy post cards, before to draw"),
                                        primaryButton: .destructive(Text("Buy")) {
                                            if let product = store.product(for: store.allBooks[0].id){
                                                store.purchaseProduct(product: product)
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
     
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
                                        title: Text("Draw"),
                                        message: Text( "Please buy post cards, before to draw"),
                                        primaryButton: .destructive(Text("Buy")) {
                                            if let product = store.product(for: store.allBooks[0].id){
                                                store.purchaseProduct(product: product)
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                
                                BotonView(action: {
                                    if validaCompra(){
                                        canvas.drawing = PKDrawing()
                                    }else {
                                        showingAlert = true
                                    }
                                    
                                }, icon: "trash")
                                .alert(isPresented:$showingAlert) {
                                    Alert(
                                        title: Text("Draw"),
                                        message: Text( "Please buy post cards, before to draw"),
                                        primaryButton: .destructive(Text("Buy")) {
                                            if let product = store.product(for: store.allBooks[0].id){
                                                store.purchaseProduct(product: product)
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                
                                BotonView(action: {
                                    if validaCompra(){
                                         saveImage()
                                    }else {
                                        showingAlert = true
                                    }
                                    
                                    
                                }, icon: "square.and.arrow.down.fill")
                                .alert(isPresented:$showingAlert) {
                                    Alert(
                                        title: Text("Draw"),
                                        message: Text( "Please buy post cards, before to draw"),
                                        primaryButton: .destructive(Text("Buy")) {
                                            if let product = store.product(for: store.allBooks[0].id){
                                                store.purchaseProduct(product: product)
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                
                            }
                        }
                    
                }.navigationViewStyle(StackNavigationViewStyle())
                
                /*NavigationView {
 
                
                    DrawingViewCard(canvas: $canvas, isdraw: $isdraw, type: $type, color: $color, items: items)
                        .navigationTitle("Draw postcards")
                        .font(.system(size: 35))
                        .navigationBarTitleDisplayMode(.inline)
                        .foregroundColor(Color(hex: 0x2d572c))
                        .background(Image(uiImage: UIImage(named: items.emoji)!)
                            .resizable()
                            .frame(width: UIScreen.screenWidth)
                        
                            )

                        .navigationBarItems(leading:
                                                
                                                Button(action: {
                            self.uiImage = UIApplication.shared.windows[0].rootViewController?.view!.getImage(rect: self.rect)
                            self.showShareSheet.toggle()
                        }) {
                            Image(systemName: "square.and.arrow.down.fill")
 
                                .padding()
                                .background(Color.white)
                                .foregroundColor(Color(hex: 0xd8ae2d))
 
                        }.sheet(isPresented: self.$showShareSheet) {
                            ShareSheet(photo: canvas.drawing.image(from: canvas.drawing.bounds, scale: 1))
                        }.padding(), trailing: HStack(spacing: 15) {
                            
                            Button(action: {
                                
                                // erase tool
                                
                                isdraw = false
                                canvas.drawing = PKDrawing()
                                isdraw.toggle()
                                
                            }) {
                                
                                Image(systemName: "pencil.slash")
                                    .font(.title)
                                    .foregroundColor(Color(hex: 0xd8ae2d))
                            }
                            
                            Button(action: {
                                
                                // undo tool
                                undoManager?.undo()
                                
                            }) {
                                
                                Image(systemName: "arrow.uturn.backward")
                                    .font(.title)
                                    .foregroundColor(Color(hex: 0xd8ae2d))
                            }
                            
                            Button(action: {
                                
                                // Redo tool
                                undoManager?.redo()
                                
                            }) {
                                
                                Image(systemName: "arrow.uturn.forward")
                                    .font(.title)
                                    .foregroundColor(Color(hex: 0xd8ae2d))
                            }
 
                            
                            Menu {
                                
                                // ColorPicker
                                
                                ColorPicker(selection: $color) {
                                    
                                    Button(action: {
                                        
                                        colorPicker.toggle()
                                    }) {
                                        Label {
                                            
                                            Text("Color")
                                        } icon: {
                                            
                                            Image(systemName: "eyedropper.full")
                                                .foregroundColor(Color.orange)
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                Button(action: {
                                    
                                    // changing type
                                    
                                    isdraw = true
                                    type = .pencil
                                }) {
                                    
                                    Label {
                                        
                                        Text("Pencil")
                                    } icon: {
                                        
                                        Image(systemName: "pencil")
                                    }
                                    
                                }
                                
                                Button(action: {
                                    isdraw = true
                                    type = .pen
                                }) {
                                    
                                    Label {
                                        
                                        Text("Pen")
                                    } icon: {
                                        
                                        Image(systemName: "pencil.tip")
                                    }
                                    
                                }
                                Button(action: {
                                    isdraw = true
                                    type = .marker
                                }) {
                                    
                                    Label {
                                        
                                        Text("Marker")
                                    } icon: {
                                        
                                        Image(systemName: "highlighter")
                                    }
                                    
                                }
                                
                                
                            } label: {
                                Image(systemName: "pencil.line")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(Color(hex: 0xd8ae2d))
                            }
                            
                            
                        })
                        .sheet(isPresented: $colorPicker) {
                            
                            ColorPicker("Pick Color", selection: $color)
                                .padding()
                        }
                    
                    
                }.foregroundColor(Color(hex: 0x2d572c))*/
                    
            }
            Text(items.descripcion).padding(.top)
            Spacer()
        })
        .padding(.all)
        .navigationBarTitle("Dot to dot and fill")
        

    }
    
    private var splashImageBackground: some View {
          GeometryReader { geometry in
              Image(items.emoji)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .edgesIgnoringSafeArea(.all)
                  .frame(width: geometry.size.width)
          }
      }
    
    func saveImage() {
        
        // getting image from Canvas
        
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
 
        // saving to album
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
 
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

struct DrawOnImageView: View {
    let items : ModeloLista
    @State var image: UIImage?

    let onSave: (UIImage) -> Void

    @State private var canvasView: PKCanvasView = PKCanvasView()

    init(items: ModeloLista, onSave: @escaping (UIImage) -> Void) {
        self.items = items
        self.onSave = onSave
        self._image = State(initialValue: UIImage(named: items.emoji))
    }




    var body: some View {
        VStack {
            Button(action: { save() }) {
                Text("Save")
            }

            /*Image(uiImage: items.emoji)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all)
                .overlay(CanvasViewNew(canvasView: $canvasView, onSaved: onChanged), alignment: .bottomLeading)*/
            
            if let image = UIImage(named: items.emoji) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(CanvasViewNew(canvasView: $canvasView, onSaved: onChanged), alignment: .bottomLeading)
            } else {
                // Manejar el caso en el que no se puede cargar la imagen
            }
        }
        .onAppear {
            initCanvas()
        }
    }

    private func onChanged() -> Void {
        let drawingOnImage = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
        // Actualiza el valor al que está vinculado el Binding de la imagen
        image = image!.mergeWith(topImage: drawingOnImage)
    }

    private func initCanvas() -> Void {
        canvasView.isOpaque = false
        canvasView.backgroundColor = UIColor.clear
        canvasView.becomeFirstResponder()
    }

    private func save() -> Void {
        onSave(image!)
    }
}


public extension UIImage {
    func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self

        UIGraphicsBeginImageContext(size)


        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)

        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}

struct CanvasViewNew {
    @Binding var canvasView: PKCanvasView
    let onSaved: () -> Void

    @State var toolPicker = PKToolPicker()
}

extension CanvasViewNew: UIViewRepresentable {
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
        #if targetEnvironment(simulator)
        canvasView.drawingPolicy = .anyInput
        #endif
        canvasView.delegate = context.coordinator
        showToolPicker()
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: $canvasView, onSaved: onSaved)
    }
}

private extension CanvasViewNew {
    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
}

class Coordinator: NSObject {
    var canvasView: Binding<PKCanvasView>
    let onSaved: () -> Void

    init(canvasView: Binding<PKCanvasView>, onSaved: @escaping () -> Void) {
        self.canvasView = canvasView
        self.onSaved = onSaved
    }
}

extension Coordinator: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if !canvasView.drawing.bounds.isEmpty {
            onSaved()
        }
    }
}

struct DrawingViewCard: UIViewRepresentable {
    // to capture drawings for saving into albums
    @Binding var canvas: PKCanvasView
    @Binding var isdraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    let items : ModeloLista
    

    
     var ink : PKInkingTool {
        
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.drawingPolicy = .anyInput
        canvas.tool = isdraw ? ink : eraser
        canvas.backgroundColor = .clear
 
        //let imageView = UIImageView(image: UIImage(named: items.emoji))
        //canvas.insertSubview(imageView, at: 1)
  
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // updating the tool whenever the view updates
        
        uiView.tool = isdraw ? ink : eraser
        
    }
}
 
 
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
 

struct CanvasViewCard : UIViewRepresentable {
    var backgroundImage: UIImage?
    @Binding var canvas : PKCanvasView
    @Binding var color : Color
    @Binding var type : PKInkingTool.InkType
    @Binding var isDraw : Bool
    @State var tootlPicker = PKToolPicker()
    let items : ModeloLista
 
    var pencil : PKInkingTool {
        PKInkingTool(type, color: UIColor(color) )
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    /*func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.contentMode = .scaleAspectFit
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? pencil : eraser
        canvas.backgroundColor = .clear
        canvas.frame = CGRect(origin: .zero, size: backgroundImage!.size)
 
        self.printUI("makeUIView")
        self.printUI(canvas.frame.size)
        self.printUI(backgroundImage!.size)
        showToolPicker()
        return canvas
    }*/
    
    /*func makeUIView(context: Context) -> PKCanvasView {
 
        canvas.contentMode = .scaleAspectFit
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? pencil : eraser
        canvas.backgroundColor = .clear

        // Ajusta el tamaño del canvas a la misma escala que la imagen de fondo
        if let backgroundImage = backgroundImage {
            let scale = UIScreen.main.scale
            //let size = CGSize(width: backgroundImage.size.width * scale, height: backgroundImage.size.height * scale)
            let size = CGSize(width: 612, height: 612)
            canvas.frame = CGRect(origin: .zero, size: size)
        }

        self.printUI("makeUIView")
        self.printUI(canvas.frame.size)
        self.printUI(backgroundImage!.size)
        showToolPicker()
        return canvas
    }*/
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.contentMode = .scaleAspectFit
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? pencil : eraser
        canvas.backgroundColor = .clear

        // Ajusta el tamaño del canvas para que coincida con la imagen de fondo
        if let backgroundImage = backgroundImage {
            //let size = backgroundImage.size
 
            let size = CGSize(width: 612, height: 612) // Establece el tamaño deseado
            canvas.frame = CGRect(origin: .zero, size: size)
 
        }
        


        self.printUI("makeUIView")
        self.printUI(canvas.frame.size)
        self.printUI(backgroundImage!.size)
        showToolPicker()
        return canvas
    }


    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDraw ? pencil : eraser
    }
    
}

extension CanvasViewCard {
    func showToolPicker() {
        tootlPicker.setVisible(true, forFirstResponder: canvas)
        tootlPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
    }
}

struct ProductRow: View{
    let product : Products
    let actions : () -> Void
    
    var body: some View{
        HStack{
            VStack(alignment: .leading) {
                Text(product.title).font(.title).bold()
                Text(product.description).font(.subheadline).bold()
            }
            Spacer()
            if let price = product.price, product.lock {
                Button(action: actions) {
                    Text(price)
                }
            }
        }
    }
}


struct BookRow: View {
    
    let book : Books
    let action : () -> Void
    
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text(book.title).font(.title).bold()
                Text(book.description).font(.subheadline).bold()
            }
            Spacer()
            if let price = book.price, book.lock {
                Button(action: action){
                    Text(price)
                }
            }
        }
    }
}
