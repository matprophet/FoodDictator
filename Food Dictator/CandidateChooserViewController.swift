//
//  CandidateChooserViewController.swift
//  Food Dictator
//
//  Created by Mat Davidson on 5/9/16.
//  Copyright © 2016 Mat Davidson. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class CandidateChooserViewController: UIViewController {

    @IBOutlet var tableView:UITableView!

    private var hasAddressBookPermissions: Bool = true
    private weak var candidateManager: CandidateManager?
    private var allContacts:[Candidate] = []
    private var filteredContacts:[Candidate] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        candidateManager = appDelegate.candidateManager
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        candidateManager = appDelegate.candidateManager
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Comrades"
        
        tableView.registerNib(UINib.init(nibName: "CandidateTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Constants.fdCellIdentifier)
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshContacts()
    }
    
    
    // MARK: -
    
    func refreshContacts() {
        
        func displayNoAccessAlert() {
            let alertController = UIAlertController(title: "Nyet! Access Denied!",
                                                    message: "Please, comrade, enable AddressBook access in the Settings.",
                                                    preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        func loadUsers() {
            
            let contactStore = CNContactStore()

            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containersMatchingPredicate(nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
                do {
                    let containerResults = try contactStore.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch: keysToFetch)
                    results.appendContentsOf(containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            let knownCandidates = candidateManager!.candidates()
            
            allContacts = results.map { (cn) -> Candidate in
                
                var name = ""
                if let fullname = CNContactFormatter.stringFromContact(cn, style: .FullName) {
                    name = fullname
                }
                
                let title = candidateManager!.randomCandidateTitle()
                let img = (cn.imageDataAvailable) ? UIImage.init(data: cn.thumbnailImageData!, scale: 1.0) : nil
                return Candidate(name: name, title: title, profileImage: img, contactsIdentifier: cn.identifier, isElectable: true)
                
            }.filter { (c) -> Bool in
                
                return knownCandidates.contains(c) == false && c.name.isEmpty == false
            }
            
            filteredContacts = allContacts

            tableView.reloadData()
        }
        
        
        let access = CNContactStore.authorizationStatusForEntityType(.Contacts)
        
        if (access == .NotDetermined) {
            CNContactStore().requestAccessForEntityType(.Contacts, completionHandler: { (didSucceed: Bool, error: NSError?) in
                dispatch_async(dispatch_get_main_queue(), {
                    if (didSucceed == false) {
                        displayNoAccessAlert()
                    }
                    else {
                        loadUsers()
                    }
                })
            })
        }
        else if( access == .Denied) {
            // put up a dialog?
            displayNoAccessAlert()
        }
        else {
            loadUsers()
        }
    }
}


// MARK: - Searchbar support

extension CandidateChooserViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText.isEmpty) {
            filteredContacts = allContacts
        }
        else
        {
            filteredContacts = allContacts.filter({ (c) -> Bool in
                if c.name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                }
                else {
                    return false
                }
            })
        }
        
        tableView.reloadData()
    }
}


// MARK: - Tableview support

extension CandidateChooserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.fdCellHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredContacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.fdCellIdentifier) as! CandidateTableViewCell
        let c = filteredContacts[indexPath.row]
        
        cell.nameLabel.text = c.name
        cell.subtitleLabel.text = c.title
        cell.isElectable = true
        cell.profileImageView.image = c.profileImage != nil ? c.profileImage : Constants.fdDefaultProfileImage

        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        candidateManager!.addUser(filteredContacts[indexPath.row]);
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

