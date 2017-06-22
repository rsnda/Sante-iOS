//
//  SettingsViewController.swift
//  ApplicationSante
//
//  Created by Admin on 21/06/2017.
//  Copyright © 2017 DTA. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var nameConvention: UISegmentedControl!
    @IBOutlet weak var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let preferenceValue = UserDefaults.standard.value(forKey: "namingConvention") as? Bool ?? false
        
        var indexValue = Int(0)
        
        if preferenceValue{
            indexValue = 1
        }
        
        nameConvention.selectedSegmentIndex = indexValue
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func applyChanges(_ sender: Any) {
        let preferenceKey: String = "namingConvention"
        
        let preference = (nameConvention.selectedSegmentIndex == 1)
        
        UserDefaults.standard.set(preference, forKey: preferenceKey)
        
        self.dismiss(animated: true)
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
