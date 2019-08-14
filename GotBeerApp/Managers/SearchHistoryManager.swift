//
//  SearchHistoryManager.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 14/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import  CoreData

class SearchHistoryManager {
  private let searchHistoryEntityName = "SearchHistoryCD"
  private let criteriaField = "criteria"
  private let abvField = "abv"
  
  func getSearchHistory(forCriteria criteria: String,
                        in context: NSManagedObjectContext) -> [Int64] {
    
    let req = SearchHistoryCD.fetchRequest() as NSFetchRequest<SearchHistoryCD>
    req.predicate = NSPredicate(format: "\(criteriaField) == %@", criteria)
    //req.sortDescriptors = [ NSSortDescriptor(key: abvField, ascending: ascending)]
    
    if let result = try? context.fetch(req),
      result.count > 0 {
      return result.first!.beerIds as! [Int64]
    }
    
    return []
  }
  
  func saveSearchResults(forCriteria criteria: String, beerIds: [Int64],
                         in context: NSManagedObjectContext) {
    let req = SearchHistoryCD.fetchRequest() as NSFetchRequest<SearchHistoryCD>
    req.predicate = NSPredicate(format: "\(criteriaField) == %@", criteria)
    
    if let result = try? context.fetch(req),
      result.count > 0 {
      return
    }
    
    let tempContext = NSManagedObjectContext(concurrencyType:
      .privateQueueConcurrencyType)
    tempContext.parent = context
    
    let searchHistory = NSEntityDescription.insertNewObject(forEntityName: self.searchHistoryEntityName,
                                                            into: tempContext) as! SearchHistoryCD
    
    searchHistory.beerIds = beerIds as NSObject
    searchHistory.criteria = criteria
    
    try? tempContext.save()
    if let parent = tempContext.parent {
        try? parent.save()
    }
  }
}
