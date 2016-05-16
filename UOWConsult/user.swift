//
//  user.swift
//  UOWConsult
//
//  Created by Victor Ang on 8/05/2016.
//  Copyright © 2016 CY Lim. All rights reserved.
//

import UIKit

class User{
    let name:String
    let email:String
    let role:String
    
    init(name:String,email:String,role:String){
        self.name = name
        self.email = email
        self.role = role
    }
    
    func getDictionary()->Dictionary<String,String>{
        let userDictionary = [
            "email" : email,
            "name" : name,
            "role" : role
        ]
        
        return userDictionary
    }
}
