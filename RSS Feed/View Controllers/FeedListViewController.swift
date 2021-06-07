//
//  ViewController.swift
//  RSS Feed
//
//  Created by Emin Emini on 5.6.21.
//

import UIKit
import CoreData

class FeedListViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var feedListTableView: UITableView!
    @IBOutlet weak var emptyListIndicatorView: UIView!
    
    //MARK: Properties
    var feedList = [FeedList]()
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureTableViews()
        loadSomeData() //Comment this line if you don't want to use provided data
        fetchFromCoreData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        feedListTableView.reloadData()
        checkIfListIsEmpty()
    }

}

//MARK: - Functions
extension FeedListViewController {
    @objc func loadList(notification: NSNotification){
        fetchFromCoreData()
        checkIfListIsEmpty()
        self.feedListTableView.reloadData()
    }
    
    private func checkIfListIsEmpty() {
        if feedList.isEmpty {
            emptyListIndicatorView.isHidden = false
        } else {
            emptyListIndicatorView.isHidden = true
        }
    }
}

//MARK: - Table View
extension FeedListViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func configureTableViews() {
        feedListTableView.delegate = self
        feedListTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadList"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedListCell", for: indexPath) as! FeedListTableViewCell
        
        let feed = feedList[indexPath.row]
        cell.feedName.text = feed.feedName
        
        //Assign Image from parsed RSS Feed
        guard let imageURL = URL(string: feed.imageUrl ?? "") else { return cell }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                cell.feedImage.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedPostsVC: FeedPostsViewController =
            self.storyboard!.instantiateViewController(withIdentifier: "FeedPostsViewController") as! FeedPostsViewController
        
        let feed = feedList[indexPath.row]
        feedURL = URL(string: feed.feedUrl!)!
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.present(feedPostsVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(feedList[indexPath.row])
        feedList.remove(at: indexPath.row)
        do {
            try managedContext.save()
        } catch _ {
        }
        
        checkIfListIsEmpty()
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}


//MARK: - Core Data
extension FeedListViewController: FeedProtocol {
    func saveToCoreData(feedUrl: String, feedName: String, imageUrl: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "FeedList", in: managedContext)!
        let newValue = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        newValue.setValue(feedUrl, forKeyPath: "feedUrl")
        newValue.setValue(feedName, forKeyPath: "feedName")
        newValue.setValue(imageUrl, forKeyPath: "imageUrl")
        
        // 4
        do {
            try managedContext.save()
            feedList.append(newValue as! FeedList)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func fetchFromCoreData() {
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FeedList")
        
        //3
        do {
            feedList = try managedContext.fetch(fetchRequest) as! [FeedList]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    //This function will remove all of the data in an Entity of Core Data
    private func resetCoreData(in entity: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch {
            print ("There was an error")
        }
    }
    
    //Fill some RSS Feeds in Core Data (This function will remove all of the previous data, and will add new data)
    private func loadSomeData() {
        resetCoreData(in: "FeedList")
        saveToCoreData(feedUrl: "http://feeds.wired.com/wired/index",
                       feedName: "Wired",
                       imageUrl: "")
        
        saveToCoreData(feedUrl: "https://www.buzzfeed.com/world.xml",
                       feedName: "BuzzFeed",
                       imageUrl: "https://webappstatic.buzzfeed.com/static/images/public/rss/logo-news.png")
        
        saveToCoreData(feedUrl: "http://www.npr.org/rss/rss.php?id=1001",
                       feedName: "NPR Topics: News",
                       imageUrl: "https://media.npr.org/images/podcasts/primary/npr_generic_image_300.jpg?s=200")
        
        saveToCoreData(feedUrl: "http://feeds.sciencedaily.com/sciencedaily",
                       feedName: "ScienceDaily Headlines",
                       imageUrl: "https://www.sciencedaily.com/images/scidaily-logo-rss.png")
    }
}

protocol FeedProtocol: AnyObject {
    func saveToCoreData(feedUrl: String, feedName: String, imageUrl: String)
}
