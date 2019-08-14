//
//  BeersCollectionViewController.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 12/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BeersCollectionViewController: UICollectionViewController {  
  private let viewModel = BeersListViewModel()
  private let reuseIdentifier = "Cell"
  private let disposeBag = DisposeBag()
  private var showingSearchBar = false
  private var sortAscending = true
  
  @IBOutlet var showSearchBarButton: UIBarButtonItem!
  @IBOutlet var searchView: SearchView!
  @IBOutlet var noResultsView: UIView!
  
  @IBOutlet var sortBarButton: UIBarButtonItem!
  private var searchBarTopConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.clearsSelectionOnViewWillAppear = false
    
    setupAdditionalViews()
    setupLayout()
    setupBindings()

    let tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(hideSearchBar))
    view.addGestureRecognizer(tapGesture)
    
    showSearchBar()
  }
  
  private func sortCollection() {
    sortAscending.toggle()
    viewModel.reSortData(ascending: sortAscending)
    
    let image = sortAscending ? UIImage(named: "sort_up") : UIImage(named: "sort_down")
    sortBarButton.image = image
  }
  
  private func setupAdditionalViews() {
    searchView.delegate = self
    searchView.translatesAutoresizingMaskIntoConstraints = false
    searchView.isHidden = true
    view.addSubview(searchView)
    
    searchBarTopConstraint = searchView.topAnchor.constraint(equalTo:
      view.safeAreaLayoutGuide.topAnchor, constant: -100)
    
    NSLayoutConstraint.activate([
      searchView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
      searchView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      searchBarTopConstraint,
      searchView.heightAnchor.constraint(equalToConstant: 60)
      ])
    
    view.addSubview(noResultsView)
    noResultsView.translatesAutoresizingMaskIntoConstraints = false
    noResultsView.backgroundColor = .clear
    
    NSLayoutConstraint.activate([
      noResultsView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
      noResultsView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      noResultsView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -50),
      noResultsView.heightAnchor.constraint(equalToConstant: 60)
      ])
  }
  
  private func showSearchBar() {
    guard !showingSearchBar else {
      hideSearchBar()
      return
    }
    
    showingSearchBar = true
    searchView.isHidden = false
    
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
      self.searchBarTopConstraint.constant = 20
      self.view.layoutIfNeeded()
    }, completion: { _ in
      self.searchView.isHidden = false
    })
  }
  
  @objc private func hideSearchBar() {
    view.endEditing(true)
    showingSearchBar = false
  
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
      self.searchBarTopConstraint.constant = -100
      self.view.layoutIfNeeded()
    }, completion: { _ in
      self.searchView.isHidden = true
    })
  }
  
  //Setup Colllection View Flow Layout
  private func setupLayout() {
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.sectionInset = UIEdgeInsets(top: CGFloat(20),
                                         left: 5.0, bottom: 5.0, right: 5.0)
      layout.minimumLineSpacing = 20
    }
  }
  
  private func setupBindings() {
    collectionView.delegate = nil
    collectionView.dataSource = nil
    
    viewModel.filteredBeers
      .observeOn(MainScheduler.instance)
      .bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier,
                                        cellType: BeerCollectionViewCell.self)) {
        (row, beer, cell) in
        cell.configure(beer: beer)
      }
      .disposed(by: disposeBag)
    
    viewModel.noResultsAvailable
    .observeOn(MainScheduler.instance)
    .bind { [weak self] show in
      self?.noResultsView.isHidden = !show
    }.disposed(by: disposeBag)
    
    showSearchBarButton.rx.tap.bind { [weak self] in
      self?.showSearchBar()
      }.disposed(by: disposeBag)
    
    sortBarButton.rx.tap.bind { [weak self] in
      self?.sortCollection()
      }.disposed(by: disposeBag)
  }
}

//MARK: - Search View Delegate implementation
extension BeersCollectionViewController: SearchViewDelegate {
  func searchView(_ searchView: SearchView, didSearchFor text: String) {
    guard !text.isEmpty else {
      hideSearchBar()
      return
    }
    viewModel.loadData(forCriteria: text, ascending: sortAscending)
  }
  
  func searchViewShouldDismiss() {
    hideSearchBar()
  }
}