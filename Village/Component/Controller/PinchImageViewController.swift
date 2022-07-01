import UIKit
import RxSwift

class PinchImageViewController: BaseViewController {
    
    //MARK: - UI Properties
    
    private let scrollVIew = UIScrollView()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_delete").withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: - Lifecycles
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
   
    //MARK: - Configures
    
    private func configure() {
        scrollVIew.delegate = self
        scrollVIew.zoomScale = 1.0
        scrollVIew.minimumZoomScale = 1.0
        scrollVIew.maximumZoomScale = 6.0
    }
    
    override func configureUI() {
        view.backgroundColor = .black
        
        view.addSubview(scrollVIew)
        scrollVIew.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollVIew.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(scrollVIew.contentLayoutGuide)
            make.width.height.equalTo(scrollVIew.frameLayoutGuide)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
    }
    
    override func setUpBindins() {
        closeButton.rx.tap
            .bind { [weak self] in
                self?.removeFromParent()
                self?.dismiss(animated: false, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}

extension PinchImageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= 1.0 {
            scrollView.zoomScale = 1.0
        }
        
        if scrollView.zoomScale >= scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.maximumZoomScale
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
