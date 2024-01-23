import UIKit
import SnapKit

class MainViewController: UIViewController {

    var mainPresenter: MainPresenter?

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
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var personTableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()



    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        setupNavigationController()
        setupHierarchy()
        setupLayout()
    }

    

    //MARK: - Setup Navigation
    private func setupNavigationController() {
        title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        let backButton = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorImage = backButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButton
        navigationController?.navigationBar.backItem?.title = ""

        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButton.tintColor = .systemBlue
        navigationItem.backBarButtonItem = backBarButton
    }

    //MARK: - Setup

    private func setupView() {
        mainPresenter?.fetchAllUsers()
        hideKeyboardWhenTappedAround()
        setupNavigationController()
    }

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
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(view)
        }
    }

    //MARL: - Action
    @objc func buttonTapped() {
        if textField.text != "" {
            mainPresenter?.saveName(name: textField.text ?? "")
            mainPresenter?.fetchAllUsers()
        } else {
            let alert = UIAlertController(title: "Nothing was written",
                                          message: "Please enter your name",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
        self.textField.text = ""
        self.personTableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func setPresenter(_ presenter: MainPresenter) {
        self.mainPresenter = presenter
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPresenter?.users.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = mainPresenter?.users[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let user = mainPresenter?.users[indexPath.row] {
            mainPresenter?.coordinator?.moveToDetail(withData: user)
        } else {
            print("Невозможно выполнить операцию moveToDetail")
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            mainPresenter?.deleteUser(indexPath: indexPath)
            mainPresenter?.users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }

    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

