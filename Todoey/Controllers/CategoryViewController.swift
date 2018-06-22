//
//  CategoryViewController.swift
//  Todoey
//
//  Created by ROB GILLEN on 6/22/18.
//  Copyright © 2018 Graphics Factory. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var itemArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "goToItems", sender: self)
  
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = itemArray[indexPath.row]
        }
    }
    

    func saveItems() {
        
        do {
            try context.save()
            
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error: \(error)")
        }
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once user clicks add button.
            
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add New Category"
            
           // print("now")
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    
}
