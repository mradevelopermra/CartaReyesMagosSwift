//
//  DalleViewModel.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 28/08/23.
//

import Foundation

class DalleViewModel: ObservableObject {
    
    let session = UUID().uuidString
    
    func generarImagen(texto:String) async throws -> ImageModel {
        
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {  throw ImageError.badURL }
        
        let parametros: [String: Any] = [
            "prompt": texto,
            "n":1,
            "size":"256x256",
            "user":session
        ]
        
        let data: Data = try JSONSerialization.data(withJSONObject: parametros)
        let apikey = ""
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (response, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(ImageModel.self, from: response)
        return result
        
    }
    
}

enum ImageError: Error {
    case badURL
}
