import UIKit


class PhotosDirectoryVC: UIViewController {
    
    var userStore: UserStore!
    var requestStore: RequestStore!
    var directoryStore: DirectoryStore!
    var directory: Directory!
    private var tblBackUpImages: UITableView!
    var arryImageBackUp: [ImageBackUp] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let image1 = ImageBackUp()
        let image2 = ImageBackUp()

        image1.name = "first"
        image2.name = "second"
        arryImageBackUp.append(image1)
        arryImageBackUp.append(image2)


        setupTableView()
    }

    private func setupTableView() {
        // Instantiate the table view
        tblBackUpImages = UITableView(frame: view.bounds, style: .plain)

        // Set datasource and delegate
        tblBackUpImages.dataSource = self
        tblBackUpImages.delegate = self

        // Register cell
        tblBackUpImages.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")

        // Add to view
        view.addSubview(tblBackUpImages)

        // Add constraints
        tblBackUpImages.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tblBackUpImages.topAnchor.constraint(equalTo: view.topAnchor),
            tblBackUpImages.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tblBackUpImages.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tblBackUpImages.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}


extension PhotosDirectoryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryImageBackUp.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("- cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        let imageBackup = arryImageBackUp[indexPath.row]
        cell.textLabel?.text = imageBackup.name
        return cell
    }


}





