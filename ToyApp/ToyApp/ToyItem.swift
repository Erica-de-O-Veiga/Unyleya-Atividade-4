//
//  ToyItem.swift
//  ToyApp
//
//  Created by Erica Veiga on 24/02/23.
//

import Foundation

class ToyItem : Codable {
    var id: String?
    var nome: String = ""
    var estado: Int = 0
    var doador: String = ""
    var endereco: String = ""
    var telefone: String = ""
    
    var conservationState: String {
        switch estado {
        case 0:
            return "Novo"
        case 1:
            return "Usado"
        default:
            return "Precisa de reparos"
        }
    }
    
    func toyData() -> [String: Any] {
        return [
            "id": self.id,
            "nome": self.nome,
            "estado": self.estado,
            "doador": self.doador,
            "endereco": self.endereco,
            "telefone": self.telefone
        ]
    }
}
    


