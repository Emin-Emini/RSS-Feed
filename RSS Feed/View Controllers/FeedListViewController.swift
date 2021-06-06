//
//  ViewController.swift
//  RSS Feed
//
//  Created by Emin Emini on 5.6.21.
//

import UIKit

//MARK: Properties
var feedList = [
    FeedListModel(url: "http://feeds.wired.com/wired/index", title: "Wired"),
    FeedListModel(url: "https://www.buzzfeed.com/world.xml", title: "BuzzFeed"),
    FeedListModel(url: "http://www.npr.org/rss/rss.php?id=1001", title: "NPR Topics: News"),
    FeedListModel(url: "http://feeds.sciencedaily.com/sciencedaily", title: "ScienceDaily Headlines"),
    FeedListModel(url: "https://www.buzzfeed.com/world.xml", title: "BuzzFeed")
]

class FeedListViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var feedListTableView: UITableView!
    
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        feedListTableView.delegate = self
        feedListTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadList"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        feedListTableView.reloadData()
    }

}

//MARK: - Functions
extension FeedListViewController {
    @objc func loadList(notification: NSNotification){
        self.feedListTableView.reloadData()
    }
}

//MARK: - Table View
extension FeedListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedListCell", for: indexPath) as! FeedListTableViewCell
        
        let feed = feedList[indexPath.row]
        cell.feedTitle.text = feed.title
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedPostsVC: FeedPostsViewController =
            self.storyboard!.instantiateViewController(withIdentifier: "FeedPostsViewController") as! FeedPostsViewController
        
        let feed = feedList[indexPath.row]
        feedURL = URL(string: feed.url)!
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.present(feedPostsVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          
          if editingStyle == .delete {
              feedList.remove(at: indexPath.row)
              feedListTableView.deleteRows(at: [indexPath], with: .bottom)
          }
      }
    
}
