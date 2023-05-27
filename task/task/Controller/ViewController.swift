//
//  ViewController.swift
//  task
//
//  Created by Tirumala on 27/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    let viewModel = ViewControllerViewModel()
    var fromIndex = 0
    let batchSize = 20
    var dataArray = [ResponseDataModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpTableView()
        //loadItemsNow(listType: 10)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        viewModel.getDataFromServer { datas in
            self.dataArray = datas
           

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataArray.removeAll()
        loadMoreItems()
    }

    

    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

     // not required when using UITableViewController
    
    
    //MARK: -- setUpTableView
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 120.0
    }
    
    func loadMoreItems() {
        
        //let endIndex = min(totalItems, fromIndex + batchSize)
        
//        for i in fromIndex ..< endIndex {
//            privateList.append(String(i))
//        }
        
        //print("Loading items form \(fromIndex) to \(endIndex - 1)")
        
        //fromIndex = endIndex
        //aTableView.reloadData()
        
        
       // loadItemsNow(listType: 10)
        self.refreshControl.endRefreshing()
    }
    
    
    func loadItemsNow(listType:Int){
        //myActivityIndicator.startAnimating()
        
        let listUlrString = "https://picsum.photos/v2/list?page=2&limit=\(listType)"
       // let listUrlString = "http://infavori.com/json2.php?batchSize=" + String(fromIndex + batchSize) + "&fromIndex=" + String(fromIndex) + "&listType=" + listType
        let myUrl = NSURL(string: listUlrString);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "GET";
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    
                }
                
                return
            }
            
            
            do {
                
                let dataResponse = try JSONDecoder().decode([ResponseDataModel].self, from: data!)
               
                
               // if let parseJSON = dataResponse {
                    //self.privateList = parseJSON as! [String]

                let items = dataResponse
                    
                    
                    if self.fromIndex < items.count {
                        
                        self.dataArray = items
                        self.fromIndex = items.count
                        
                        DispatchQueue.main.async {
                            //self.myActivityIndicator.stopAnimating()
                            //self.myTableView.reloadData()
                            self.refreshControl.beginRefreshing()
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                        }
                    }
                
                
            } catch {
                print(error)
                
            }
        }
        
        task.resume()
    }

}

    
 
 

//MARK: -- UITableView Delegate And DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
       cell.configureData(data: dataArray[indexPath.row])
        cell.checkBtn.addTarget(self, action: #selector(tapAction(_:)), for: UIControl.Event.touchUpInside)
       
       
        if indexPath.row == dataArray.count - 1 { // last cell
            //if totalItems > privateList.count {
            //removing totalItems for always service call
            self.refreshControl.beginRefreshing()
                loadMoreItems()
            self.refreshControl.endRefreshing()
            
           
            //}
        }
            //cell.checkBtn.addTarget(self, action: #selector(tapAction(UIButton())), for: UIControl.Event.touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
  
    
    @objc func tapAction(_ sender:UIButton){
            let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: tableView)
            let indexPath = tableView.indexPathForRow(at: buttonPosition)
            let cell = tableView.cellForRow(at: indexPath!) as! TitleTableViewCell
        if cell.checkBtn.isSelected == true {
                cell.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
                let alert = UIAlertController(title: "Title", message: "\(dataArray[indexPath!.row].author ?? "")", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                     cell.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for: UIControl.State.normal)
                   }))
              //  alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
           present(alert, animated: true)

            } else {
                
                cell.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for:.normal)
            }
            cell.checkBtn.isSelected = !cell.checkBtn.isSelected
    
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
        //return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Title", message: "\(dataArray[indexPath.row].author ?? "")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
   present(alert, animated: true)
        
    }
    
//    @objc func tapAction( _ sender:UIButton){
//        let cell = tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
//
//        if cell..isSelected {
//            cell.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
//        } else {
//            cell.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for:.normal)
//        }
//        cell.checkBtn.isSelected = !cell.checkBtn.isSelected
//
//    }
}

