//
//  BeersListViewModel.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 13/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BeersListViewModel {
  var filteredBeers = BehaviorSubject<[BeerViewModel]>(value: [])
  var noResultsAvailable = BehaviorSubject<Bool>(value: false)
  var loading = BehaviorSubject<Bool>(value: false)
  
  private let disposeBag = DisposeBag()

  func loadData(forCriteria food: String, ascending: Bool = false) {
    guard !food.isEmpty else {
      return
    }
    
    loading.onNext(true)
    let ids = SearchHistoryManager().getSearchHistory(forCriteria: food,
                                                      in: CoreDataManager.shared.context)
    
    if !ids.isEmpty {
      let data = BeerPersistenceManager().getBeers(withIds: ids,
                                                   in: CoreDataManager.shared.context)
      self.completeLoad(beers: data, ascending: ascending)
    }
    else {
      ApiClient.getBeers(food: food) { [weak self] data,  error in
        BeerPersistenceManager().saveBeer(beers: data, forCriteria: food,
                                          in: CoreDataManager.shared.context)
        self?.completeLoad(beers: data, ascending: ascending)
      }
    }
  }
  
  private func completeLoad(beers: [Beer], ascending: Bool) {
    let data = beers.compactMap { convertToViewModel(beer: $0) }
    
    filteredBeers.onNext(sortBeers(data, abvAscending: ascending))
    noResultsAvailable.onNext(data.count == 0)
    loading.onNext(false)
  }
  
  private func convertToViewModel(beer: Beer) -> BeerViewModel{
    return BeerViewModel(beer: beer)
  }
  
  func reSortData(ascending:Bool) {
    let data = try? filteredBeers.value()
    if data != nil && data!.count > 0 {
      filteredBeers.onNext(sortBeers(data!, abvAscending: ascending))
    }
  }
  
  private func sortBeers(_ beers: [BeerViewModel], abvAscending: Bool) -> [BeerViewModel] {
    if abvAscending {
      return beers.sorted { $0.abv > $1.abv }
    }
    
    return beers.sorted { $0.abv < $1.abv }
  }
}
