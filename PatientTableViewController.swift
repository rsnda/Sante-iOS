//
//  PatientTableViewController.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 DTA. All rights reserved.
//

import UIKit
import CoreData

class PatientTableViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController<PersonData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<PersonData>(entityName: "PersonData")
        let sort = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "PersonData")
        
        fetchedResultController.delegate = self
        try! fetchedResultController.performFetch()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.reloadData()
        
        // Add user button creation :
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateViewController))
        self.navigationItem.rightBarButtonItem = button
        
        // Settings button creation :
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showSettingsViewController))
        self.navigationItem.leftBarButtonItem = settingsButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showCreateViewController(){
        
        let controller = CreatePatientViewController(nibName: "CreatePatientViewController", bundle: nil)
        
        controller.delegate = self // The delegate of CreatePatientViewController is PatientTableViewController
        let navCont = UINavigationController(rootViewController: controller)
        
         
        self.present(navCont, animated: true, completion: nil)
    }
    
    func showSettingsViewController(){
        let controller = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        
        //controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath)

        let order = UserDefaults.standard.value(forKey: "namingConvention") as? Bool ?? false
        // Configure the cell...
        cell.textLabel?.text = fetchedResultController.object(at: indexPath).getFullName(reversedOrder: order)
        return cell
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let detailController = segue.destination as? DetailViewController {
            
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            detailController.onDeleteUser = {
                
                let patient = self.fetchedResultController.object(at: selectedIndexPath)
                self.persistentContainer.viewContext.delete(patient)
                try? self.persistentContainer.viewContext.save()
                
                self.tableView.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
            
            detailController.patient = fetchedResultController.object(at: selectedIndexPath)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /* 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PatientTableViewController: CreatePatientViewControllerDelegate{
    // Implementation of the function needed is CreatePatientViewController
    func createPerson() {
        // The person was created in CreatePatientViewController
        // Reload tableview and close CreatePatientViewController :
        self.tableView.reloadData()
        self.presentedViewController?.dismiss(animated: true, completion: nil) // Closing the controller
        
    }
    
}

extension PatientTableViewController: NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
    
}


