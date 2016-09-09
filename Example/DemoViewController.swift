import UIKit
import SDCAlertView
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


final class DemoViewController: UITableViewController {

    @IBOutlet fileprivate var typeControl: UISegmentedControl!
    @IBOutlet fileprivate var styleControl: UISegmentedControl!
    @IBOutlet fileprivate var titleTextField: UITextField!
    @IBOutlet fileprivate var messageTextField: UITextField!
    @IBOutlet fileprivate var textFieldCountTextField: UITextField!
    @IBOutlet fileprivate var buttonCountTextField: UITextField!
    @IBOutlet fileprivate var buttonLayoutControl: UISegmentedControl!
    @IBOutlet fileprivate var contentControl: UISegmentedControl!

    @IBAction fileprivate func presentAlert() {
        if self.typeControl.selectedSegmentIndex == 0 {
            self.presentSDCAlertController()
        } else {
            self.presentUIAlertController()
        }
    }

    fileprivate func presentSDCAlertController() {
        let title = self.titleTextField.content
        let message = self.messageTextField.content
        let style = AlertControllerStyle(rawValue: self.styleControl.selectedSegmentIndex)!
        let alert = AlertController(title: title, message: message, preferredStyle: style)

        let textFields = Int(self.textFieldCountTextField.content ?? "0")!
        for _ in 0..<textFields {
            alert.addTextFieldWithConfigurationHandler()
        }

        let buttons = Int(self.buttonCountTextField.content ?? "0")!
        for i in 0..<buttons {
            if i == 0 {
                alert.addAction(AlertAction(title: "Cancel", style: .preferred))
            } else if i == 1 {
                alert.addAction(AlertAction(title: "OK", style: .default))
            } else if i == 2 {
                alert.addAction(AlertAction(title: "Delete", style: .destructive))
            } else {
                alert.addAction(AlertAction(title: "Button \(i)", style: .default))
            }
        }

        alert.actionLayout = ActionLayout(rawValue: self.buttonLayoutControl.selectedSegmentIndex)!

        if #available(iOS 9, *) {
            addContentToAlert(alert)
        }
        alert.present()
    }

    @available(iOS 9, *)
    fileprivate func addContentToAlert(_ alert: AlertController) {
        switch self.contentControl.selectedSegmentIndex {
            case 1:
                let contentView = alert.contentView
                let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                spinner.translatesAutoresizingMaskIntoConstraints = false
                spinner.startAnimating()
                contentView.addSubview(spinner)
                spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
                spinner.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                spinner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            case 2:
                let contentView = alert.contentView
                let switchControl = UISwitch()
                switchControl.isOn = true
                switchControl.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(switchControl)
                switchControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
                switchControl.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                switchControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

                alert.message = "Disable switch to prevent alert dismissal"

                alert.shouldDismissHandler = { [unowned switchControl] _ in
                    return switchControl.isOn
                }
            case 3:
                let bar = UIProgressView(progressViewStyle: .default)
                bar.translatesAutoresizingMaskIntoConstraints = false
                alert.contentView.addSubview(bar)
                bar.leadingAnchor.constraint(equalTo: alert.contentView.leadingAnchor,
                    constant: 20).isActive = true
                bar.trailingAnchor.constraint(equalTo: alert.contentView.trailingAnchor,
                    constant: -20).isActive = true
                bar.topAnchor.constraint(equalTo: alert.contentView.topAnchor).isActive = true
                bar.bottomAnchor.constraint(equalTo: alert.contentView.bottomAnchor).isActive = true

                Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:
                    #selector(updateProgressBar), userInfo: bar, repeats: true)
            default: break
        }
    }

    @objc
    fileprivate func updateProgressBar(_ timer: Timer) {
        let bar = timer.userInfo as? UIProgressView
        bar?.progress += 0.005

        if bar?.progress >= 1 {
            timer.invalidate()
        }
    }

    fileprivate func presentUIAlertController() {
        let title = self.titleTextField.content
        let message = self.messageTextField.content
        let style = UIAlertControllerStyle(rawValue: self.styleControl.selectedSegmentIndex)!
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        let textFields = Int(self.textFieldCountTextField.content ?? "0")!
        for _ in 0..<textFields {
            alert.addTextField(configurationHandler: nil)
        }

        let buttons = Int(self.buttonCountTextField.content ?? "0")!
        for i in 0..<buttons {
            if i == 0 {
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            } else if i == 1 {
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            } else if i == 2 {
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: nil))
            } else {
                alert.addAction(UIAlertAction(title: "Button \(i)", style: .default, handler: nil))
            }
        }

        present(alert, animated: true, completion: nil)
    }
}

private extension UITextField {

    var content: String? {
        if let text = self.text , !text.isEmpty {
            return text
        }

        return self.placeholder
    }
}
