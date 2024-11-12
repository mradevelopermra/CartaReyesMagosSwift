//
//  CustomARView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 13/09/23.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity


class CustomARView : ARView {
    
    var focusEntity : FocusEntity?
    
    required init(frame: CGRect){
        super.init(frame: frame)
        focusEntity = FocusEntity(on: self, focus: .classic)
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
 
