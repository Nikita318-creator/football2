import UIKit
import SnapKit

class ExplanationView: UIView {
    
    private let iconLabel: UILabel = {
        let l = UILabel()
        l.text = "!"
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        l.backgroundColor = .activeColor
        l.layer.cornerRadius = 12
        l.clipsToBounds = true
        return l
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Explanation"
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.textColor = .textColor
        return l
    }()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textColor = .secondTextColor
        l.numberOfLines = 0
        return l
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.activeColor.withAlphaComponent(0.3).cgColor
        
        addSubview(iconLabel)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        iconLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconLabel)
            make.leading.equalTo(iconLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(15)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
    func configure(text: String) {
        descriptionLabel.text = text
    }
}
