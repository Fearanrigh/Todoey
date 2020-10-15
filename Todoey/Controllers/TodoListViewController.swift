//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData 

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // The location of where to save the item list data.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = PersistenceController.shared.container.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }
    
    // Sets the number of rows in the tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Sets the cell properties for the cell at row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Reuse an already made UITableViewCell at the indexPath (indexPath == current row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row] // item at the specified row
        
        // Set the cell text to the item text at the current row.
        cell.textLabel?.text = item.title
        
        // Make the accessory type dependent on the done value of item using ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // The following code removes the item from the database and list when clicked.
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // Toggle the done property
        
        // Save items created to database
        saveItems()
        
        // TODO: The deselection is no longer animated with the reloadData below.
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    /**
     Adds a button to the main todo list title bar allowing the addition of another list item.
     */
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Block scope variable to transfer text from the alert UI to the action UI
        var textField = UITextField()
        
        // Creates the top-level window to add an item
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
             
        // Creates a UITextField within the alert window to enter the name of an item to add
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item here"
            textField = alertTextField
        }
        
        // The action to take within the alert window
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            // Save the items created to database
            self.saveItems()
        }
        
        // Adds the desired action to the alert window
        alert.addAction(action)
        
        // Shows the alert window
        present(alert, animated: true, completion: nil )
    }
    
    
    //MARK: - Model manipulation methods
    
    /**
     Encodes the itemArray with it's Item class objects and puts it in data,
     then writes this data to the location at dataFilePath
     */
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // The search is case and diacritic insensitive ([cd])
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    }
}
