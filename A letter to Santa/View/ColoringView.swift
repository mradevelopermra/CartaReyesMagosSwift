import SwiftUI

struct ColoringView: View {
    @State private var drawing = false
    @State private var lastPoint: CGPoint = .zero
    @State private var image = UIImage(named: "bota_dot.png") // Reemplaza "imagen_de_fondo" con el nombre de tu imagen de fondo.
    
    var body: some View {
        GeometryReader { geometry in
            Image(uiImage: image!)
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            draw(at: value.location)
                        }
                        .onEnded { value in
                            drawing = false
                        }
                )
        }
    }
    
    func draw(at point: CGPoint) {
        guard let cgImage = image?.cgImage else { return }
        
        let scale = UIScreen.main.scale
        let adjustedPoint = CGPoint(x: point.x * scale, y: (image!.size.height - point.y) * scale)
        
        let color = UIColor.red.cgColor // Color de dibujo
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: cgImage.width * 4, space: cgImage.colorSpace!, bitmapInfo: bitmapInfo.rawValue)!
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        
        context.setBlendMode(.normal)
        context.setFillColor(color)
        context.setAlpha(1.0)
        context.beginPath()
        context.addArc(center: adjustedPoint, radius: 10, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        context.closePath()
        context.fillPath()
        
        if let newImage = context.makeImage() {
            image = UIImage(cgImage: newImage)
        }
    }
}
 
