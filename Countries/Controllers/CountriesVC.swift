import UIKit

class CountriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var countries: [Country] = []
    
    let tableViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CountryCell.self, forCellReuseIdentifier: "CountryCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTableView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureNavTitle() {
           if let customFont = UIFont(name: "SFPro-Bold", size: 24) {
               let attrs = [
                   NSAttributedString.Key.foregroundColor: UIColor.label,
                   NSAttributedString.Key.font: customFont
               ]
               navigationController?.navigationBar.largeTitleTextAttributes = attrs

           }

       }
    
    func setTableView() {

        tableViewContainer.addSubview(tableView)
        view.addSubview(tableViewContainer)
        
        NSLayoutConstraint.activate([
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor)
        ])
    }
    
    func fetchData() {
        NetworkManager.shared.fetchData { [weak self] countries, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            if let countries = countries {
                self.countries = countries
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        let country = countries[indexPath.row]
        cell.configure(with: country)
        
        cell.chevronTapHandler = {
            let detailsVC = DetailsVC()
            detailsVC.country = country
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.pushViewController(detailsVC, animated: false)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        let detailsVC = DetailsVC()
        detailsVC.country = country
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.pushViewController(detailsVC, animated: false)
    }
    
}
