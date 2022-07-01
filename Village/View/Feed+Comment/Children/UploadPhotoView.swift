import UIKit

final class UploadPhotoView: UploadFeedContentView {
    
    //MARK: - UI Properties
    
    var selectedImage: UIImage? {
        didSet {
            if let selectedImage = selectedImage {
                contentImageView.image = selectedImage
                contentImageView.isHidden = false
            } else {
                contentImageView.image = nil
                contentImageView.isHidden = true
            }
        }
    }
   
    let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .grey100
        return imageView
    }()
    
    //MARK: - Lifecycles
  
 
    //MARK: - Configures
    
    override func configureUI() {
        super.configureUI()
        contentImageView.isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [contentImageView, divider])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(206)
        }
        
        divider.snp.remakeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    func showImageView(show: Bool, image: UIImage? = nil) {
        contentImageView.isHidden = !show
        contentImageView.image = image
        isActivated = show
    }
}
