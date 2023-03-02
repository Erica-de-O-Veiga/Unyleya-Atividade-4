//
//  ToyTableViewController.swift
//  ToyApp
//
//  Created by Erica Veiga on 24/02/23.
//

import UIKit
import FirebaseFirestore

class ToyTableViewController: UITableViewController {
    
    
    let collection = "toysList"
    
    var toyList: [ToyItem] = []
    lazy var firestore : Firestore = {
           let firestore = Firestore.firestore()
           
           let settings = FirestoreSettings()
           settings.isPersistenceEnabled = true
           return firestore
       }()
       
    @IBOutlet weak var ButtonSave: UIButton!
    var listener : ListenerRegistration!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadToysList()
        
    }
    
    func ShowAlertForItem( _ item: ToyItem? = nil){
        let  alert = UIAlertController( title: "Brinquedo", message: "Informe o nome do brinquedo", preferredStyle: .alert)
        
        alert.addTextField { textField  in
            textField.placeholder = "Nome"
            textField.text = item?.nome
        }
        alert.addTextField { textField  in
            textField.placeholder = "Telefone"
            textField.text = item?.telefone
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            guard let nome =  alert.textFields?.first?.text,
                  let telefone = alert.textFields?.last?.text else {
                return
            }
            let data:[String: Any] = [
                "nome": nome,
                "telefone": telefone
            ]
            if let item = item {
                self.firestore.collection(self.collection).document(item.id!).updateData(data)
               
            } else {
                self.firestore.collection(self.collection).addDocument(data: data)
            }
            
            
        }
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func addItem(_ sender: Any) {
        
    }
    
    func loadToysList(){
        
            listener = firestore.collection(collection).order(by: "nome", descending:false).addSnapshotListener(includeMetadataChanges: true, listener: {
                snapshot, error in
                
                if let error = error {
                    print (error)
                }else {
                    guard let snapshot = snapshot else {
                        print ("erroooo fdp")
                        return
                    }
                    print (snapshot.documents.count)
                    print(snapshot.documents)
                    print ("Total de documentos alterados: \(snapshot.documentChanges.count)")
                    if  snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                        self.showItensFrom(snapshot)
                    }
                }
            })
        }
        
        func showItensFrom(_ snaphot: QuerySnapshot){
            toyList.removeAll()
            for document  in snaphot.documents {
                let data = document.data()
                if let nome = data["nome"] as? String,
                   let estado = data["estado"] as? Int,
                   let doador = data["doador"] as? String,
                   let endereco = data["endereco"] as? String,
                   let telefone = data["telefone"] as? String {
                    let toyItem = ToyItem()
                    toyItem.id = document.documentID
                    toyItem.nome = nome
                    toyItem.estado = estado
                    toyItem.doador = doador
                    toyItem.endereco = endereco
                    toyItem.telefone = telefone
                                         
                    
                    toyList.append(toyItem)
                }
            }
            tableView.reloadData()
        }
        
        
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return toyList.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            let toysItem = toyList[indexPath.row]
            cell.textLabel?.text = toysItem.nome
            cell.detailTextLabel?.text = "\(toysItem.telefone)"
            
            return cell
        }
        
        
        /*
         // Override to support conditional editing of the table view.
         override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
         }
         */
        
        /*
         // Override to support editing the table view.
         override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
         // Delete the row from the data source
         tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
         }
         */
        
        /*
         // Override to support rearranging the table view.
         override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
         
         }
         */
        
        /*
         // Override to support conditional rearranging of the table view.
         override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
         }
         */
        
        
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             if let toyFormViewController = segue.destination as? ToyFormViewController{
                     toyFormViewController.firestore = firestore
                     if let row = tableView.indexPathForSelectedRow?.row {
                         toyFormViewController.toy = toyList[row]
                     }
                 }
         }
         
        
    }


