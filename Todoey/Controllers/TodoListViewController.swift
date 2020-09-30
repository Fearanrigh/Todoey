//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)

//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
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
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // Toggle the done property
        // TODO: The deselection is no longer animated with the reloadData below.
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData() // Reload the table to see the checkmarks
    }
    
    //MARK - Add New Items
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        // Adds the desired action to the alert window
        alert.addAction(action)
        
        // Shows the alert window
        present(alert, animated: true, completion: nil )
    }
}
