//
//  Person.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 DTA. All rights reserved.
//

import Foundation

extension PersonData{
    func getFullName(reversedOrder: Bool = false) -> String {
        if reversedOrder {
            return lastName! + " " + firstName!
        }
        return firstName! + " " + lastName!
        
    }
    
    var presentation: String{
        get {
            return "I am " + getFullName()
        }
    }
}

class Person {
    enum Gender {
        case Male, Female
    }
    
    var nom: String
    var prenom: String
    var gender: Gender
    var lib: String
    
    weak var pere: Person?
    weak var mere: Person?
    weak var enfant: Person?
    
    init(nom: String, prenom: String, gender: Gender) {
        self.nom = nom
        self.prenom = prenom
        self.gender = gender
        
        if self.gender == Gender.Male {
            self.lib = "M."
        }
        else {
            self.lib = "Mme."
        }
    }
    
    func printParent(){
        guard let pere = self.pere, let mere = mere else {
            print( "\(nom) doesn't have parents")
            return
        }
        
        print( "\(pere.prenom) and \(mere.prenom) are his parents")
    }
    
    func getFullName(reversedOrder: Bool = false) -> String {
        if reversedOrder {
            return nom + " " + prenom
        }
        return prenom + " " + nom
        
    }
    
    var presentation: String{
        get {
            return "I am " + lib + " " + getFullName()
        }
    }
    
}

