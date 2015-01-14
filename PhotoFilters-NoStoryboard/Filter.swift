//
//  Filter.swift
//  PhotoFilters-NoStoryboard
//
//  Created by Kevin Pham on 1/13/15.
//  Copyright (c) 2015 Nimble & Swift. All rights reserved.
//

import Foundation
import CoreData

class Filter: NSManagedObject {
  
  @NSManaged var name: String
  @NSManaged var favorite: NSNumber

}