//
//  Books.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 04/09/23.
//

import Foundation
import StoreKit

struct Books: Hashable {
    let id : String
    let title : String
    let description : String
    var lock : Bool
    var price : String?
    let locale : Locale
    
    lazy var formatter : NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = locale
        return nf
    }()
    
    init(product: SKProduct, lock: Bool = true){
        self.id = product.productIdentifier
        self.title = product.localizedTitle
        self.description = product.localizedDescription
        self.lock = lock
        self.locale = product.priceLocale
        if lock {
            self.price = formatter.string(from: product.price)
        }
        
    }
    
}
