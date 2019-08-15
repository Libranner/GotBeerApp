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
  private let showDetailSegue = "showDetail"
  
  @IBOutlet var showSearchBarButton: UIBarButtonItem!
  @IBOutlet var searchView: SearchView!
  @IBOutlet var noResultsView: UIView!
  private var selectedBeer: Beer?
  
  @IBOutlet var sortBarButton: UIBarButtonItem!
  private var searchBarTopConstraint: NSLayoutConstraint!
  
  lazy var activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.hidesWhenStopped = true
    
    self.view.addSubview(activityIndicatorView)
    NSLayoutConstraint.activate([
      activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicatorView.topAnchor.constraint(equalTo:
        view.safeAreaLayoutGuide.topAnchor, constant: 20)
      ])
    
    return activityIndicatorView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.clearsSelectionOnViewWillAppear = false
    
    setupAdditionalViews()
    setupLayout()
    setupBindings()
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
      searchView.widthAnchor.constraint(equalTo:
        view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
      searchView.centerXAnchor.constraint(equalTo:
        view.safeAreaLayoutGuide.centerXAnchor),
      searchBarTopConstraint,
      searchView.heightAnchor.constraint(equalToConstant: 60)
      ])
    
    view.addSubview(noResultsView)
    noResultsView.translatesAutoresizingMaskIntoConstraints = false
    noResultsView.backgroundColor = .clear
    
    NSLayoutConstraint.activate([
      noResultsView.widthAnchor.constraint(equalTo:
        view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
      noResultsView.centerXAnchor.constraint(equalTo:
        view.safeAreaLayoutGuide.centerXAnchor),
      noResultsView.topAnchor.constraint(equalTo:
        view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
    noResultsView.isHidden = true
    
    UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
      self.searchBarTopConstraint.constant = 20
      self.view.layoutIfNeeded()
    }, completion: { _ in
      self.searchView.isHidden = false
    })
  }
  
  private func hideSearchBar() {
    view.endEditing(true)
    showingSearchBar = false
    
    UIView.animate(withDuration: 0.35, delay: 0, options: .curveLinear, animations: {
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
    
    viewModel.loading
      .observeOn(MainScheduler.instance)
      .bind { [weak self] isLoading in
        if isLoading {
          self?.activityIndicatorView.isHidden = false
          self?.activityIndicatorView.startAnimating()
        }
        else {
          self?.activityIndicatorView.stopAnimating()
        }
      }.disposed(by: disposeBag)
    
    collectionView.rx
      .willDisplayCell
      .subscribe(onNext: { cell, indexPath in
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
          cell.alpha = 1
        }
      })
      .disposed(by: disposeBag)
    
    collectionView.rx
      .modelSelected(Beer.self)
      .subscribe({ value in
        DispatchQueue.main.async {
          self.selectedBeer = value.element
          self.performSegue(withIdentifier: self.showDetailSegue,
                            sender: self)
        }
      })
      .disposed(by: disposeBag)
    
    showSearchBarButton.rx.tap.bind { [weak self] in
      self?.showSearchBar()
      }.disposed(by: disposeBag)
    
    sortBarButton.rx.tap.bind { [weak self] in
      self?.sortCollection()
      }.disposed(by: disposeBag)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showDetailSegue {
      if let destinationVC = segue.destination as? BeerDetailViewController {
       destinationVC.beer = selectedBeer
      }
    }
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
