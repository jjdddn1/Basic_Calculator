//
//  CalculateHistory+CoreDataProperties.swift
//  
//
//  Created by Huiyuan Ren on 16/8/23.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CalculateHistory {

    @NSManaged var displayText: String?
    @NSManaged var resultText: String?
    @NSManaged var date: Date?
    @NSManaged var resultNumber : Double
}
