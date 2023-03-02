//
//  ViewController.swift
//  ToyApp
//
//  Created by Erica Veiga on 24/02/23.
//

import UIKit
import FirebaseFirestore
import SwiftUI

class ToyFormViewController: UIViewController {

    @IBOutlet weak var textFielDoador: UITextField!
    @IBOutlet weak var textFieldEndereco: UITextField!
    @IBOutlet weak var SegmentedControlEstado: UISegmentedControl!
    @IBOutlet weak var textFielNome: UITextField!
   
    @IBOutlet weak var textFieldTelefone: UITextField!
    
    @IBOutlet weak var addEditButton: UIButton!
    
    let collection = "toysList"
    
    var toy: ToyItem?
    lazy var firestore : Firestore = {
           let firestore = Firestore.firestore()
           
           let settings = FirestoreSettings()
           settings.isPersistenceEnabled = true
           return firestore
       }()
       
    @IBOutlet weak var ButtonSave: UIButton!
    var listener : ListenerRegistration!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            if let toy = toy {
                title = "Detalhes do Brinquedo"
                textFielNome.text = toy.nome
                SegmentedControlEstado.selectedSegmentIndex = toy.estado
                textFielDoador.text = toy.doador
                textFieldEndereco.text = toy.endereco
                textFieldTelefone.text = toy.telefone
                addEditButton.setTitle("Alterar", for: .normal)
            }
        }
    
    @IBAction func ButtonSave(_ sender: Any) {
        if toy == nil {
                   toy = ToyItem()
               }
               toy!.nome = textFielNome.text!
               toy!.estado = SegmentedControlEstado.selectedSegmentIndex
               toy!.doador = textFielDoador.text!
               toy!.endereco = textFieldEndereco.text!
               toy!.telefone = textFieldTelefone.text!
               
               if toy!.id == nil {
                   firestore.collection(collection).addDocument(data: toy!.toyData())
               } else {
                   firestore.collection(collection).document(toy!.id!).updateData(toy!.toyData())
               }
               navigationController?.popViewController(animated: true)
    }
    
        
    }

    

