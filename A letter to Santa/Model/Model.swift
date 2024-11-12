//
//  Model.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 13/09/23.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory : CaseIterable {
    
    case horizontal
    case vertical
 
    
    var label : String {
        get {
            switch self {
            case .horizontal:
                return "horizontal"
            case .vertical:
                return "vertical"
 
            }
        }
    }
}

class Model {
    var name : String
    var category : ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scale : Float
    
    var cancellable : AnyCancellable?
    
    init(name: String, category: ModelCategory, scale: Float = 1.0){
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scale = scale
    }
    
    func loadModel(){
        let filename = name + ".usdz"
        print(filename)
        cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .failure(let error):
                    print("Error al cargar el modelo", error.localizedDescription)
                case .finished:
                    print("success")
                    break
                }
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scale
            })
    }
    
}

struct Models {
    var all: [Model] = []
    
    init(){
        all = [
            Model(name: "Christmas_Lights", category: .vertical, scale: 3/100),

            Model(name: "gift_box", category: .horizontal, scale: 3/100),
 
            Model(name: "Snowflake", category: .vertical, scale: 3/100),
 
            Model(name: "Christmas_Wreath", category: .vertical, scale: 3/100),
 
            Model(name: "Christmas_gingerbread_man", category: .vertical, scale: 3/100),
            Model(name: "Neon_christmas_tree_-_Day_12", category: .vertical, scale: 3/100),
            Model(name: "Christmas_Star", category: .vertical, scale: 3/100),
            Model(name: "Christmas_Lights", category: .vertical, scale: 3/100),
            Model(name: "Christmas_gate", category: .vertical, scale: 3/100),
            Model(name: "christmas_bell", category: .vertical, scale: 3/100),
            Model(name: "Larrys_Christmas_Cookies", category: .horizontal, scale: 3/100),
            Model(name: "Low-Poly_Christmas_Presents", category: .horizontal, scale: 3/100),

            //Model(name: "Milk_and_Cookies_for_Santa", category: .food, scale: 3/100),
            Model(name: "Stack_of_Christmas_Gifts", category: .horizontal, scale: 3/100),
            Model(name: "christmas_balls_dos", category: .horizontal, scale: 3/100),
            Model(name: "christmas_coffee_and_cake", category: .horizontal, scale: 3/100),
            Model(name: "christmas_gift_boxes", category: .horizontal, scale: 3/100),
            Model(name: "christmas_gift_shop", category: .horizontal, scale: 3/100),
            Model(name: "christmas_house", category: .horizontal, scale: 3/100),
            Model(name: "christmas_wreath_dos", category: .vertical, scale: 3/100),
            Model(name: "datesroyale_christmas_scene", category: .vertical, scale: 3/100),
            Model(name: "merry_christmas_dos", category: .horizontal, scale: 3/100),
            Model(name: "christmas_pack", category: .vertical, scale: 3/100),
 
 
        ]
    }
    
    func get(category: ModelCategory) -> [Model] {
        return all.filter( {$0.category == category} )
    }
    
    
}
