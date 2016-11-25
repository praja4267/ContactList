//
//  ViewController.swift
//  SaveContacts
//
//  Created by Active Mac05 on 25/11/16.
//  Copyright © 2016 techactive. All rights reserved.
//
import UIKit
import CoreData
import MessageUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    @IBOutlet var contactListTableView: UITableView!
    @IBOutlet var noContactsLabel: UILabel!
    
    var people = [Person]()
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactListTableView.dataSource = self
        contactListTableView.delegate = self
        contactListTableView.tableFooterView = UIView()
        contactListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let newNib = UINib(nibName: "PersonListTVCellTableViewCell", bundle: nil)
        contactListTableView.registerNib(newNib, forCellReuseIdentifier: "PersonListTVCellTableViewCell")
        noContactsLabel.hidden = true
        self._initializeDB()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadPersonDataFromDB()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonListTVCellTableViewCell", forIndexPath: indexPath) as! PersonListTVCellTableViewCell
        
        let person = people[indexPath.row]
        cell.personImage.image = UIImage(data: person.image!)
        cell.personName.text = person.firstName! + " " + person.lastName!
        cell.personMobileNumber.text = person.phoneNumber
        cell.personEmailAddress.text = person.emailAddress
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 151.0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.displayActionSheet(indexPath)
         tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let moc = appDelegate.managedObjectContext
            moc.deleteObject(people[indexPath.row])
            appDelegate.saveContext()
            people.removeAtIndex(indexPath.row)
            tableView.reloadData()
            if people.count == 0 {
                noContactsLabel.hidden = false
            } else {
                noContactsLabel.hidden = false
            }
           
        }
    }
    
    
    
    @IBAction func addContactButtonAction(sender: AnyObject) {
        
        let cntl = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        cntl.editingPerson = nil
        cntl.showEditButton = false
        self.navigationController?.pushViewController(cntl, animated: true)

    }
    
    
    func displayActionSheet(indexPath : NSIndexPath) {
        let person = self.people[indexPath.row]
        
        let emailAddress = person.emailAddress
        let phoneNumber = person.phoneNumber
        
        
        let alertController = UIAlertController(title: "Please select an action", message: "", preferredStyle: .ActionSheet)
        
        let showDetailsAction = UIAlertAction(title: "Show Details", style: .Default) { (action) in
            
            print("show details clicked")
            
            let cntl = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
            cntl.editingPerson = person
            cntl.showEditButton = true
            self.navigationController?.pushViewController(cntl, animated: true)
            
            // ...
        }
        alertController.addAction(showDetailsAction)
        
        let callAction = UIAlertAction(title: "Call", style: .Default) { (action) in
            // ...
            print("call button clicked")
            
            self.dial(phoneNumber!)
        }
        alertController.addAction(callAction)
        
        let sendEmailAction = UIAlertAction(title: "Send an Email", style: .Default) { (action) in
            print("send email  clicked")
            self.sendMail(emailAddress!)
        }
        alertController.addAction(sendEmailAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
        
        
    }
    
    
    func dial(phoneNumber : String) {
        
        dispatch_async(dispatch_get_main_queue()) {
            // after call ended come back to this app
            let phoneNumber: String = "telprompt://".stringByAppendingString(phoneNumber)
            //after call ended dont come back to this app
            //        var phnumber : String = "tel://".stringByAppendingString(_phoneNumberLabel.text!)
            
            UIApplication.sharedApplication().openURL(NSURL(string:phoneNumber)!)
            
        }
    }
    
    func sendMail(email : String){
        let mailComposeViewController = configuredMailComposeViewController(email)
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    func configuredMailComposeViewController(email : String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    private func _initializeDB() {
        progressBarDisplayer("Loading data", true)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest();
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        fetchRequest.entity = entity;
        var fetchedObjects: [Person]!
        do {
            fetchedObjects = try managedContext.executeFetchRequest(fetchRequest) as! [Person]
        } catch {
        }
        
        if (fetchedObjects.count == 0) {        //No DB
            self.people = [Person]()
            noContactsLabel.hidden = false
                self.contactListTableView.reloadData()
                self.messageFrame.removeFromSuperview()
        }
        else{
            self.people = fetchedObjects
            noContactsLabel.hidden = true
                self.contactListTableView.reloadData()
                self.messageFrame.removeFromSuperview()
        }
    }
    
    
    func loadPersonDataFromDB()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Person")
        do
        {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [Person]
            
            if let results = fetchedResults
            {
                self.people = results
                if results.count == 0 {
                    self.noContactsLabel.hidden = false
                } else {
                    self.noContactsLabel.hidden = true
                }
            }
                self.contactListTableView.reloadData()
        }catch let error as NSError{
            print("Could not read error = \(error))")

        }
    }

    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    
}

