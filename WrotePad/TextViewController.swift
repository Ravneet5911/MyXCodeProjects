//
//  TextViewController.swift
//  WrotePad
//
//  Created by Ravneet Singh on 23/05/22.
//

import Foundation
import UIKit
import CoreData
class TextViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textLabel: UITextView!
    var writingPad = [WritingPad]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Categories? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.delegate = self
        
        textLabel.text = writingPad.last?.text
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Do You want to save the changes", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save Changed", style: .default) { action in
            let newItem = WritingPad(context: self.context)
            newItem.text = self.textLabel.text
            newItem.newRelationship = self.selectedCategory
            self.saveItems()
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    func saveItems() {
        do {
            try context.save()
        }
        catch {
            print("Error while saving the data \(error)")
        }
    }
    
    func loadItems() {
        let request: NSFetchRequest<WritingPad> = WritingPad.fetchRequest()
        
        request.predicate = NSPredicate(format: "newRelationship.itemName MATCHES %@", selectedCategory!.itemName!)
        
        do {
            writingPad = try context.fetch(request)
        }
        catch {
            print("Error while fetching data from database \(error)")
        }
    }
}
