//
//  DetailViewController.swift
//  SaveContacts
//
//  Created by Active Mac05 on 25/11/16.
//  Copyright © 2016 techactive. All rights reserved.
//
    
    
import UIKit
import CoreData
class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet var personImageView: UIImageView!
    @IBOutlet var fNameTextField: UITextField!
    @IBOutlet var lNameTextField: UITextField!
    @IBOutlet var mobileNumberTextFiled: UITextField!
    @IBOutlet var emailAddressTextField: UITextField!
    @IBOutlet var birthDateTextField: UITextField!
    @IBOutlet var addressTextFiled: UITextField!
    
    @IBOutlet var tpScrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var editBitton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    
    let imagePicker = UIImagePickerController()
    var alert = UIAlertController()
    var selectedImagedata = UIImagePNGRepresentation(UIImage(named: "ProfileImage")!)
    weak var editingPerson: Person?
    var showEditButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fNameTextField.delegate=self
        lNameTextField.delegate=self
        mobileNumberTextFiled.delegate=self
        emailAddressTextField.delegate=self
        birthDateTextField.delegate=self
        addressTextFiled.delegate=self
        
        imagePicker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped))
        personImageView.userInteractionEnabled = true
        personImageView.addGestureRecognizer(tapGestureRecognizer)
        
        if (editingPerson != nil) {
            fNameTextField.text = "" + (editingPerson?.firstName)!
            lNameTextField.text = "" + (editingPerson?.lastName)!
            emailAddressTextField.text = "" + (editingPerson?.emailAddress)!
            birthDateTextField.text = "" + (editingPerson?.birthDate)!
            addressTextFiled.text = "" + (editingPerson?.address)!
            mobileNumberTextFiled.text = "" + (editingPerson?.phoneNumber)!
            personImageView.image = UIImage(data: (editingPerson?.image)!)
            selectedImagedata = editingPerson?.image
            self.hideBarButtonItems()
            editBitton.enabled = true
            editBitton.tintColor = nil
        }else{
            editBitton.enabled = false
            editBitton.tintColor = UIColor.clearColor()
        }
        
        // Do any additional setup after loading the view.
    }

    func hideBarButtonItems(){
        cancelButton.enabled = false
        cancelButton.tintColor = UIColor.clearColor()
        saveButton.enabled = false
        saveButton.tintColor = UIColor.clearColor()
    }
    
    func unHideBarButtonItems(){
        cancelButton.enabled = true
        cancelButton.tintColor = nil
        saveButton.enabled = true
        saveButton.tintColor = nil
    }
    func imageTapped(img: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
//        UIImagePickerControllerSourceType.PhotoLibrary
//        UIImagePickerControllerSourceType.Camera
//        UIImagePickerControllerSourceType.SavedPhotosAlbum
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            personImageView.contentMode = .ScaleAspectFit
            personImageView.image = pickedImage
            selectedImagedata = UIImagePNGRepresentation(pickedImage)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
        editBitton.enabled = false
        editBitton.tintColor = UIColor.clearColor()
        self.unHideBarButtonItems()
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        self.savepersonDetails()
    }

    @IBAction func cancelButtonAction(sender: AnyObject) {
            self.navigationController?.popViewControllerAnimated(true)
    }
    
@objc func datePickerValueChanged(sender:UIDatePicker) {
    
    let dateFormatter = NSDateFormatter()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    
    dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    
    birthDateTextField.text = dateFormatter.stringFromDate(sender.date)
    
}

    func savepersonDetails()
    {
        var message = "saved"
        if fNameTextField.text?.characters.count < 1  {
            self.displayAlertWithTitleAndMessage("Please enter first name", message: "", tag: 0)
            return
        }
        if lNameTextField.text?.characters.count < 1  {
            self.displayAlertWithTitleAndMessage("Please enter last name", message: "", tag: 0)
            return
        }
        if mobileNumberTextFiled.text?.characters.count < 1  {
            self.displayAlertWithTitleAndMessage("Please enter mobile number", message: "", tag: 0)
            return
        }
        if emailAddressTextField.text?.characters.count < 1  {
            self.displayAlertWithTitleAndMessage("Please enter email address", message: "", tag: 0)
            return
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //Data is in this case the name of the entity
        if (editingPerson == nil) {
            let entity = NSEntityDescription.entityForName("Person",
                                                           inManagedObjectContext: managedContext)
            let newPerson = Person(entity: entity!, insertIntoManagedObjectContext: managedContext) as Person
            newPerson.firstName = "" + fNameTextField.text!
            newPerson.lastName = "" + lNameTextField.text!
            newPerson.phoneNumber = "" + mobileNumberTextFiled.text!
            newPerson.emailAddress = "" + emailAddressTextField.text!
            newPerson.birthDate = "" + birthDateTextField.text!
            newPerson.address = "" + addressTextFiled.text!
            newPerson.image = selectedImagedata
            message = "saved"
        }else{
            editingPerson!.firstName = "" + fNameTextField.text!
            editingPerson!.lastName = "" + lNameTextField.text!
            editingPerson!.phoneNumber = "" + mobileNumberTextFiled.text!
            editingPerson!.emailAddress = "" + emailAddressTextField.text!
            editingPerson!.birthDate = "" + birthDateTextField.text!
            editingPerson!.address = "" + addressTextFiled.text!
            editingPerson!.image = selectedImagedata
            message = "updated"
        }

        
        do
        {
             try managedContext.save()
            self.displayAlertWithTitleAndMessage("\(fNameTextField.text!) details \(message) successfully", message: "", tag: 1)
        }catch let error as NSError {
            print("Could not save error = \(error))")
        }
        
        //uncomment this line for adding the stored object to the core data array
        //name_list.append(options) 
    }
    
    
    func clear_data()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Data")
        do
        {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [Person]
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
    

    func displayAlertWithTitleAndMessage(title : String, message : String ,tag : Int) {
        let alertController = UIAlertController(title:title, message: message, preferredStyle: .Alert)
        if tag == 1 {
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.navigationController?.popViewControllerAnimated(true)
            }
            alertController.addAction(OKAction)
        }else{
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
        }
        
        
        
        presentViewController(alertController, animated: true, completion: nil)
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
