//
//  ViewController.swift
//  MyBucketList
//
//  Created by Barbara Siczek on 13.01.2018.
//  Copyright © 2018 Barbara Siczek. All rights reserved.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController {

    var placesArray = [Place]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(dataFilePath)
        
        loadPlaces()
        
        
    }

    // MARK:  Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritePlacesCell", for: indexPath)
        let place = placesArray[indexPath.row]
        
        cell.textLabel?.text = place.title
        
        cell.accessoryType =  place.visited ? .checkmark : .none
        
        return cell
    }

    // MARK: Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        placesArray[indexPath.row].visited = !placesArray[indexPath.row].visited
        tableView.reloadData()
        
        savePlaces()
                   
        tableView.deselectRow(at: indexPath, animated: true)

    }
    //MARK: - Add new Favourite Place
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Place to Bucket List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Place", style: .default) {(action) in
            
            let newPlace = Place(context: self.context)
            newPlace.title = textField.text!
            newPlace.visited = false
            self.placesArray.append(newPlace)
            
            self.savePlaces()
            


        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Favourite Place"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    // MARK: Model manipulation methods
    
    func savePlaces(){

        do{
            try context.save()
        } catch {
            print("Error saving context, \(error)")
            
        }
        
        self.tableView.reloadData()
    }
    
    func loadPlaces(){
        let request : NSFetchRequest<Place> = Place.fetchRequest()
        do {
            placesArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context, \(error)")
        }
        
        
    }
    

}

