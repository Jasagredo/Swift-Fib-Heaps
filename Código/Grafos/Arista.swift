//
//  Arista.swift
//  FibHeap
//
//  Created by Javier Sagredo on 04/06/2017.
//  Copyright © 2017 Javier Sagredo. All rights reserved.
//

import Foundation

/**
 Estructura que abstrae la representación de una arista
 */
public struct Arista {
    ///Vértice desde el que inicia la arista
    public let desde: Vertice
    ///Vértice en el que acaba la arista
    public let hasta: Vertice
    ///Peso de la arista
    public let peso: Double

}

extension Arista: Equatable {
    ///:nodoc:
    public static func ==(lhs: Arista, rhs: Arista) -> Bool{
        return lhs.desde == rhs.desde && lhs.hasta == lhs.hasta && lhs.peso == rhs.peso
    }
    
}

extension Arista: Hashable {
    ///:nodoc:
    public var hashValue: Int {
        return "\(desde)\(hasta)\(peso)".hashValue
    }

}

extension Arista: Comparable {
    ///:nodoc:
    public static func <(lhs: Arista, rhs: Arista) -> Bool{
        return lhs.peso < rhs.peso
    }
    
}

extension Arista: CustomStringConvertible {
    ///:nodoc:
    public var description: String {
        return "\(desde) -(\(peso))> \(hasta)"
    }
    
}

