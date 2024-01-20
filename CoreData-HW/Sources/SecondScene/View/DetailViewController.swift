import UIKit

class DetailViewController: UIViewController {
    //MARK: - Outles
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = image.frame.height / 2
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.5
        button.layer.masksToBounds = true

        let buttonTitle = "Edit"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        let attributedTitle = NSAttributedString(string: buttonTitle, attributes: attributes)

        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor

//        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var changePhototButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isHidden = true
        return button
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        let image = UIImage(systemName: "preson.circle")

        textField.leftViewMode = UITextField.ViewMode.always
        imageView.image = image
        textField.leftView = imageView
        textField.borderStyle = .roundedRect
        textField.tintColor = .systemBlue
        textField.backgroundColor = UIColor(cgColor: CGColor(gray: 0.4, alpha:0.1))
        textField.isUserInteractionEnabled = false
        return textField
    }()

    private lazy var birthdayTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        let image = UIImage(systemName: "birthday.cake")
        let date = DateFormatter()
        date.dateFormat = "dd.MM.yy"

        textField.leftViewMode = UITextField.ViewMode.always
        imageView.image = image
        textField.leftView = imageView
        textField.borderStyle = .roundedRect
        textField.tintColor = .systemBlue
        textField.backgroundColor = UIColor(cgColor: CGColor(gray: 0.4, alpha:0.1))
        textField.isUserInteractionEnabled = false
        return textField
    }()

    private lazy var genderTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        let image = UIImage(systemName: "figure.dress.line.vertical.figure")

        textField.leftViewMode = UITextField.ViewMode.always
        imageView.image = image
        textField.leftView = imageView
        textField.borderStyle = .roundedRect
        textField.tintColor = .systemBlue
        textField.backgroundColor = UIColor(cgColor: CGColor(gray: 0.4, alpha:0.1))
        textField.isUserInteractionEnabled = false

        return textField
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupLayout()
    }



    //MARK: - Setup
    private func setupHierarchy() {
        let views = [editButton, avatarImage, changePhototButton, nameTextField, birthdayTextField, genderTextField]
        views.forEach { view.addSubview($0) }
    }

    private func setupLayout() {
        editButton.snp.makeConstraints {
            $0.top.equalTo(view).offset(60)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.width.equalTo(70)
            $0.height.equalTo(30)
        }

        avatarImage.snp.makeConstraints {
            $0.top.equalTo(view).offset(150)
            $0.centerX.equalTo(view)
            $0.width.height.equalTo(180)
        }

        changePhototButton.snp.makeConstraints {
            $0.top.equalTo(avatarImage).offset(20)
            $0.centerX.equalTo(view)
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(changePhototButton).offset(30)
            $0.centerX.equalTo(view)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.height.equalTo(60)
        }

        birthdayTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField).offset(30)
            $0.centerX.equalTo(view)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.height.equalTo(60)
        }

        genderTextField.snp.makeConstraints {
            $0.top.equalTo(birthdayTextField).offset(30)
            $0.centerX.equalTo(view)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.height.equalTo(60)
        }
    }
}
