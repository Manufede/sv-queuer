import UIKit

class ProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var projects: Array<Dictionary<String, AnyObject?>>?
    var selProj: Dictionary<String, AnyObject?>?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Projects"
        self.fillRequest()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ProjectsViewController.promptProjCreate))
    }
    
    func fillRequest() {
        let request = HttpClass.httpRequest(url: Constants.PROJECTS_URL, httpMethod: HttpClass.httpMethod.GET, httpBody: nil)
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError {
                    let alert = UIAlertController(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", preferredStyle: .alert)
                    let action = UIAlertAction (title: "", style: .default )
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                if let jsonData = data {
                    self.projects = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Array<Dictionary<String, AnyObject?>>
                    self.tableView.reloadData()
                }
            }
        }).resume()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc func promptProjCreate() {
        let vc = UIAlertController(title: "Project name", message: nil, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
            let param =  ["project" : ["name": vc.textFields![0].text as AnyObject, "color": -13508189 as AnyObject]]
            let request = HttpClass.httpRequest(url: Constants.PROJECTS_URL, httpMethod: HttpClass.httpMethod.POST, httpBody: param)
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
                DispatchQueue.main.async{
                    if let error = optError
                    {
                        let alert = UIAlertController(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", preferredStyle: .alert)
                        let action = UIAlertAction (title: "", style: .default )
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.fillRequest()
                }
            }).resume()
        }))
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
        }))
        vc.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "project")
        cell?.textLabel?.text = (projects![indexPath.row])["name"]! as? String
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vC = segue.destination as? ProjectViewController {
            vC.project = selProj
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = projects?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selProj = projects![indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "viewproject", sender: self)
    }
}
