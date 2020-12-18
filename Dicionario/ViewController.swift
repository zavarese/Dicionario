//
//  ViewController.swift
//  Dicionario
//
//  Created by zavarese on 15/12/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var significado: UITextView!
    @IBOutlet weak var palavra: UITextField!
    
    var context : NSManagedObjectContext!
    var dicionario : NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.palavra.becomeFirstResponder()
        self.significado.becomeFirstResponder()
        
        if dicionario != nil {
            if let palavraRecuperada = dicionario.value(forKey: "palavra"){
                self.palavra.text = palavraRecuperada as! String
            }
            
            if let significadoRecuperado = dicionario.value(forKey: "significado"){
                self.significado.text = significadoRecuperado as! String
            }
        }else{
            self.palavra.text = ""
            self.significado.text = ""
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }

    @IBAction func salvar(_ sender: Any) {
        if dicionario == nil{
            self.salvarItemDicionario()
        }else{
            self.atualizarItemDicionario()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func salvarItemDicionario(){
        let novoItemDicionario = NSEntityDescription.insertNewObject(forEntityName: "Dicionario", into: context)
        
        novoItemDicionario.setValue(self.palavra.text, forKey: "palavra")
        novoItemDicionario.setValue(self.significado.text, forKey: "significado")
        
        do {
            try context.save()
            print("Item do dicionario salvo")
        } catch let erro {
            print("Erro ao salvar: \(erro.localizedDescription)")
        }
    }
    
    func atualizarItemDicionario(){
        dicionario.setValue(self.palavra.text, forKey: "palavra")
        dicionario.setValue(self.significado.text, forKey: "significado")
        
        do {
            try context.save()
            print("Item do dicionario atualizado")
        } catch let erro {
            print("Erro ao atualizar: \(erro.localizedDescription)")
        }
    }
}

