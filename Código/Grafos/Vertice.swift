//
//  Vertice.swift
//  adasdads
//
//  Created by Javier Sagredo on 04/06/2017.
//  Copyright © 2017 Javier Sagredo. All rights reserved.
//

import Foundation
/**
 Clase que abstrae la representación de un vértice
 */
public struct Vertice {
    ///Nombre del vértice
    public var id: String
    ///:nodoc:
    public var indice: Int

}

extension Vertice: Equatable{
    ///:nodoc:
    public static func ==(lhs: Vertice, rhs: Vertice) -> Bool{
        return lhs.id == rhs.id
    }
}

extension Vertice: Hashable {
    ///:nodoc:
    public var hashValue: Int {
        return "\(id)\(indice)".hashValue
    }
    
}

extension Vertice: CustomStringConvertible {
    ///:nodoc:
    public var description: String {
        return "\(id): \(indice)"
    }
    
}
