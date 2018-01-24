import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameFiedl: UITextField!
    @IBOutlet weak var password_field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginpressed(_ sender: Any) {
        let param = ["username": usernameFiedl.text, "password": password_field.text]
        let request = HttpClass.httpRequest(url: Constants.SESSION_URL, httpMethod: HttpClass.httpMethod.POST, httpBody: param)
        
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                    if let error = optError {
                        let alert = UIAlertController(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", preferredStyle: .alert)
                        let action = UIAlertAction (title: "Login doesn't succeed", style: .default )
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                if ((response as? HTTPURLResponse)?.statusCode) != nil {
                        if let jsonData = data {
                            do {
                                let dict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary
                                UserDefaults.standard.set(dict?["api_key"], forKey: "apiKey")
                                self.performSegue(withIdentifier: "projects", sender: self)
                            }catch _ as NSError {
                                
                            }
                        }
                }
            }
        }).resume()
    }
}
