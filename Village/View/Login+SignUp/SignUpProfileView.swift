import UIKit

class SignUpProfileView: BaseView {
    
    //MARK: - UI Properties
    
    let loadingView = LoadingView()
    
    private let selectGenderLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 17, weight: .bold)
        label.text = "👫 성별을 선택해주세요!️"
        return label
    }()
    
    let maleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .grey100
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        button.setTitle("남자", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        return button
    }()
    
    let femaleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .grey100
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        button.setTitle("여자", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        return button
    }()
    
    let noneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .grey100
        button.titleLabel?.font = .suitFont(size: 15, weight: .regular)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("선택안함", for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        return button
    }()
    
    private let selectDateLabel: UILabel = {
        let label = UILabel()
        label.font = .suitFont(size: 17, weight: .bold)
        label.text = "🎂 생년월일은 작성해주세요!️"
        return label
    }()
    
    private let dateHelperLabel: UILabel = {
        let label = UILabel()
        label.text = "입력하신 정보를 기반으로 게시글을 추천해드려요."
        label.textColor = .grey300
        label.font = .suitFont(size: 10, weight: .regular)
        return label
    }()
    
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
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 48))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexible, selectDateBarButton], animated: false)
        return toolBar
    }()
    
    let selectDateBarButton = UIBarButtonItem(title: "선택하기", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    
    lazy var selectDateTextField = SelectTextField(placeholder: "YYYY-MM-DD",
                                                   inputView: datePicker,
                                                   inputAccessoryView: toolBar)
    
    let completeButton: EnableButton = {
        let button = EnableButton()
        button.setTitle("완료", for: .normal)
        return button
    }()
    
    //MARK: - Configures
    
    override func configureUI() {
        backgroundColor = .white
        
        let buttonStackView = UIStackView(arrangedSubviews: [maleButton, femaleButton, noneButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        
        buttonStackView.arrangedSubviews.forEach { button in
            button.layer.cornerRadius = 40 / 2
            button.snp.makeConstraints { make in
                make.width.equalTo(71)
                make.height.equalTo(40)
            }
        }
        
        addSubview(selectDateLabel)
        selectDateLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(dateHelperLabel)
        dateHelperLabel.snp.makeConstraints { make in
            make.top.equalTo(selectDateLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(36)
        }
        
        addSubview(selectDateTextField)
        selectDateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateHelperLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        addSubview(selectGenderLabel)
        selectGenderLabel.snp.makeConstraints { make in
            make.top.equalTo(selectDateTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(selectGenderLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
    
        addSubview(completeButton)
        completeButton.layer.cornerRadius = 24
        completeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(82)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
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
    
    func selectDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        selectDateTextField.resignFirstResponder()
        selectDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    func agreeTermsOfUse(agree: Bool) {
        print(agree)
    }
    
    private func selectGenderButton(button: UIButton, selected: Bool) {
        button.backgroundColor = selected ? .villageSky : .grey100
        button.setTitleColor(selected ? .white : .grey300, for: .normal)
    }
}
