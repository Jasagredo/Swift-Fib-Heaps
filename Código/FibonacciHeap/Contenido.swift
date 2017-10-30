//
//  Contenido.swift
//  FibHeap
//
//  Created by Javier Sagredo on 05/06/2017.
//  Copyright © 2017 Javier Sagredo. All rights reserved.
//

import Foundation
/**
 Protocolo que debe ser implementado por la información que guardemos dentro de un nodo. Utiliza dos Tipos a instanciar, U: Hashable y T: Comparable
 */
public protocol Contenido {
    associatedtype U: Hashable
    associatedtype T: Comparable
    ///Función que devolverá el identificador del contenido
    func id() -> U
    ///Función que devolverá la prioridad del contenido
    func prio() -> T
    ///Función para actualizar un contenido con los datos de otro
    func actualizar(otro: Self)
    
}
