//
//  ViewControllerViewModel.swift
//  task
//
//  Created by Tirumala on 27/05/23.
//

import UIKit

class ViewControllerViewModel: NSObject {
    
    func getDataFromServer(completionHandler: @escaping (_ datas: [ResponseDataModel]) -> Void) {
        let url = URL(string: baseUrl)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if (error != nil) == false {
                do {
                    let dataResponse = try JSONDecoder().decode([ResponseDataModel].self, from: data!)
                    completionHandler(dataResponse)
                }catch let error {
                    print("Error: \(error)")
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
        task.resume()
    }
    
     
}
