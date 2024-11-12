//
//  AVCaptureViewController.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 19/09/23.
//

import UIKit
import AVFoundation
import SwiftUI

protocol AVCaptureViewControllerDelegate: AnyObject {
    func didCaptureImage(_ image: UIImage)
}

class AVCaptureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    weak var delegate: AVCaptureViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraCapture()
    }
    
    private func setupCameraCapture() {
        let session = AVCaptureSession()
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            fatalError("No se puede acceder a la cámara trasera.")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            session.addInput(input)
        } catch {
            fatalError("Error al configurar la entrada de la cámara: \(error.localizedDescription)")
        }
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        session.addOutput(output)
        
        session.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Convierte el CMSampleBuffer en un UIImage utilizando la función imageFromSampleBuffer
        if let image = imageFromSampleBuffer(sampleBuffer) {
            delegate?.didCaptureImage(image)
        }
    }
    
    func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
        // Convierte el CMSampleBuffer en un CVPixelBuffer
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        
        // Crea una CIImage desde el CVPixelBuffer
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // Crea un contexto de representación de gráficos de Core Graphics
        let context = CIContext()
        
        // Convierte la CIImage en un CGImage
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            // Crea una UIImage desde el CGImage
            let image = UIImage(cgImage: cgImage)
            return image
        }
        
        return nil
    }
 

 





}


