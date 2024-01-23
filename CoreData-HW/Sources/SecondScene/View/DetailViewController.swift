import UIKit

class DetailViewController: UIViewController {

    var detailPresenter: DetailPresenter?
    
    private var avatar: Data? = nil
    private var inEditMode = Bool()
    private let genderArray = ["Male", "Female", "Other"]

    //MARK: - Outles

    let dataPicker = UIDatePicker()
    let genderPicker = UIPickerView()

    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if let data = detailPresenter?.user?.avatar, let image = UIImage(data: data) {
            imageView.image = image
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        return imageView
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

        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(openGalleryButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        let image = UIImage(systemName: "preson.circle")

        textField.text = detailPresenter?.user?.name
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
        textField.text = detailPresenter?.user?.dateOfBirth.map { date.string(from: $0) } ?? ""
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

        textField.text = detailPresenter?.user?.gender
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
        setupView()
        setupHierarchy()
        setupLayout()
    }



    //MARK: - Setup
    private func setupView() {
        hideKeyboardWhenTappedAround()
        setBirthDatePicker()
        setGenderPicker()
        saveData()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let buttonEdit = UIBarButtonItem(customView: editButton)
        navigationItem.rightBarButtonItem = buttonEdit
    }

    private func setupHierarchy() {
        let views = [editButton, avatarImage, changePhotoButton, nameTextField, birthdayTextField, genderTextField]
        views.forEach { view.addSubview($0) }
    }
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func setupLayout() {
        editButton.snp.makeConstraints {
            $0.top.equalTo(view).offset(60)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.width.equalTo(70)
            $0.height.equalTo(30)
        }

        avatarImage.snp.makeConstraints {
            $0.top.equalTo(view).offset(80)
            $0.centerX.equalTo(view)
            $0.width.height.equalTo(180)
        }

        changePhotoButton.snp.makeConstraints {
            $0.top.equalTo(avatarImage.snp.bottom).offset(20)
            $0.centerX.equalTo(view)
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(changePhotoButton.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.height.equalTo(50)
        }

        birthdayTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.height.equalTo(50)
        }

        genderTextField.snp.makeConstraints {
            $0.top.equalTo(birthdayTextField.snp.bottom).offset(30)
            $0.centerX.equalTo(view)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.height.equalTo(50)
        }
    }

    private func setBirthDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        birthdayTextField.inputView = dataPicker
        birthdayTextField.inputAccessoryView = toolBar

        dataPicker.datePickerMode = .date
        dataPicker.preferredDatePickerStyle = .wheels

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([flexSpace, doneButton], animated: true)

        let minimumBirthDate = Calendar.current.date(byAdding: .year, value: -73, to: Date())
        let maximumBirthDate = Calendar.current.date(byAdding: .year, value: -8, to: Date())
        dataPicker.minimumDate = minimumBirthDate
        dataPicker.maximumDate = maximumBirthDate
    }

    private func setGenderPicker() {
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTextField.inputView = genderPicker
    }

    private func saveData() {
        if let user = detailPresenter?.user {
            let date = DateFormatter()
            date.dateFormat = "dd.MM.yy"

            let birthDate = date.date(from: birthdayTextField.text ?? "")

            detailPresenter?.updateUser(user: user,
                                        avatar: avatar,
                                        name: nameTextField.text ?? " ",
                                        birthDate: birthDate ?? Date(),
                                        gender: genderTextField.text ?? "")
        }
    }

    //MARk: - Actions
    @objc
    func editButtonTapped() {
        inEditMode.toggle()
        let newTitle = inEditMode ? "Save" : "Edit"
        let buttonStyle: (isEnabled: Bool, borderStyle: UITextField.BorderStyle) = inEditMode ?
        (true, .roundedRect) : (false, .roundedRect)

        editButton.setAttributedTitle(NSAttributedString(string: newTitle, attributes: [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 16)
        ]), for: .normal)

        changePhotoButton.isHidden = !inEditMode

        nameTextField.isUserInteractionEnabled = buttonStyle.isEnabled
        nameTextField.borderStyle = buttonStyle.borderStyle

        birthdayTextField.isUserInteractionEnabled = buttonStyle.isEnabled
        birthdayTextField.borderStyle = buttonStyle.borderStyle

        genderTextField.isUserInteractionEnabled = buttonStyle.isEnabled
        genderTextField.borderStyle = buttonStyle.borderStyle

        saveData()
    }

    @objc
    func openGalleryButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    @objc
    func doneAction() {
        getDateFromPicker()
        view.endEditing(true)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

    private func getDateFromPicker() {
        let date = DateFormatter()
        date.dateFormat = "dd.MM.yy"
        birthdayTextField.text = date.string(from: dataPicker.date)
    }
}
extension DetailViewController {
    func setPresenter(presenter: DetailPresenter){
        self.detailPresenter = presenter
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        avatarImage.contentMode = .scaleAspectFit
        avatarImage.image = image
        avatar = image?.pngData()
        dismiss(animated: true)
    }
}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genderArray[row]
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editButtonTapped()
        return true
    }
}
