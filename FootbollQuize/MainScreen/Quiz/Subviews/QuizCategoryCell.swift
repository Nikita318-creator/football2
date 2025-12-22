import UIKit
import SnapKit

class QuizCategoryCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.masksToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondTextColor
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .textColor
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondTextColor
        return label
    }()
    
    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = .backgroundMain.withAlphaComponent(0.5)
        return v
    }()
    
    private let progressInfoLabel: UILabel = {
        let l = UILabel()
        l.textColor = .secondTextColor
        l.font = .systemFont(ofSize: 14)
        return l
    }()
    
    private let percentageLabel: UILabel = {
        let l = UILabel()
        l.textColor = .primary
        l.font = .systemFont(ofSize: 16, weight: .bold)
        return l
    }()
    
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundMain
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let progressFill: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        view.layer.cornerRadius = 4
        return view
    }()
    
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
        
        [imageView, titleLabel, subtitleLabel, separator,
         progressInfoLabel, percentageLabel, progressBar, continueButton].forEach {
            containerView.addSubview($0)
        }
        
        progressBar.addSubview(progressFill)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        
        progressInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
        }
        
        percentageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(progressInfoLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(progressInfoLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(8)
        }
        
        progressFill.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(with model: QuizCategory) {
        imageView.image = UIImage(named: model.image)
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        progressInfoLabel.text = "\(model.solvedQuestions) / \(model.totalQuestions) questions"
        
        let percent = model.totalQuestions > 0 ? (Double(model.solvedQuestions) / Double(model.totalQuestions)) : 0
        percentageLabel.text = "\(Int(percent * 100))%"
        
        progressFill.snp.remakeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(percent)
        }
    }
}
