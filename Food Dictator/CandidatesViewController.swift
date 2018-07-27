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
    fileprivate var didPromptForMore:Bool = false;
    
    weak var candidateManager: CandidateManager?
    
    required init?(coder aDecoder: NSCoder) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        candidateManager = appDelegate.candidateManager
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // table setup
        tableView.register(UINib.init(nibName: "CandidateTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: Constants.fdCellIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = false
        
        actionButton.backgroundColor = Constants.fdRedColor
        actionButton.layer.borderColor = Constants.fdLightRedColor
        actionButton.layer.borderWidth = 2.0
        actionButton.layer.cornerRadius = 6.0
        actionButton.clipsToBounds = true
        actionButton.setTitleColor(UIColor.gray, for: .disabled);
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(CandidatesViewController.handleAddNewCandidate))
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        refreshActionButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        if (candidateManager!.candidates().count == 0) {
            
            let alertController = UIAlertController(title: "Choose Candidates",
                                                    message: "Comrade! Choose candidates for the Food Dictator \"Election\"!",
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertAction.Style.default,
                handler: {(alert: UIAlertAction!) in self.handleAddNewCandidate()}))

            self.present(alertController, animated: true, completion: nil)
        }
        else if (candidateManager!.candidates().count == 1 && didPromptForMore == false) {
            
            didPromptForMore = true
            
            let alertController = UIAlertController(title: "Choose Another?",
                                                    message: "Comrade! More candidates will make for better \"Election\", no?",
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Da!",
                style: UIAlertAction.Style.default,
                handler: {(alert: UIAlertAction!) in self.handleAddNewCandidate()}))

            alertController.addAction(UIAlertAction(title: "Nyet",
                style: UIAlertAction.Style.cancel,
                handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: -
    
    fileprivate func refreshActionButton() {
        actionButton.isEnabled = candidateManager!.hasAvailableCandidates()
    }
    
    @objc fileprivate func handleAddNewCandidate() {
        let chooser = self.storyboard?.instantiateViewController(withIdentifier: "CandidateChooserViewController") as! CandidateChooserViewController

        self.navigationController?.pushViewController(chooser, animated: true)
    }
}


extension CandidatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Data
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.fdCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return candidateManager!.candidates().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.fdCellIdentifier) as! CandidateTableViewCell
        let c = candidateManager!.candidates()[(indexPath as NSIndexPath).row]
        cell.nameLabel.text = c.name
        cell.subtitleLabel.text = c.isElectable ? c.title : "Maybe next time..."
        cell.isElectable = c.isElectable
        cell.profileImageView.image = c.profileImage != nil ? c.profileImage : Constants.fdDefaultProfileImage
        
        return cell
    }
    
    
    // MARK: - Selection
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let c = candidateManager!.candidates()[(indexPath as NSIndexPath).row]
        
        candidateManager!.toggleCandidateActivation(c);
        
        refreshActionButton()

        tableView.reloadRows(at: [indexPath], with: .fade)
    }

    
    // MARK: - Editing
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // update the model
            candidateManager!.removeCandidateAtIndex((indexPath as NSIndexPath).row)
            // update the table
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}




