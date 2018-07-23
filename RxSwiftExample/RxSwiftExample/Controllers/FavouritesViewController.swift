//
//  FavouritesViewController.swift
//  RxSwiftExample
//
//  Created by Jhoney Lopes on 17/07/18.
//  Copyright © 2018 Jhoney Lopes. All rights reserved.
//

import UIKit
import Firebase

class FavouritesViewController: UIViewController {
  
  @IBOutlet weak var table: UITableView!
  
  var favouritesMovies: [String] = [] {
    didSet {
      self.table.reloadData()
    }
  }
  var ref: DatabaseReference!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ref = Database.database().reference()
    ref.child("favourites").observeSingleEvent(of: .value) { snapshot in
      for child in snapshot.children.allObjects as! [DataSnapshot] {
        let favouritesMovieDict = child.value as? [String: String] ?? [:]
        if let favouriteMovie = favouritesMovieDict["movie_title"] {
          self.favouritesMovies.append(favouriteMovie)
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favouritesMovies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
      return UITableViewCell()
    }
    
    cell.textLabel?.text = favouritesMovies[indexPath.row]
    
    return cell
  }
}

