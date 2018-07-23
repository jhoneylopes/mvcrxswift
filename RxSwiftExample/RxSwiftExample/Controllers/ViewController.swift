//
//  ViewController.swift
//  RxSwiftExample
//
//  Created by Jhoney Lopes on 15/07/18.
//  Copyright © 2018 Jhoney Lopes. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import Firebase

class ViewController: UIViewController {

  @IBOutlet weak var table: UITableView!
  @IBOutlet weak var srcMoviesSearch: UISearchBar!
  
  // MARK: - Propeties
  var ref: DatabaseReference!
  var movies: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()
    
    srcMoviesSearch.rx.text
      .orEmpty
      .distinctUntilChanged()
      .filter({ !$0.isEmpty })
      .debounce(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { query in
        let url = "https://www.omdbapi.com/?apikey=40fd639a&s=" + query
        Alamofire.request(url).responseJSON(completionHandler: { response in
          if let value = response.result.value {
            let json = JSON(value)
            
            self.movies.removeAll()
            
            for movie in json["Search"] {
              if let title = movie.1["Title"].string {
                self.movies.append(title)
              }
            }
            
            self.table.reloadData()
          }
        })
      })
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
      return UITableViewCell()
    }
    
    cell.textLabel?.text = movies[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedMovie = movies[indexPath.row]
    
    ref.child("favourites").childByAutoId().setValue(["movie_title": selectedMovie])
  }
}
