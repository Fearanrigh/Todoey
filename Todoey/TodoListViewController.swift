//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items 
        }
    }
    
    // Sets the number of rows in the tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Sets the cell properties for the cell at row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Reuse an already made UITableViewCell at the indexPath (indexPath == current row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Set the cell text to the item text at the current row.
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        // Adds the desired action to the alert window
        alert.addAction(action)
        
        // Shows the alert window
        present(alert, animated: true, completion: nil )
    }
}
