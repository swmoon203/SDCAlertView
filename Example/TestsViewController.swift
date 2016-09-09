import SDCAlertView

@available(iOS 9, *)
class TestsViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath as NSIndexPath).row {
            case 0:
                AlertController.alertWithTitle("Title", message: "Message", actionTitle: "OK")

            case 1, 3:
                let alert = AlertController(title: "Title", message: "Message")
                alert.addAction(AlertAction(title: "OK", style: .default))
                alert.addAction(AlertAction(title: "Cancel", style: .preferred))
                alert.present()

            case 2:
                let alert = AlertController(title: "Title", message: "Message")
                alert.addAction(AlertAction(title: "OK", style: .default))
                alert.addAction(AlertAction(title: "Cancel", style: .preferred))
                alert.shouldDismissHandler = { $0?.title == "Cancel" }
                alert.present()

            case 4:
                let alert = AlertController(title: "Title", message: "Message")
                alert.addAction(AlertAction(title: "OK", style: .default))
                alert.addAction(AlertAction(title: "Cancel", style: .preferred))
                alert.addAction(AlertAction(title: "Button", style: .default))
                alert.present()

            case 5:
                let alert = AlertController(title: "Title", message: "Message")
                alert.actionLayout = .vertical
                alert.addAction(AlertAction(title: "OK", style: .default))
                alert.addAction(AlertAction(title: "Cancel", style: .preferred))
                alert.present()

            case 6:
                let alert = AlertController(title: "Title", message: "Message")
                alert.actionLayout = .horizontal
                alert.addAction(AlertAction(title: "OK", style: .default))
                alert.addAction(AlertAction(title: "Cancel", style: .preferred))
                alert.addAction(AlertAction(title: "Button", style: .default))
                alert.present()

            case 7:
                let alert = AlertController(title: "Title", message: "Message")
                alert.addTextFieldWithConfigurationHandler { textField in
                    textField.text = "Sample text"
                }
                alert.addAction(AlertAction(title: "OK", style: .preferred))
                alert.present()

            case 8:
                let alert = AlertController(title: "Title", message: "Message")
                let contentView = alert.contentView
                let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                spinner.translatesAutoresizingMaskIntoConstraints = false
                spinner.startAnimating()
                contentView.addSubview(spinner)
                spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
                spinner.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                spinner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                alert.present()
            
            default: break
        }
    }

}
