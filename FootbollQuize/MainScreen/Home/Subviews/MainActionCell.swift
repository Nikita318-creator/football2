import UIKit
import SnapKit

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
        iv.backgroundColor = .secondTextColor
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Football\nLogic"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 38, weight: .bold)
        label.textColor = .textColor
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let statsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundMain.withAlphaComponent(0.5)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let progressLabelLeft = createLabel(text: "Progress", color: .secondTextColor, size: 14)
    private let progressValueRight = MainActionCell.createLabel(text: "0 / 25", color: .textColor, size: 16, weight: .bold)
    
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
    private let questionValueRight = MainActionCell.createLabel(text: "№ 1", color: .textColor, size: 16, weight: .bold)

    private let continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.backgroundColor = .primary
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.layer.cornerRadius = 20
        btn.isUserInteractionEnabled = false
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
            make.height.equalTo(220)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        statsContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(statsContainer.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(20)
        }
        
        setupStatsLayout()
    }
    
    private func setupStatsLayout() {
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
            make.width.equalToSuperview().multipliedBy(0.48)
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
    
    func configure(solved: Int, total: Int) {
        progressValueRight.text = "\(solved) / \(total)"
        
        let currentQuestion = solved < total ? solved + 1 : total
        questionValueRight.text = "№ \(currentQuestion)"
        
        let ratio = total > 0 ? CGFloat(solved) / CGFloat(total) : 0
        progressFill.snp.remakeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(ratio)
        }
        
        continueButton.setTitle(solved >= total ? "Restart" : "Continue", for: .normal)
    }
}
