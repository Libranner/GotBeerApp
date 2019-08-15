//
//  BeerDetailViewController.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 15/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class BeerDetailViewController: UIViewController {
  
  @IBOutlet var abvLabel: UILabel!
  @IBOutlet var imageView: AsyncImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var taglineLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var tipsLabel: UILabel!
  
  var beer: BeerViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
  }
  
  private func loadData() {
    guard let unwrappedBeer = beer else {
      return
    }
    
    if let url = unwrappedBeer.imageUrl {
      imageView.fillWithURL(url, placeholder: "beer")
    }
    
    abvLabel.text = unwrappedBeer.abvString
    nameLabel.text =  unwrappedBeer.name
    taglineLabel.text = unwrappedBeer.tagline
    descriptionLabel.text = unwrappedBeer.beerDescription
    tipsLabel.text = unwrappedBeer.brewerTips
  }
}
