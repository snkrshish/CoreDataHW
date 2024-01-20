import UIKit
import SnapKit

class MainViewController: UIViewController {
    //MARK: - Outles
    private lazy var textField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(cgColor: CGColor(gray: 0.4, alpha:0.1))
        textField.keyboardType = .default
        textField.placeholder = "Print your name here"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    private lazy var buttonForAdd = {
        let button = UIButton(type: .system)
        button.backgroundColor = .link
        button.setTitle("Press", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var personTableView = {
        let tableView = UITableView()
        return tableView
    }()



    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationController()
        setupHierarchy()
        setupLayout()
    }

    //MARK: - Seetup Navigation
    private func setupNavigationController() {
        title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    //MARK: - Setup
    private func setupHierarchy() {
        view.addSubview(textField)
        view.addSubview(buttonForAdd)
        view.addSubview(personTableView)
    }

    private func setupLayout() {
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.leading.equalTo(view).inset(15)
            $0.height.greaterThanOrEqualTo(50)
        }

        buttonForAdd.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view).inset(15)
            $0.height.greaterThanOrEqualTo(50)
        }

        personTableView.snp.makeConstraints {
            $0.top.equalTo(buttonForAdd.snp.bottom).offset(25)
            $0.leading.trailing.equalTo(view).offset(25)
        }
    }
}

