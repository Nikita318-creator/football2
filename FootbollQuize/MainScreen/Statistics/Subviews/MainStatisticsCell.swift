import UIKit
import SnapKit

class MainStatisticsCell: UICollectionViewCell {
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 32
        return v
    }()
    
    private let iconContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.backgroundMain
        v.layer.cornerRadius = 35
        return v
    }()
    
    private let brainIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "brain_icon"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let rankLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 32, weight: .bold)
        l.textColor = .textColor
        l.textAlignment = .center
        return l
    }()
    
    private let nextRankLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .regular)
        l.textColor = .secondTextColor
        l.textAlignment = .center
        return l
    }()
    
    private let questionsBadge: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.backgroundMain.withAlphaComponent(0.6)
        v.layer.cornerRadius = 12
        return v
    }()
    
    private let questionsLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.textColor = .textColor
        return l
    }()
    
    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.backgroundMain
        return v
    }()
    
    private let progressTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Current progress"
        l.font = .systemFont(ofSize: 16, weight: .regular)
        l.textColor = .secondTextColor
        return l
    }()
    
    private let percentageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textColor = .textColor
        return l
    }()
    
    private let progressBar: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.backgroundMain
        v.layer.cornerRadius = 4
        return v
    }()
    
    private let progressFill: UIView = {
        let v = UIView()
        v.backgroundColor = .primary
        v.layer.cornerRadius = 4
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        [iconContainer, rankLabel, nextRankLabel, questionsBadge, separator,
         progressTitleLabel, percentageLabel, progressBar].forEach { containerView.addSubview($0) }
        
        iconContainer.addSubview(brainIcon)
        questionsBadge.addSubview(questionsLabel)
        progressBar.addSubview(progressFill)
        
        iconContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        brainIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.top.equalTo(iconContainer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        nextRankLabel.snp.makeConstraints { make in
            make.top.equalTo(rankLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        questionsBadge.snp.makeConstraints { make in
            make.top.equalTo(nextRankLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(34)
        }
        
        questionsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(questionsBadge.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        progressTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
        }
        
        percentageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(progressTitleLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(progressTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(8)
            make.bottom.equalToSuperview().inset(24)
        }
        
        progressFill.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
    }
    
    func configure(with model: GeneralStats) {
        rankLabel.text = model.rank
        nextRankLabel.text = "To level \"\(model.nextRank)\""
        questionsLabel.text = "\(model.questionsCount) questions"
        percentageLabel.text = "\(model.progress)%"
        
        let multiplier = CGFloat(model.progress) / 100.0
        progressFill.snp.remakeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(multiplier)
        }
    }
}
