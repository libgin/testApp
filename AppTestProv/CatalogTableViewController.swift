//
//  CatalogTableView.swift
//  AppTestProv
//
//  Created by victor on 10.09.2018.
//  Copyright © 2018 vic. All rights reserved.
//

import Foundation
import UIKit

class CatalogTableViewController : UITableViewController {
    
    @IBOutlet var movieTabel: UITableView!
    let viewModel = CatalogTableViewModel()
    
    var filteredMovieArr:[Movie] = []
    var filteredMovieDBArr:[MovieDB] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.isReachable { _ in
         print("isReachable")
        }
        NetworkManager.isUnreachable { _ in
            print("isUnreachable")
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie by title"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        let catalogCellNib = UINib(nibName: "CatalogTableViewCell", bundle: nil)
        movieTabel.register(catalogCellNib, forCellReuseIdentifier: "CatalogCell")
        
        viewModel.genreListCommand.execute()
        viewModel.genreListCommand.subscribe { [unowned self] _ in
            self.viewModel.popularityMovieiCommand.execute()
            self.viewModel.popularityMovieiCommand.subscribe { [unowned self] result in
                switch result {
                case .Success(value: ):
                    break
                case .Failure( _):
                    self.movieTabel.reloadData()
                    
                    break
                default:
                    break
                }
            }
        }
        viewModel.movieModel.change.subscribe{ [unowned self] _ in
            self.movieTabel.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movieTabel.rowHeight = UITableViewAutomaticDimension
        movieTabel.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var isReachable = false
        NetworkManager.isReachable { _ in
            isReachable = true
        }
        return (isReachable == true) ? self.getDataModel().count : self.getDataDB().count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let catalogCell = tableView.dequeueReusableCell(withIdentifier: "CatalogCell", for: indexPath) as! CatalogTableViewCell
        NetworkManager.isReachable { _ in
             catalogCell.setContent(movie: self.getDataModel()[indexPath.row])
        }
        NetworkManager.isUnreachable { _ in
            catalogCell.setContentFromDB(movie: self.getDataDB()[indexPath.row])
        }

        return catalogCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        NetworkManager.isReachable { _ in
            if !self.isFiltering() {
                if indexPath.row + 2 == self.viewModel.movieModel.get.count {
                    self.viewModel.pageNumberProrerty.set(value: self.viewModel.pageNumberProrerty.get + 1)
                    self.viewModel.popularityMovieiCommand.execute()
                }
            }
        }
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkManager.isReachable { _ in
            self.viewModel.movieForDetail.set(value: self.getDataModel()[indexPath.row])
        }
        NetworkManager.isUnreachable { _ in
            self.viewModel.movieForDetailDB.set(value: self.getDataDB()[indexPath.row])
        }
        
        self.performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailViewController
        
        NetworkManager.isReachable { _ in
            detailViewController.viewModel.movieDetailDB.set(value: nil)
            detailViewController.viewModel.movieDetail.set(value: self.viewModel.movieForDetail.get)
        }
        
        NetworkManager.isUnreachable { _ in
            detailViewController.viewModel.movieDetail.set(value: nil)
            detailViewController.viewModel.movieDetailDB.set(value: self.viewModel.movieForDetailDB.get)
        }

    }
    
    func filterContentForSearchText(_ searchText: String) {
        
         NetworkManager.isReachable { _ in
            self.filteredMovieArr = self.viewModel.movieModel.get.filter({( movie : Movie) -> Bool in
                if self.searchBarIsEmpty() {
                    return false
                } else {
                    return  movie.title!.lowercased().contains(searchText.lowercased())
                }
            })
            self.tableView.reloadData()
        }
        
        NetworkManager.isUnreachable { _ in
            self.filteredMovieDBArr = self.viewModel.fetchMovies().filter({( movie : MovieDB) -> Bool in
                if self.searchBarIsEmpty() {
                    return false
                } else {
                    return  movie.title!.lowercased().contains(searchText.lowercased())
                }
            })
            self.tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    func getDataDB() -> [MovieDB] {
        if isFiltering() {
            return  filteredMovieDBArr
        } else {
            return self.viewModel.fetchMovies()
        }
    }
    
    func getDataModel() -> Array<Movie> {
        if isFiltering() {
            return filteredMovieArr
        } else {
            return self.viewModel.movieModel.get
        }
    }
}

extension CatalogTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension CatalogTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


