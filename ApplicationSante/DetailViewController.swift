//
//  DetailViewController.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 DTA. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var patient: PersonData!
    var onDeleteUser: (() -> ())?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var informationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add trash button :
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteUser))
        self.navigationItem.rightBarButtonItem = button
        
        self.title = patient.getFullName()
        avatarImageView.image = #imageLiteral(resourceName: "NeutralAvatar")
        
        informationTextView.text = patient.presentation
        
        let retrieveImage = URLSession.shared.dataTask(with: URL(string: patient.pictureUrl!)!) { (data, response, error) in
            
            DispatchQueue.main.async {
                print("Is main Thread : " , Thread.isMainThread)
                if let data = data, let image = UIImage(data: data) {
                    self.avatarImageView.image = image
                }
            }
   
        }
        
        retrieveImage.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteUser() {
        
        let alertController = UIAlertController(title: "Delete User", message: "Are you sure ?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive ){ action in
            self.onDeleteUser?()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true)
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
