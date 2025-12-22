import UIKit
import SnapKit

class TotalProgressCell: UICollectionViewCell {
    
    private let container: UIView = {
        let v = UIView()
        v.backgroundColor = .white.withAlphaComponent(0.6)
        v.layer.cornerRadius = 24
        return v
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Total progress"
        l.textColor = .secondTextColor
        l.font = .systemFont(ofSize: 16, weight: .medium)
        return l
    }()
    
    private let trophyIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "trophy")
        iv.tintColor = .primary
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let scoreLabel: UILabel = {
        let l = UILabel()
        l.textColor = .textColor
        l.font = .systemFont(ofSize: 14, weight: .bold)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        contentView.addSubview(container)
        container.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let stack = UIStackView(arrangedSubviews: [trophyIcon, scoreLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        
        container.addSubview(titleLabel)
        container.addSubview(stack)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        trophyIcon.snp.makeConstraints { $0.size.equalTo(24) }
    }
    
    func configure(current: Int, total: Int) {
        scoreLabel.text = "\(current) / \(total)"
    }
}
