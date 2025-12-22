import UIKit
import SnapKit

class QuizVC: UIViewController {
    
    private let categories: [QuizCategory] = [
        QuizCategory(image: "quiz1_bg", title: "Football Logic", subtitle: "Non-obvious decisions and match situations", solvedQuestions: 12, totalQuestions: 25),
        QuizCategory(image: "quiz2_bg", title: "Laws of the Game", subtitle: "Refereeing nuances, VAR, and foul play", solvedQuestions: 5, totalQuestions: 30),
        QuizCategory(image: "quiz3_bg", title: "Tactical History", subtitle: "The evolution of the game since the 1950s", solvedQuestions: 18, totalQuestions: 30),
        QuizCategory(image: "quiz4_bg", title: "Set Pieces", subtitle: "Corners, free kicks, and penalty shootouts", solvedQuestions: 0, totalQuestions: 30),
        QuizCategory(image: "quiz5_bg", title: "Management", subtitle: "Transfers and football club operations", solvedQuestions: 0, totalQuestions: 30)
    ]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Quiz"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .textColor
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(TotalProgressCell.self, forCellWithReuseIdentifier: "TotalProgressCell")
        cv.register(QuizCategoryCell.self, forCellWithReuseIdentifier: "QuizCategoryCell")
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 30, right: 20)
        return cv
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
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

// MARK: - CollectionView Extensions
extension QuizVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TotalProgressCell", for: indexPath) as! TotalProgressCell
            cell.configure(current: 45, total: 150)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCategoryCell", for: indexPath) as! QuizCategoryCell
            cell.configure(with: categories[indexPath.item - 1])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 40
        return indexPath.item == 0 ? CGSize(width: width, height: 56) : CGSize(width: width, height: 360)
    }
}
