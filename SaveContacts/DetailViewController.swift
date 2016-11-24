//
//  DetailViewController.swift
//  SaveContacts
//
//  Created by Active Mac05 on 24/11/16.
//  Copyright © 2016 techactive. All rights reserved.
//

import UIKit
import CoreData
class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var personImageView: UIImageView!
    @IBOutlet var fNameTextField: UITextField!
    @IBOutlet var lNameTextField: UITextField!
    @IBOutlet var mobileNumberTextFiled: UITextField!
    @IBOutlet var emailAddressTextField: UITextField!
    @IBOutlet var birthDateTextField: UITextField!
    @IBOutlet var addressTextFiled: UITextField!
    
    @IBOutlet var tpScrollView: TPKeyboardAvoidingScrollView!
    
    
    
    
    weak var editingPerson: PersonDataMO?
    override func viewDidLoad() {
        super.viewDidLoad()
        fNameTextField.delegate=self
        lNameTextField.delegate=self
        mobileNumberTextFiled.delegate=self
        emailAddressTextField.delegate=self
        birthDateTextField.delegate=self
        addressTextFiled.delegate=self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField == birthDateTextField {
            let datePickerView:UIDatePicker = UIDatePicker()
            
            datePickerView.datePickerMode = UIDatePickerMode.Date
            
            textField.inputView = datePickerView
            
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    
    @IBAction func EditDetailsbuttonAction(sender: AnyObject) {
        
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        
        
    }

@objc func datePickerValueChanged(sender:UIDatePicker) {
    
    let dateFormatter = NSDateFormatter()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    
    dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    
    birthDateTextField.text = dateFormatter.stringFromDate(sender.date)
    
}

    func save(name:String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //Data is in this case the name of the entity
        let entity = NSEntityDescription.entityForName("Person",
                                                       inManagedObjectContext: managedContext)
        let newPerson = NSManagedObject(entity: entity!,
                                      insertIntoManagedObjectContext:managedContext)
        
        newPerson.setValue(name, forKey: "name")
        
        
        do
        {
             try managedContext.save()
        }catch let error as NSError {
            print("Could not save error = \(error))")
        }
        
        //uncomment this line for adding the stored object to the core data array
        //name_list.append(options) 
    }
    
    
    func read()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Person")
        do
        {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [PersonDataMO]
            
            if let results = fetchedResults
            {
                for (var i=0; i < results.count; i = i+1)
                {
                    let single_result = results[i]
                    let out = single_result.valueForKey("name") as! String
                    print(out)
                    //uncomment this line for adding the stored object to the core data array
                    //name_list.append(single_result)
                }
            }
            
            
        }catch let error as NSError{
            print("Could not read error = \(error))")
        }
    }
    
    
    func clear_data()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Data")
        do
        {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [PersonDataMO]
            if let results = fetchedResults
            {
                for (var i=0; i < results.count; i = i+1)
                {
                    let value = results[i]
                    managedContext.deleteObject(value)
                    do
                    {
                        try managedContext.save()
                    }catch let error as NSError {
                        print("Could not save error = \(error))")
                    }
                    
                }
            }
        }catch let error as NSError{
             print("Could not delete error = \(error))")
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
