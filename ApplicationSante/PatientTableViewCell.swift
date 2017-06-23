//
//  PatientTableViewCell.swift
//  ApplicationSante
//
//  Created by Admin on 23/06/2017.
//  Copyright © 2017 DTA. All rights reserved.
//

import UIKit

class PatientTableViewCell: UITableViewCell {

    var task = URLSessionTask()

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func setupCell(patient: PersonData) {
        
        task.cancel()
        
        task = URLSession.shared.dataTask(with: URL(string: patient.pictureUrl!)!) { (data, response, error) in
            
            DispatchQueue.main.async {
                print("Is main Thread : " , Thread.isMainThread)
                if let data = data, let image = UIImage(data: data) {
                    self.picture.image = image
                }
            }
            
        }
        
        task.resume()
        
        label.text = patient.getFullName()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
