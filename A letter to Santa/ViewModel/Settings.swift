//
//  Settings.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 13/09/23.
//

import SwiftUI
import Combine

class Settings : ObservableObject {
    
    
    
    @Published var selectedModel : Model? {
        willSet(newValue){
            print("Seleccionamos el modelo")
        }
    }
    
    @Published var confirmedModel : Model? {
        willSet(newValue){

            
                guard let model = newValue else { return }

                print("Confirmamos el modelo", model.name)
 
        }
    }
    
    var sceneObserver : Cancellable?
    
    
}
