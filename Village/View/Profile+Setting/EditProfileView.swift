import UIKit
import MaterialComponents

class EditProfileView: BaseView {
    
    //MARK: - Properties
    
    private(set) var user: User
    
    var selectedDate: Date {
        return datePicker.date
    }
    
    var selectedDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: datePicker.date)
    }
    
    var isEditable: Bool = false {
        didSet { editButton.isEnabled = isEditable }
    }
    
    //MARK: - UI Properties

    let editButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("완료", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = user.mbti.characterImage
        return imageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = user.nickname
        label.font = .suitFont(size: 20, weight: .bold)
        return label
    }()
    
    private let providerLabel: UILabel = {
        let label = UILabel()
        label.text = "프로바이더"
        label.textColor = .grey300
        label.font = .suitFont(size: 13, weight: .regular)
        return label
    }()
    
    private lazy var emialLabel: UILabel = {
        let label = UILabel()
        label.text = user.email
        label.textColor = .grey300
        label.font = .suitFont(size: 13, weight: .regular)
        return label
    }()
    
    private let editNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "👉 닉네임"
        label.font = .suitFont(size: 15, weight: .regular)
        return label
    }()
    
    lazy var editNicknameTextField =  EditTextField(placeholder: user.nickname)
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .regular)
        label.text = "🎂 생년월일"
        return label
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 48))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexible, selectDateBarButton], animated: false)
        return toolBar
    }()
    
    let selectDateBarButton = UIBarButtonItem(title: "선택하기", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    
    lazy var selectDateTextField = SelectTextField(placeholder: user.birthDateString,
                                                   inputView: datePicker,
                                                   inputAccessoryView: toolBar)
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.setValue(UIColor.white, forKey: "backgroundColor")
    
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return picker
    }()
    
    private let editMBTILabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .regular)
        label.text = "👉 MBTI"
        return label
    }()
    
    lazy var editMBTISelectTextField = SelectTextField(placeholder: user.mbti.title,
                                                               inputView: UIView(),
                                                               inputAccessoryView: nil)

    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 15, weight: .regular)
        label.text = "👫 성별"
        return label
    }()
    
    let maleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .villageSky
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        button.setTitle("남자", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let femaleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .grey100
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        button.setTitle("여자", for: .normal)
        button.setTitleColor(.grey400, for: .normal)
        return button
    }()
    
    let noneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .grey100
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("선택안함", for: .normal)
        button.setTitleColor(.grey400, for: .normal)
        return button
    }()

    //MARK: - Lifecycles
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Confogures
    
    override func configureUI() {
        backgroundColor = .white
        providerLabel.text = KeyChainManager.loadSocialProvider()?.title ?? ""
        
        let buttonStackView = UIStackView(arrangedSubviews: [maleButton, femaleButton, noneButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        
        buttonStackView.arrangedSubviews.forEach { button in
            button.layer.cornerRadius = 20
            button.snp.makeConstraints { make in
                make.width.equalTo(71)
                make.height.equalTo(40)
            }
        }
      
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        addSubview(providerLabel)
        providerLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        addSubview(emialLabel)
        emialLabel.snp.makeConstraints { make in
            make.top.equalTo(providerLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        let provider = UIView()
        provider.backgroundColor = .grey100
        
        addSubview(provider)
        provider.snp.makeConstraints { make in
            make.top.equalTo(emialLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        addSubview(editNicknameLabel)
        editNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(provider.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(editNicknameTextField)
        editNicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(editNicknameLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        addSubview(editMBTILabel)
        editMBTILabel.snp.makeConstraints { make in
            make.top.equalTo(editNicknameTextField.snp.bottom).offset(16)
            make.leading.equalTo(editNicknameLabel.snp.leading)
        }
        
        addSubview(editMBTISelectTextField)
        editMBTISelectTextField.snp.makeConstraints { make in
            make.top.equalTo(editMBTILabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(editMBTISelectTextField.snp.bottom).offset(16)
            make.leading.equalTo(editNicknameLabel.snp.leading)
        }
        
        addSubview(selectDateTextField)
        selectDateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(selectDateTextField.snp.bottom).offset(16)
            make.leading.equalTo(editNicknameLabel.snp.leading)
        }
        
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(11)
            make.leading.equalToSuperview().inset(24)
        }
        
        addSubview(editButton)
        editButton.layer.cornerRadius = 48 / 2
        editButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.lessThanOrEqualTo(94)
        }
    }
    
    //MARK: - Helpers
    
    func bindNickname(nickname: String) {
        user.nickname = nickname
        nicknameLabel.text = nickname
        editNicknameTextField.text = nickname
    }
    
    func bindMBTI(mbti: MBTIType) {
        user.mbti = mbti
        profileImageView.image = mbti.characterImage
        editMBTISelectTextField.text = mbti.title
    }
    
    func editDate() {
        selectDateTextField.resignFirstResponder()
        selectDateTextField.text = selectedDateString
    }
    
    func selectGender(gender: Gender) {
        switch gender {
        case .male:
            selectGenderButton(button: maleButton, selected: true)
            selectGenderButton(button: femaleButton, selected: false)
            selectGenderButton(button: noneButton, selected: false)
            
        case .female:
            selectGenderButton(button: maleButton, selected: false)
            selectGenderButton(button: femaleButton, selected: true)
            selectGenderButton(button: noneButton, selected: false)
            
        case .none:
            selectGenderButton(button: maleButton, selected: false)
            selectGenderButton(button: femaleButton, selected: false)
            selectGenderButton(button: noneButton, selected: true)
        }
    }
    
    private func selectGenderButton(button: UIButton, selected: Bool) {
        button.backgroundColor = selected ? .villageSky : .grey100
        button.setTitleColor(selected ? .white : .grey300, for: .normal)
    }
}
