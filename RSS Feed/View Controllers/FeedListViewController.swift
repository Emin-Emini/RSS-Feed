//
//  ViewController.swift
//  RSS Feed
//
//  Created by Emin Emini on 5.6.21.
//

import UIKit

class FeedListViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var feedListTableView: UITableView!
    
    //MARK: Properties
    var feedList = [
        FeedListModel(url: "http://feeds.wired.com/wired/index", title: "Wired"),
        FeedListModel(url: "https://www.buzzfeed.com/world.xml", title: "BuzzFeed"),
        FeedListModel(url: "http://www.npr.org/rss/rss.php?id=1001", title: "NPR Topics: News"),
        FeedListModel(url: "http://feeds.sciencedaily.com/sciencedaily", title: "ScienceDaily Headlines"),
        FeedListModel(url: "https://www.buzzfeed.com/world.xml", title: "BuzzFeed")
    ]
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        feedListTableView.delegate = self
        feedListTableView.dataSource = self
    }
    
    //MARK: Actions
    @IBAction func addNewFeed(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Feed", message: "Add new RSS Feed by filling fields below.", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Feed Name"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "RSS URL"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textFieldName = alert?.textFields![0]
            let textFieldURL = alert?.textFields![1]// Force unwrapping because we know it exists.
            //print("Text field: \(textField!.text)")
            
            self.feedList.append(FeedListModel(url: (textFieldURL?.text)!, title: (textFieldName?.text)!))
            self.feedListTableView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          
          if editingStyle == .delete {
              feedList.remove(at: indexPath.row)
              feedListTableView.deleteRows(at: [indexPath], with: .bottom)
          }
      }
    
}
