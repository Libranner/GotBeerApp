//
//  BeerPersistenceManager.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 14/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import CoreData

struct BeerPersistenceManager {
  private let beerEntityName = "BeerCD"
  private let beerIdField = "beerId"
  
  func getBeers(withIds ids:[Int64], in context: NSManagedObjectContext) -> [Beer] {
    let req = BeerCD.fetchRequest() as NSFetchRequest<BeerCD>
    req.predicate = NSPredicate(format: "\(beerIdField) IN %@", ids)

    if let result = try? context.fetch(req),
      result.count > 0 {
      return result.compactMap{ Beer(beerCD: $0) }
    }
    
    return []
  }
  
  func saveBeer(beers: [Beer], forCriteria criteria: String, in context: NSManagedObjectContext) {
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
      
      SearchHistoryManager().saveSearchResults(forCriteria: criteria,
                                               beerIds: beersId,
                                               in: context)
    }
  }
}
