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

    fileprivate var hasAddressBookPermissions: Bool = true
    fileprivate weak var candidateManager: CandidateManager?
    fileprivate var allContacts:[Candidate] = []
    fileprivate var filteredContacts:[Candidate] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        candidateManager = appDelegate.candidateManager
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        candidateManager = appDelegate.candidateManager
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Comrades"
        
        tableView.register(UINib.init(nibName: "CandidateTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: Constants.fdCellIdentifier)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshContacts()
    }
    
    
    // MARK: -
    
    func refreshContacts() {
        
        func displayNoAccessAlert() {
            let alertController = UIAlertController(title: "Nyet! Access Denied!",
                                                    message: "Please, comrade, enable AddressBook access in the Settings.",
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        func loadUsers() {
            
            let contactStore = CNContactStore()

            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            let knownCandidates = candidateManager!.candidates()
            
            allContacts = results.map { (cn) -> Candidate in
                
                var name = ""
                if let fullname = CNContactFormatter.string(from: cn, style: .fullName) {
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
        
        
        let access = CNContactStore.authorizationStatus(for: .contacts)
        
        if (access == .notDetermined) {
            CNContactStore().requestAccess(for: .contacts, completionHandler: { (didSucceed, error) in
                DispatchQueue.main.async(execute: {
                    if (didSucceed == false) {
                        displayNoAccessAlert()
                    }
                    else {
                        loadUsers()
                    }
                })
            })
        }
        else if( access == .denied) {
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText.isEmpty) {
            filteredContacts = allContacts
        }
        else
        {
            filteredContacts = allContacts.filter({ (c) -> Bool in
                if c.name.range(of: searchText, options: .caseInsensitive) != nil {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.fdCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.fdCellIdentifier) as! CandidateTableViewCell
        let c = filteredContacts[(indexPath as NSIndexPath).row]
        
        cell.nameLabel.text = c.name
        cell.subtitleLabel.text = c.title
        cell.isElectable = true
        cell.profileImageView.image = c.profileImage != nil ? c.profileImage : Constants.fdDefaultProfileImage

        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        candidateManager!.addUser(filteredContacts[(indexPath as NSIndexPath).row]);
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

