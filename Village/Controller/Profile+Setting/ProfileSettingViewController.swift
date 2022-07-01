import UIKit
import RxSwift
import RxCocoa

class ProfileSettingViewController: BaseViewController {
    
    //MARK: - Properties
    
    var coordinator: ProfileSettingCoordinator?
    
    let viewModel: ProfileViewModel
    
    //MARK: - UI Properteis
    
    let selfView = ProfileSettingView()
    
    //MARK: - Lifecycle
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selfView.tableView.contentOffset = .zero
    }
    
    //MARK: - Configures
    
    override func configureUI() {
        view.backgroundColor = .white
      
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configureNavigationController() {
        let label = UILabel()
        label.text = " 설정"
        label.font = .suitFont(size: 17, weight: .bold)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }
    
    func configureBackButtonItem(title: String = "") {
        super.configureNavigationController()
        backBarButtonItem.title = title
    }
    
    override func setUpBindins() {
        
        // Delegate Bindings
        
        selfView.tableView.rx
            .setDataSource(self)
            .disposed(by: disposeBag)
        
        // INPUT
        
        let tapSettingOption = PublishRelay<VillageSettingOption>()
        
        let fetchingUser = rx.viewWillAppear.map { _ in }
        
        let tapLogout: PublishRelay<Void> = PublishRelay<Void>()
        
        selfView.tableView.rx.itemSelected
            .bind { [weak self] indexpath in
                guard let cell = self?.selfView.tableView.cellForRow(at: indexpath) as? ProfileSettingCell,
                      let option = cell.settingOption else { return }
                
                tapSettingOption.accept(option)
            }
            .disposed(by: disposeBag)
        
        
        // OUTPUT
        
        let output = viewModel.transform(input: .init(fetchingUser: fetchingUser.asObservable(),
                                                      tapSettingOption: tapSettingOption.asObservable(),
                                                      tapEditProfile: selfView.headerView.editProfileButton.rx.tap.asObservable(),
                                                      tapLogout: tapLogout.asObservable()))
        
        output.user
            .bind { [weak self] user in
                self?.selfView.headerView.bindUser(user: user)
            }
            .disposed(by: disposeBag)
        
        output.showSelectedOptionPage
            .bind { [weak self] option in
                print(option)
                switch option {
                    
                case .myFeed:
                    self?.configureBackButtonItem(title: option.title)
                    self?.coordinator?.pushFeedScene(showType: .showMyFeeds)
                    
                case .likedFeed:
                    self?.configureBackButtonItem(title: option.title)
                    self?.coordinator?.pushFeedScene(showType: .showLikeFeeds)
                    
                case .hiddenFeed:
                    self?.configureBackButtonItem(title: option.title)
                    self?.coordinator?.pushFeedScene(showType: .showHiddenFeeds)
                    
                case .savedFeed:
                    self?.configureBackButtonItem(title: option.title)
                    self?.coordinator?.pushFeedScene(showType: .showSaveFeeds)
                    
                case .withdrawal:
                    self?.configureBackButtonItem(title: "👋 회원 탈퇴")
                    self?.coordinator?.pushWithdrawalScene()
                    
//                case .appVersion:
//                    self?.configureBackButtonItem(title: "🤖 버전정보")
//                    self?.coordinator?.pushAppSettingScene()
                    
                case .TOS:
                    if let url = URL(string: VillageServiceURL.TOS) {
                        UIApplication.shared.open(url)
                    }
                    
                case .privacyPoliccy:
                    if let url = URL(string: VillageServiceURL.privacyPolicy) {
                        UIApplication.shared.open(url)
                    }
                    
                case .logout:
                    let logOutPopup = BasePopupViewController(title: "알림", content: "정말 로그아웃 하실건가요? 🛏")
                    logOutPopup.show(parent: self, completion: nil)
                    logOutPopup.okButton.rx.tap
                        .bind(to: tapLogout)
                        .disposed(by: logOutPopup.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        output.showEditProfilePage
            .withLatestFrom(output.user)
            .bind { [weak self] user in
                self?.configureBackButtonItem(title: "프로필 편집")
                self?.coordinator?.pushEditProfileScene(user: user)
            }
            .disposed(by: disposeBag)
        
        output.showLogoutPage
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.coordinator?.logout()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDataSource

extension ProfileSettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return VillageSettingOption.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VillageSettingOption.sections[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSettingCell.identifier,
                                                 for: indexPath) as! ProfileSettingCell
        
        guard let option = VillageSettingOption.allCases.filter({ $0.indexPath == indexPath }).first else { fatalError() }
        cell.configureUI(option: option)
        return cell
    }
}
