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
    let password:String
    let role:String
    let username:String
    
    init(name:String,email:String,password:String,role:String,username:String){
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.username = username
    }
    
    func getDictionary()->Dictionary<String,String>{
        let userDictionary = [
            "email" : email,
            "name" : name,
            "password" : password,
            "role" : role,
            "username":username
        ]
        return userDictionary
    }
}
