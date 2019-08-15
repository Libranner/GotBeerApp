//
//  BeerLocalProvider.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 14/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import  CoreData

class BeerLocalProvider: LocalProvider {
  private let searchHistoryEntityName = "SearchHistoryCD"
  private let criteriaField = "criteria"
  private let abvField = "abv"
  private let beerEntityName = "BeerCD"
  private let beerIdField = "beerId"
  
  func getBeers(withIds ids:[Int64]) -> [Beer] {
    let context = CoreDataManager.shared.context
    let req = BeerCD.fetchRequest() as NSFetchRequest<BeerCD>
    req.predicate = NSPredicate(format: "\(beerIdField) IN %@", ids)
    
    if let result = try? context.fetch(req),
      result.count > 0 {
      return result.compactMap({ (beerCD) -> Beer in
        return Beer(beerId: beerCD.beerId,
                    name: beerCD.name ?? "",
                    tagline: beerCD.tagline ?? "",
                    beerDescription: beerCD.beerDescription ?? "",
                    imageUrl: beerCD.imageUrl,
                    abv: beerCD.abv,
                    foodPairing: beerCD.foodPairing as? [String] ?? [],
                    brewerTips: beerCD.brewerTips)
      })
    }
    
    return []
  }
  
  func saveBeers(_ beers: [Beer], forCriteria criteria: String) {
    let context = CoreDataManager.shared.context
    let tempContext = NSManagedObjectContext(concurrencyType:
      .privateQueueConcurrencyType)
    tempContext.parent = context
    
    for beer in beers {
      let req = BeerCD.fetchRequest() as NSFetchRequest<BeerCD>
      req.predicate = NSPredicate(format: "\(beerIdField) == %d", beer.beerId)
      
      if let result = try? context.fetch(req),
        result.count > 0 {
        continue
      }
      
      let newBeer = NSEntityDescription.insertNewObject(forEntityName: self.beerEntityName,
                                                        into: tempContext) as! BeerCD
      newBeer.beerId = beer.beerId
      newBeer.name = beer.name
      newBeer.abv = beer.abv
      newBeer.tagline = beer.tagline
      newBeer.beerDescription = beer.beerDescription
      newBeer.brewerTips = beer.brewerTips
      newBeer.imageUrl = beer.imageUrl
      newBeer.foodPairing = beer.foodPairing as NSObject
    }
    
    try? tempContext.save()
    if let parent = tempContext.parent {
      try? parent.save()
      
      let beersId = beers.compactMap({ beer -> Int64 in
        return beer.beerId
      })
      
      saveSearchResults(forCriteria: criteria,
                                               beerIds: beersId,
                                               in: context)
    }
  }
  
  func getSearchHistory(forCriteria criteria: String) -> [Int64] {
    let context = CoreDataManager.shared.context
    let req = SearchHistoryCD.fetchRequest() as NSFetchRequest<SearchHistoryCD>
    req.predicate = NSPredicate(format: "\(criteriaField) == %@", criteria)
    //req.sortDescriptors = [ NSSortDescriptor(key: abvField, ascending: ascending)]
    
    if let result = try? context.fetch(req),
      result.count > 0 {
      return result.first!.beerIds as! [Int64]
    }
    
    return []
  }
  
  private func saveSearchResults(forCriteria criteria: String, beerIds: [Int64],
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
