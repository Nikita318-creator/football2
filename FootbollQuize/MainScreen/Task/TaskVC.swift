import UIKit
import SnapKit

class TaskVC: UIViewController {
    
    private var questions: [QuizQuestion] = []
    private var currentIndex: Int = 0
    private var selectedAnswerIndex: Int?
    private var isShowingResult = false
    private var viewModel = QuizQuestionViewModel()
    
    private let categoryIndex: Int
    private let isMistakeCorrection: Bool
    
    private var progressKey: String {
        return "QuizCategoryProgress_\(categoryIndex)"
    }
    
    // MARK: - UI Elements
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "backImg"), for: .normal)
        btn.layer.cornerRadius = 22
        return btn
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white.withAlphaComponent(0.5)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .textColor
        return label
    }()
    
    private let topicLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondTextColor
        label.textAlignment = .left
        return label
    }()
    
    private let resultIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0
        return iv
    }()
    
    private let resultStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .textColor
        label.alpha = 0
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .textColor
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView = UIView()
    
    private let optionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private var optionViews: [AnswerOptionView] = []
    private let explanationView = ExplanationView()
    
    private let actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .activeColor
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.layer.cornerRadius = 20
        btn.setTitle("Answer", for: .normal)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    init(categoryIndex: Int, isMistakeCorrection: Bool = false) {
        self.categoryIndex = categoryIndex
        self.isMistakeCorrection = isMistakeCorrection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestions()
        loadProgress()
        setupUI()
        loadQuestion()
    }
    
    private func setupQuestions() {
        if isMistakeCorrection {
            self.questions = viewModel.getIncorrectQuestions()
        } else {
            self.questions = viewModel.getQuestions(for: categoryIndex)
        }
    }
    
    // MARK: - Progress Logic
    
    private func loadProgress() {
        if isMistakeCorrection {
            self.currentIndex = 0
            return
        }
        
        let savedIndex = UserDefaults.standard.integer(forKey: progressKey)
        if savedIndex >= questions.count {
            self.currentIndex = 0
            saveProgress(index: 0)
        } else {
            self.currentIndex = savedIndex
        }
    }
    
    private func saveProgress(index: Int) {
        guard !isMistakeCorrection else { return }
        UserDefaults.standard.set(index, forKey: progressKey)
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundMain
        
        [backButton, progressLabel, topicLabel, questionLabel, resultIcon, resultStatusLabel, scrollView, actionButton, explanationView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        contentView.addSubview(optionsStackView)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(44)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(160)
            make.height.equalTo(32)
        }
        
        topicLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(topicLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        resultIcon.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(60)
        }
        
        resultStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(resultIcon.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        
        explanationView.snp.makeConstraints { make in
            make.bottom.equalTo(actionButton.snp.top).offset(-15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(actionButton.snp.top).offset(-10)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        optionsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func loadQuestion() {
        guard currentIndex < questions.count else {
            dismiss(animated: true)
            return
        }
        let q = questions[currentIndex]
        
        isShowingResult = false
        selectedAnswerIndex = nil
        
        questionLabel.font = .systemFont(ofSize: 28, weight: .bold)
        questionLabel.textAlignment = .left
        topicLabel.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.topicLabel.alpha = 1
            self.resultIcon.alpha = 0
            self.resultStatusLabel.alpha = 0
            
            self.questionLabel.snp.remakeConstraints { make in
                make.top.equalTo(self.topicLabel.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            self.scrollView.snp.remakeConstraints { make in
                make.top.equalTo(self.questionLabel.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.actionButton.snp.top).offset(-10)
            }
        }
        
        topicLabel.text = isMistakeCorrection ? "Mistake Correction" : q.topic
        
        let fullText = "Question \(currentIndex + 1) / \(questions.count)"
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: "\(currentIndex + 1)") {
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .bold), range: NSRange(range, in: fullText))
        }
        progressLabel.attributedText = attributedString
        
        questionLabel.text = q.question
        actionButton.setTitle("Answer", for: .normal)
        
        explanationView.alpha = 0
        explanationView.isHidden = true
        
        optionViews.forEach { $0.removeFromSuperview() }
        optionViews.removeAll()
        
        for (index, text) in q.options.enumerated() {
            let optionView = AnswerOptionView(letter: String(UnicodeScalar(65 + index)!), text: text)
            optionView.tag = index
            let tap = UITapGestureRecognizer(target: self, action: #selector(optionTapped(_:)))
            optionView.addGestureRecognizer(tap)
            optionsStackView.addArrangedSubview(optionView)
            optionViews.append(optionView)
        }
        
        scrollView.setContentOffset(.zero, animated: false)
    }
    
    private func showResult(selected: Int) {
        isShowingResult = true
        let q = questions[currentIndex]
        let isCorrect = selected == q.correctIndex
        
        questionLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        questionLabel.textAlignment = .center
        topicLabel.isHidden = true

        UIView.animate(withDuration: 0.3) {
            self.topicLabel.alpha = 0
            self.resultIcon.alpha = 1
            self.resultStatusLabel.alpha = 1
            
            self.questionLabel.snp.remakeConstraints { make in
                make.top.equalTo(self.resultStatusLabel.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            self.scrollView.snp.remakeConstraints { make in
                make.top.equalTo(self.questionLabel.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.actionButton.snp.top).offset(-10)
            }
        }
        
        if isCorrect {
            resultIcon.image = UIImage(named: "success")
            resultStatusLabel.text = "Correct"
            actionButton.setTitle("Next Question", for: .normal)
            explanationView.configure(text: q.explanation)
            explanationView.isHidden = false
            UIView.animate(withDuration: 0.3) { self.explanationView.alpha = 1 }
        } else {
            resultIcon.image = UIImage(named: "error")
            resultStatusLabel.text = "Incorrect"
            actionButton.setTitle("Repeat", for: .normal)
            explanationView.isHidden = true
            
            if !isMistakeCorrection {
                viewModel.saveIncorrectQuestion(q)
            }
        }
        
        for (index, view) in optionViews.enumerated() {
            if isCorrect {
                view.setState(index == q.correctIndex ? .correct : .idle)
            } else {
                view.setState(index == selected ? .wrong : .idle)
            }
        }
        
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func optionTapped(_ gesture: UITapGestureRecognizer) {
        guard !isShowingResult, let view = gesture.view as? AnswerOptionView else { return }
        selectedAnswerIndex = view.tag
        optionViews.forEach { $0.setState($0.tag == selectedAnswerIndex ? .selected : .idle) }
    }
    
    @objc private func actionButtonTapped() {
        if isShowingResult {
            let q = questions[currentIndex]
            if selectedAnswerIndex == q.correctIndex {
                currentIndex += 1
                saveProgress(index: currentIndex)
                
                if currentIndex < questions.count {
                    loadQuestion()
                } else {
                    dismiss(animated: true)
                }
            } else {
                loadQuestion()
            }
            return
        }
        
        guard let selected = selectedAnswerIndex else { return }
        showResult(selected: selected)
    }
}
