//
//  ViewController.swift
//  SaveContacts
//
//  Created by Active Mac05 on 24/11/16.
//  Copyright © 2016 techactive. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contactListTableView: UITableView!
    var people = [PersonDataMO]()
    override func viewDidLoad() {
        super.viewDidLoad()
        contactListTableView.dataSource = self
        contactListTableView.delegate = self
        contactListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let person = people[indexPath.row]
        
        cell!.textLabel!.text =
            person.valueForKey("name") as? String
        
        return cell!
    }
    
    @IBAction func addContactButtonAction(sender: AnyObject) {
        
    }

    let CellDetailIdentifier = "CellDetailIdentifier"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case CellDetailIdentifier:
            let destination = segue.destinationViewController as! DetailViewController
            let indexPath = contactListTableView.indexPathForSelectedRow!
            let selectedObject = people[indexPath.row] 
            destination.editingPerson = selectedObject
        default:
            print("Unknown segue: \(segue.identifier)")
        }
    }
    
    
    private func _initializeDB() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest();
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        fetchRequest.entity = entity;
        var fetchedObjects: [PersonDataMO]!
        do {
            fetchedObjects = try managedContext.executeFetchRequest(fetchRequest) as! [PersonDataMO]
        } catch {
        }
        
        if (fetchedObjects.count == 0) {        //No DB
            self.people = [PersonDataMO]()
        }
        else{
            self.people = fetchedObjects
        }
    }
    
}

