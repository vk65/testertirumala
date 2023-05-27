//
//  TitleTableViewCell.swift
//  task
//
//  Created by Tirumala on 27/05/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 10.0
        bgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureData(data: ResponseDataModel) {
        
        
        
        
        
        self.titleLbl.text = "Id: \( data.id ?? "0")"
        self.descriptionLbl.text = "Description: \(data.author ?? "")"
        self.checkBtn.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
        self.checkBtn.addTarget(self, action: #selector(myAction(_:)), for: UIControl.Event.touchUpInside)
        let url = URL(string: data.download_url ?? "")!
        titleImg.contentMode = .scaleToFill
        titleImg.downloaded(from: url)
    }
    
    @objc func myAction(_ sender:UIButton){
        tapAction()//parameters//)
    }
    
        @objc func tapAction(){
                
            if self.checkBtn.isTouchInside {
                self.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
            } else {
                self.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for:.normal)
            }
            self.checkBtn.isSelected = !self.checkBtn.isSelected
    
        }
    
   
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
   
        public func imageFromUrl(urlString: String) {
            if let url = NSURL(string: urlString) {
                let request = NSURLRequest(url: url as URL)
                NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { URLResponse, data, error in
                
                    
                    if let imageData = data as NSData? {
                        self.image = UIImage(data: imageData as Data)
                    }
                }
            }
        }
}

    

