//
//  ListarPalavrasTableViewController.swift
//  Dicionario
//
//  Created by zavarese on 15/12/20.
//

import UIKit
import CoreData

class ListarPalavrasTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    var context : NSManagedObjectContext!
    @IBOutlet weak var searchBar: UISearchBar!
    var dicionario : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarPalavras()
    }
    
    func recuperarPalavras(){
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Dicionario")
        let ordenacao = NSSortDescriptor(key: "palavra", ascending: true)
        requisicao.sortDescriptors = [ordenacao]
        
        do {
            let palavrasRecuperadas = try context.fetch(requisicao)
            self.dicionario = palavrasRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
        } catch let erro {
            print("Erro na recuperacao das palavras: \(erro.localizedDescription)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dicionario.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        let palavra = self.dicionario[indexPath.row]
        let palavraRecuperada = palavra.value(forKey: "palavra")
        
        cell.textLabel?.text = palavraRecuperada as! String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let dicionario = self.dicionario[indexPath.row]
        self.performSegue(withIdentifier: "verSignificado", sender: dicionario)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verSignificado" {
            let viewDestino = segue.destination as! ViewController
            viewDestino.dicionario = sender as? NSManagedObject
            
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let dicionario = self.dicionario[indexPath.row]
            self.context.delete(dicionario)
            self.dicionario.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try self.context.save()
            } catch let erro {
                print("Erro ao excluir: \(erro.localizedDescription)")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            var predicate: NSPredicate = NSPredicate()
            
            if !searchText.isEmpty {
                predicate = NSPredicate(format: "palavra contains[c] '\(searchText)'")
            }else{
                predicate = NSPredicate(value: true)
            }
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName:"Dicionario")
            let ordenacao = NSSortDescriptor(key: "palavra", ascending: true)
            fetchRequest.sortDescriptors = [ordenacao]
            fetchRequest.predicate = predicate
            
            do {
                dicionario = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error.localizedDescription)")
            }
            
            tableView.reloadData()
        }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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

}
