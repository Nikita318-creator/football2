import UIKit
import SnapKit

class RecommendationCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let recLabel = createLabel(text: "Recommended today", color: .activeColor, size: 14)
    private let titleLabel = createLabel(text: "Mistake correction", color: .textColor, size: 22, weight: .bold)
    private let subLabel = createLabel(text: "Analyze 5 difficult moments\nfrom past games", color: .secondTextColor, size: 16)
    
    private let actionButton: UIView = {
        let v = UIView()
        v.backgroundColor = .backgroundMain.withAlphaComponent(0.6)
        v.layer.cornerRadius = 15
        v.isUserInteractionEnabled = false
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
        stack.spacing = 6
        stack.alignment = .leading
        
        containerView.addSubview(stack)
        containerView.addSubview(actionButton)
        actionButton.addSubview(btnLabel)
        actionButton.addSubview(chevron)
        
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        actionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(44)
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
