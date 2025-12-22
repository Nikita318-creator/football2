import UIKit
import SnapKit

class QuizVC: UIViewController {
    
    // Делаем массив вычисляемым, чтобы он всегда брал актуальные данные из памяти
    private var categories: [QuizCategory] {
        let titles = [
            "Football Logic", "Laws of the Game", "Tactical History", "Set Pieces", "Management"
        ]
        let subtitles = [
            "Non-obvious decisions and match situations",
            "Refereeing nuances, VAR, and foul play",
            "The evolution of the game since the 1950s",
            "Corners, free kicks, and penalty shootouts",
            "Transfers and football club operations"
        ]
        let backgrounds = ["quiz1_bg", "quiz2_bg", "quiz3_bg", "quiz4_bg", "quiz5_bg"]
        
        // Массив лимитов, которые мы задали во ViewModel (25 для первой, 30 для остальных)
        let limits = [25, 30, 30, 30, 30]
        
        return (0..<5).map { index in
            // Читаем прогресс по тому же ключу, что и в TaskVC
            let solved = UserDefaults.standard.integer(forKey: "QuizCategoryProgress_\(index)")
            
            return QuizCategory(
                image: backgrounds[index],
                title: titles[index],
                subtitle: subtitles[index],
                solvedQuestions: solved,
                totalQuestions: limits[index]
            )
        }
    }
    
    // Общий прогресс: сумма всех solvedQuestions
    private var totalSolved: Int {
        return (0..<5).reduce(0) { sum, index in
            sum + UserDefaults.standard.integer(forKey: "QuizCategoryProgress_\(index)")
        }
    }
    
    private let totalPossibleQuestions = 145 // 25 + 30 + 30 + 30 + 30
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .backgroundMain
        collectionView.reloadData()
    }
    
    private func setupUI() {
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
        return 1 + 5 // Progress cell + 5 categories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TotalProgressCell", for: indexPath) as! TotalProgressCell
            // Используем реальную сумму и константу 145
            cell.configure(current: totalSolved, total: totalPossibleQuestions)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCategoryCell", for: indexPath) as! QuizCategoryCell
            // Берем категорию из вычисляемого массива
            let category = categories[indexPath.item - 1]
            cell.configure(with: category)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 40
        return indexPath.item == 0 ? CGSize(width: width, height: 56) : CGSize(width: width, height: 360)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item > 0 {
            let selectedCategoryIndex = indexPath.item - 1
            let taskVC = TaskVC(categoryIndex: selectedCategoryIndex)
            taskVC.modalPresentationStyle = .fullScreen
            self.present(taskVC, animated: true)
        }
    }
}
