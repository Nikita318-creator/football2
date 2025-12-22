import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    private let firstCategoryTotal = 25
    private let firstCategoryKey = "QuizCategoryProgress_0"
    private let viewModel = QuizQuestionViewModel()
    
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
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundMain
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainActionCell", for: indexPath) as! MainActionCell
            let solved = UserDefaults.standard.integer(forKey: firstCategoryKey)
            cell.configure(solved: solved, total: firstCategoryTotal)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCell", for: indexPath) as! RecommendationCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let taskVC = TaskVC(categoryIndex: 0)
            taskVC.modalPresentationStyle = .fullScreen
            self.present(taskVC, animated: true)
        } else {
            let errors = viewModel.getIncorrectQuestions()
            if errors.isEmpty {
                let alert = UIAlertController(title: "Great Job!", message: "You don't have any mistakes to analyze yet.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                let taskVC = TaskVC(categoryIndex: -1, isMistakeCorrection: true)
                taskVC.modalPresentationStyle = .fullScreen
                self.present(taskVC, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 40
        return indexPath.item == 0 ? CGSize(width: width, height: 480) : CGSize(width: width, height: 200)
    }
}
