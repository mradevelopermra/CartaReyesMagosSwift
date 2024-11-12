import SwiftUI
import PencilKit

struct ColoringViewDos: View {
    @State private var canvas = PKCanvasView()
    @State private var isDrawing = true
    @State private var image = UIImage(named: "bota_dot.png") // Reemplaza "imagen_completa" con el nombre de tu imagen completa.
    
    var body: some View {
        //NavigationView {
            VStack {
                // Vista de lienzo para colorear
                CanvasViewDos(canvasView: $canvas, isDrawing: $isDrawing)
                    .background(Image(uiImage: image!)
                                    .resizable()
                                    .scaledToFit()
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                isDrawing = true
                            }
                            .onEnded { _ in
                                isDrawing = false
                            }
                    )
                
                // Botón para cambiar entre dibujo y borrado
                Button(action: toggleDrawing) {
                    Text(isDrawing ? "Borrar" : "Dibujar")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
          /*  .navigationBarTitle("Colorear Imagen")
        }*/
    }
    
    func toggleDrawing() {
        isDrawing.toggle()
        canvas.tool = isDrawing ? PKInkingTool(.pen, color: .black) : PKEraserTool(.bitmap)
    }
}

struct CanvasViewDos: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var isDrawing: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pen, color: .black)
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDrawing ? PKInkingTool(.pen, color: .black) : PKEraserTool(.bitmap)
    }
}

 
