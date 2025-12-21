import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .backgroundMain
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(MainActionCell.self, forCellWithReuseIdentifier: "MainActionCell")
        cv.register(RecommendationCell.self, forCellWithReuseIdentifier: "RecommendationCell")
        return cv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .textColor
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundMain
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - CollectionView Extensions
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainActionCell", for: indexPath) as! MainActionCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCell", for: indexPath) as! RecommendationCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 40
        return indexPath.item == 0 ? CGSize(width: width, height: 460) : CGSize(width: width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell at \(indexPath.item) tapped. Logic will be here later.")
    }
}

// MARK: - MainActionCell
class MainActionCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "soccer_bg")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .secondTextColor // Заглушка
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Football\nLogic"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 38, weight: .bold)
        label.textColor = .textColor
        return label
    }()
    
    private let statsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundMain.withAlphaComponent(0.5)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let progressLabelLeft = createLabel(text: "Progress", color: .secondTextColor, size: 14)
    private let progressValueRight = createLabel(text: "12 / 25", color: .textColor, size: 16, weight: .bold)
    
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let progressFill: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let questionLabelLeft = createLabel(text: "Current question", color: .secondTextColor, size: 14)
    private let questionValueRight = createLabel(text: "№ 12", color: .textColor, size: 16, weight: .bold)
    
    private let continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.backgroundColor = .primary
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupCell() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(statsContainer)
        containerView.addSubview(continueButton)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(260)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(60)
            make.leading.equalToSuperview().offset(24)
        }
        
        statsContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(statsContainer.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        // Stats inner layout
        let hStack1 = UIStackView(arrangedSubviews: [progressLabelLeft, progressValueRight])
        hStack1.distribution = .equalSpacing
        
        let hStack2 = UIStackView(arrangedSubviews: [questionLabelLeft, questionValueRight])
        hStack2.distribution = .equalSpacing
        
        statsContainer.addSubview(hStack1)
        statsContainer.addSubview(progressBar)
        progressBar.addSubview(progressFill)
        statsContainer.addSubview(hStack2)
        
        hStack1.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(15)
        }
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(hStack1.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(8)
        }
        
        progressFill.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.48) // 12/25
        }
        
        hStack2.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    private static func createLabel(text: String, color: UIColor, size: CGFloat, weight: UIFont.Weight = .regular) -> UILabel {
        let l = UILabel()
        l.text = text
        l.textColor = color
        l.font = .systemFont(ofSize: size, weight: weight)
        return l
    }
}

// MARK: - RecommendationCell
class RecommendationCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let recLabel = createLabel(text: "Recommended today", color: .primary, size: 14)
    private let titleLabel = createLabel(text: "Mistake correction", color: .textColor, size: 22, weight: .bold)
    private let subLabel = createLabel(text: "Analyze 5 difficult moments\nfrom past games", color: .secondTextColor, size: 16)
    
    private let actionButton: UIView = {
        let v = UIView()
        v.backgroundColor = .backgroundMain.withAlphaComponent(0.6)
        v.layer.cornerRadius = 15
        return v
    }()
    
    private let btnLabel = createLabel(text: "Start 5 questions", color: .textColor, size: 16)
    private let chevron: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = .secondTextColor
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupCell() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        subLabel.numberOfLines = 2
        
        let stack = UIStackView(arrangedSubviews: [recLabel, titleLabel, subLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        containerView.addSubview(stack)
        containerView.addSubview(actionButton)
        actionButton.addSubview(btnLabel)
        actionButton.addSubview(chevron)
        
        stack.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        actionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        btnLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        chevron.snp.makeConstraints { make in
            make.leading.equalTo(btnLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(14)
        }
    }
    
    private static func createLabel(text: String, color: UIColor, size: CGFloat, weight: UIFont.Weight = .regular) -> UILabel {
        let l = UILabel()
        l.text = text
        l.textColor = color
        l.font = .systemFont(ofSize: size, weight: weight)
        return l
    }
}
