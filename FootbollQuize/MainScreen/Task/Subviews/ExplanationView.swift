import UIKit
import SnapKit

class ExplanationView: UIView {
    
    private let leftIndicatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .activeColor
        return v
    }()
    
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
        
        self.clipsToBounds = true
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondTextColor.withAlphaComponent(0.2).cgColor
        
        [leftIndicatorView, iconLabel, titleLabel, descriptionLabel].forEach {
            addSubview($0)
        }
        
        leftIndicatorView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(6)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconLabel)
            make.leading.equalTo(iconLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(15)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(text: String) {
        descriptionLabel.text = text
    }
}
