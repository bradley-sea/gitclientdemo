//
//  User.swift
//  GithubClient
//
//  Created by Bradley Johnson on 1/20/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import Foundation
import UIKit


class User {
  let name : String
  var avatarImage : UIImage?
  let avatarURL : String
  let id : String
  let url : String
  
  init (jsonDict : NSDictionary) {
    self.name = jsonDict.objectForKey("login") as String
    self.avatarURL = jsonDict.objectForKey("avatar_url") as String
    self.url = jsonDict.objectForKey("url") as String
    let intID = jsonDict.objectForKey("id") as Int
    self.id = "\(intID)"
  }
  
  class func parseJSONIntoUsers(json : NSDictionary) -> [User] {
    
    var users = [User]()
    
    let items = json["items"] as NSArray
    
    for jsonUser in items {
      var jsonDict = jsonUser as NSDictionary
      var user = User(jsonDict: jsonDict)
      users.append(user)
    }
    return users
  }
  
}