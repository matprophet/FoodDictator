//
//  CandidatesViewController.swift
//  Food Dictator
//
//  Created by Mat Davidson on 5/9/16.
//  Copyright © 2016 Mat Davidson. All rights reserved.
//

import UIKit

class CandidatesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var addUserButton: UIButton!
    private var didPromptForMore:Bool = false;
    
    weak var candidateManager: CandidateManager?
    
    required init?(coder aDecoder: NSCoder) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        candidateManager = appDelegate.candidateManager
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // table setup
        tableView.registerNib(UINib.init(nibName: "CandidateTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Constants.fdCellIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = false
        
        actionButton.backgroundColor = Constants.fdRedColor
        actionButton.layer.borderColor = Constants.fdLightRedColor
        actionButton.layer.borderWidth = 2.0
        actionButton.layer.cornerRadius = 6.0
        actionButton.clipsToBounds = true
        actionButton.setTitleColor(UIColor.grayColor(), forState: .Disabled);
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(CandidatesViewController.handleAddNewCandidate))
    }

    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        refreshActionButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)

        if (candidateManager!.candidates().count == 0) {
            
            let alertController = UIAlertController(title: "Choose Candidates",
                                                    message: "Comrade! Choose candidates for the Food Dictator \"Election\"!",
                                                    preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: {(alert: UIAlertAction!) in self.handleAddNewCandidate()}))

            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if (candidateManager!.candidates().count == 1 && didPromptForMore == false) {
            
            didPromptForMore = true
            
            let alertController = UIAlertController(title: "Choose Another?",
                                                    message: "Comrade! More candidates will make for better \"Election\", no?",
                                                    preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Da!",
                style: UIAlertActionStyle.Default,
                handler: {(alert: UIAlertAction!) in self.handleAddNewCandidate()}))

            alertController.addAction(UIAlertAction(title: "Nyet",
                style: UIAlertActionStyle.Cancel,
                handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: -
    
    private func refreshActionButton() {
        actionButton.enabled = candidateManager!.hasAvailableCandidates()
    }
    
    @objc private func handleAddNewCandidate() {
        let chooser = self.storyboard?.instantiateViewControllerWithIdentifier("CandidateChooserViewController") as! CandidateChooserViewController

        self.navigationController?.pushViewController(chooser, animated: true)
    }
}


extension CandidatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Data
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.fdCellHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return candidateManager!.candidates().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.fdCellIdentifier) as! CandidateTableViewCell
        let c = candidateManager!.candidates()[indexPath.row]
        cell.nameLabel.text = c.name
        cell.subtitleLabel.text = c.isElectable ? c.title : "Maybe next time..."
        cell.isElectable = c.isElectable
        cell.profileImageView.image = c.profileImage != nil ? c.profileImage : Constants.fdDefaultProfileImage
        
        return cell
    }
    
    
    // MARK: - Selection
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let c = candidateManager!.candidates()[indexPath.row]
        
        candidateManager!.toggleCandidateActivation(c);
        
        refreshActionButton()

        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }

    
    // MARK: - Editing
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            // update the model
            candidateManager!.removeCandidateAtIndex(indexPath.row)
            // update the table
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}




