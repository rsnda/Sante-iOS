//
//  CreatePatientViewController.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 DTA. All rights reserved.
//

import UIKit
import CoreData

// This protocol must be implemented in PatientTableViewController
protocol CreatePatientViewControllerDelegate: AnyObject {
    
    func createPerson()
    
}

class CreatePatientViewController: UIViewController {
    // Creation of the delegate :
    weak var delegate: CreatePatientViewControllerDelegate?


    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.setProgress(0, animated: true)

        // Do any additional setup after loading the view.
        
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backButton))
        
        self.navigationItem.leftBarButtonItem = button
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButton() {
        self.dismiss(animated: true)
    }
    

    @IBAction func addPatient(_ sender: UIButton) {
        /* Create a dict like :
         {
            "surname": "Vincent",
            "lastname": "Leroux",
            "pictureUrl": "https://www.exemple.com/picture.jpg"
         }
         */
        var json = [String:String]()
        json["surname"] = self.surnameTextField.text ?? "Unknown"
        json["lastname"] = self.lastnameTextField.text ?? "Unknown"
        json["pictureUrl"] = "http://nationalreport.net/wp-content/uploads/2016/09/KimJongUn.jpg"
        
        // Create a json POST http request containing the json dict :
        var request = URLRequest(url: URL(string:self.API_URL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        // Create a task that will send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                // Update of the local base
                let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                guard let dict = jsonDict as? [String : Any] else {
                    return
                }
                
                // Creation of local person
                let person = PersonData(entity: PersonData.entity(), insertInto: self.persistentContainer.viewContext)
                person.lastName = dict["lastname"] as? String
                person.firstName = dict["surname"] as? String
                person.pictureUrl = dict["pictureUrl"] as? String
                person.serverId = Int64(dict["id"] as? Int ?? 0)
 
                DispatchQueue.main.async{
                    do {
                        try self.persistentContainer.viewContext.save() // Saving to local base
                    } catch {
                        print(error)
                    }
                    
                    self.delegate?.createPerson()
                }
                
            }
            
        }
        
        task.resume()
        
        // Update of the progress bar :
        /*
        DispatchQueue.global(qos: .userInitiated).async {
            var i = Float(0)
            while i < 1 {
                DispatchQueue.main.async {
                    self.progress.setProgress(i, animated: true)
                }
                i += 0.01
                Thread.sleep(forTimeInterval: 0.01)
            }
            
        }
        */
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
