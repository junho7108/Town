import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MoveVillageViewController: BaseViewController {
    
    var coordinator: MoveVillageCoordinator?
    
    let viewModel: MoveVillageViewModel
    
    private(set) var dataSource: RxCollectionViewSectionedReloadDataSource<VillageSection>!
    
    //MARK: - UI Properties
    
    private lazy var selfView = MoveVillageView(frame: .zero, collectionViewLayout: collectionLayout)
    
    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width / 2) - 20, height: 219)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        
        layout.headerReferenceSize = .init(width: view.frame.width, height: 128 + 16 + 16)
        layout.sectionInset = .init(top: 0, left: 16, bottom: 16, right: 16)
        return layout
    }()
    
    //MARK: - Lifecycles
    
    init(viewModel: MoveVillageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Configures
    
    override func configureUI() {
        hidesBottomBarWhenPushed = true
        
        view.addSubview(selfView)
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setUpBindins() {
        

        //MARK: INPUT
        
        let fetchUser = rx.viewWillAppear.map { _ in }.asObservable()
        let tapAllVilalge = PublishRelay<Void>()
        let tapVillage = PublishRelay<MBTIType>()
        
        let output = viewModel.transform(input: .init(fetchUser: fetchUser,
                                                      tapAllVilalge: tapAllVilalge.asObservable(),
                                                      tapVillage: tapVillage.asObservable()))
        
        //MARK: Binds
        
        selfView.rx.modelSelected(MBTIType.self)
            .bind(to: tapVillage)
            .disposed(by: disposeBag)
        
        //MARK: OUTPUT
        
        output.activating
            .map { !$0}
            .bind(to: selfView.loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.user
            .share()
            .bind { [unowned self] user in
                dataSource = RxCollectionViewSectionedReloadDataSource<VillageSection>.init(configureCell: { [unowned self]
                    dataSource, collectionView, indexPath, item in
                    
                    let cell = selfView.dequeueReusableCell(withReuseIdentifier: VillageCell.identifier, for: indexPath) as! VillageCell
                    
                    cell.configureUI(userMBTI: user.mbti, villageMBTI: item)
                    
                    cell.followButton.rx.tap
                        .bind { _ in
                            Logger.printLog("\((cell.villageMBTI.title)) 팔로우")
                        }
                        .disposed(by: cell.disposeBag)
                    return cell
                }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: MoveVillageHeaderView.identifer,
                                                                                 for: indexPath) as! MoveVillageHeaderView
                    header.rx.tapGesture(configuration: nil)
                        .when(.recognized)
                        .map { _ in }
                        .bind(to: tapAllVilalge)
                        .disposed(by: header.disposeBag)
                    return header
                })
                
                output.villageSection
                    .bind(to: selfView.rx.items(dataSource: dataSource))
                    .disposed(by: disposeBag)
            }
            .disposed(by: disposeBag)
        
      
        
        output.showAllVilalge
            .bind { _ in
                Logger.printLog("마을 전체보기")
            }
            .disposed(by: disposeBag)
    
        output.showVillage
            .bind { mbti in
                Logger.printLog("\(mbti.title)마을로 이동")
            }
            .disposed(by: disposeBag)
    }
}
