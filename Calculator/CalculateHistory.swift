//
//  CalculateHistory.swift
//  
//
//  Created by Huiyuan Ren on 16/8/23.
//
//

import Foundation
import CoreData


class CalculateHistory: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CalculateHistory> {
        return NSFetchRequest<CalculateHistory>(entityName: "CalculateHistory");
    }
}
