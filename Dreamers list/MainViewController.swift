//
//  ViewController.swift
//  Dreamers list
//
//  Created by HardiB.Salih on 5/27/18.
//  Copyright © 2018 HardiB.Salih. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class MainViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , DreamerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var dream : [Dreamer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(dreamDeleted(_:)), name: NSNotification.Name(rawValue: "dreamDeleted"), object: nil)

        
    }
    
    @objc func dreamDeleted(_ notification:Notification) {
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    //Mark: fetch data from Coredata to the 
    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
            }
        }
    }
    @IBAction func toAddCoreData(_ sender: Any) {
        performSegue(withIdentifier: "toAddCoreData", sender: nil)
    }
    
    //Mark: fetch data from Coredata
        func fetch(completion: (_ complete: Bool) -> ()) {
            guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
            let fetchRequest = NSFetchRequest<Dreamer>(entityName: "Dreamer")
            let store = NSSortDescriptor(key:"date", ascending: false)
            fetchRequest.sortDescriptors = [store]
            
            do {
                dream = try managedContext.fetch(fetchRequest)
                print("Successfully fetched data.")
                completion(true)
            } catch {
                debugPrint("Could not fetch: \(error.localizedDescription)")
                completion(false)
            }
        }

    func dreamHasBeenRemoved(Remove: Dreamer) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(Remove)
        do {
            try managedContext.save()
            debugPrint("deleted")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "dreamDeleted"), object: nil)
        }catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dream.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dreamerCell", for: indexPath) as? DreamerCell else {  return UITableViewCell() }
        
        let dreams = dream[indexPath.row]
        cell.configureCell(dreams , delegate: self)
        return cell
    }
}



