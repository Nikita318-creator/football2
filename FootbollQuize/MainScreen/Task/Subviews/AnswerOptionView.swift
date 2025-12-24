import UIKit
import SnapKit

class AnswerOptionView: UIView {
    
    enum State {
        case idle, selected, correct, wrong
    }
    
    private let letterLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.textAlignment = .center
        l.layer.cornerRadius = 12
        l.clipsToBounds = true
        return l
    }()
    
    private let textLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .regular)
        l.textColor = .textColor
        l.numberOfLines = 0
        return l
    }()
    
    init(letter: String, text: String) {
        super.init(frame: .zero)
        letterLabel.text = letter
        textLabel.text = text
        setupView()
        setState(.idle)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.borderWidth = 2
        
        addSubview(letterLabel)
        addSubview(textLabel)
        
        letterLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(letterLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setState(_ state: State) {
        switch state {
        case .idle:
            layer.borderColor = UIColor.white.cgColor
            letterLabel.backgroundColor = .backgroundMain
            letterLabel.textColor = .secondTextColor
            alpha = 1.0
        case .selected:
            layer.borderColor = UIColor.activeColor.cgColor
            letterLabel.backgroundColor = .activeColor
            letterLabel.textColor = .white
            alpha = 1.0
        case .correct:
            layer.borderColor = UIColor.success.cgColor
            letterLabel.backgroundColor = .success
            letterLabel.textColor = .white
            alpha = 1.0
        case .wrong:
            layer.borderColor = UIColor.error.cgColor
            letterLabel.backgroundColor = .error
            letterLabel.textColor = .white
            alpha = 1.0
        }
    }
}
