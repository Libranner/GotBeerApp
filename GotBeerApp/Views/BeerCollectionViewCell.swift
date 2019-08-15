//
//  BeerCollectionViewCell.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 12/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
  @IBOutlet var imageView: AsyncImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var taglineLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var abvLabel: UILabel!
  
  private var shouldShowMore = false
  //@IBOutlet var bottomView: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
  
  @IBAction func showMoreButtonTapped(_ sender: Any) {
    shouldShowMore.toggle()
    //bottomView.isHidden = !shouldShowMore

    setNeedsLayout()
    updateConstraints()
  }

  private func setupUI() {
    let borderColor = UIColor.lightGray.cgColor
    let borderWidth: CGFloat = 1.0
    let shadowColor = UIColor.lightGray.cgColor
    
    self.contentView.layer.cornerRadius = 10.0
    self.contentView.layer.borderWidth = 1.0
    self.contentView.layer.borderColor = UIColor.clear.cgColor
    self.contentView.layer.masksToBounds = true
    
    backgroundColor = .white
    layer.cornerRadius = 10
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor
    
    layer.shadowColor = shadowColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: 0, height: 2.0)
    layer.shadowRadius = 2.0
    layer.masksToBounds = false
    layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
  }
  
  func configure(beer: Beer) {
    nameLabel.text = beer.name
    taglineLabel.text = beer.tagline
    abvLabel.text = "\(beer.abv)"
    descriptionLabel.text = beer.beerDescription
    
    if let imageUrl = beer.imageURL {
      imageView.fillWithURL(imageUrl, placeholder: nil)
    }
  }
  
  override func prepareForReuse() {
    imageView.image = UIImage(named: "beer")
    nameLabel.text = ""
    taglineLabel.text = ""
    abvLabel.text = ""
    descriptionLabel.text = ""
  }
}
