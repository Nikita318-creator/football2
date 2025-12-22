import UIKit
import SnapKit

class StatisticsVC: UIViewController {
    
    // MARK: - Data Properties
    private var generalData: GeneralStats?
    private var strongThemes: [Topic] = []
    private var weakThemes: [Topic] = []
    
    private let totalQuestionsLimit = 145
    private let categoryTitles = [
        "Football Logic", "Laws of the Game", "Tactical History", "Set Pieces", "Management"
    ]
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Statistics"
        l.font = .systemFont(ofSize: 34, weight: .bold)
        l.textColor = .textColor
        return l
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(MainStatisticsCell.self, forCellWithReuseIdentifier: "MainCell")
        cv.register(TopicStatCell.self, forCellWithReuseIdentifier: "TopicCell")
        cv.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .backgroundMain
        calculateStatistics()
        collectionView.reloadData()
    }
    
    // MARK: - Logic
    private func calculateStatistics() {
        var totalSolved = 0
        var categoryStats: [(title: String, percent: Int)] = []
        
        let limits = [25, 30, 30, 30, 30]
        
        for i in 0..<5 {
            let solved = UserDefaults.standard.integer(forKey: "QuizCategoryProgress_\(i)")
            totalSolved += solved
            
            let percent = Int((Double(solved) / Double(limits[i])) * 100)
            if solved > 0 {
                categoryStats.append((title: categoryTitles[i], percent: percent))
            }
        }
        
        // 1. General Stats & Ranks
        let ranks = ["Novice", "Analyst", "Pro", "Expert", "Trainer"]
        let step = totalQuestionsLimit / ranks.count // ~29 вопросов на ранг
        
        let rankIndex = min(totalSolved / step, ranks.count - 1)
        let currentRank = ranks[rankIndex]
        let nextRank = rankIndex < ranks.count - 1 ? ranks[rankIndex + 1] : "Max Level"
        
        let remainingForNext = (rankIndex + 1) * step - totalSolved
        let displayRemaining = remainingForNext > 0 ? remainingForNext : 0
        
        let totalProgress = Int((Double(totalSolved) / Double(totalQuestionsLimit)) * 100)
        
        self.generalData = GeneralStats(
            rank: currentRank,
            nextRank: nextRank,
            questionsCount: displayRemaining,
            progress: totalProgress
        )
        
        // 2. Strong & Weak Themes
        // Сортируем: сначала самые высокие проценты
        let sortedStats = categoryStats.sorted { $0.percent > $1.percent }
        
        // Сильные (топ 2)
        self.strongThemes = sortedStats.prefix(2).map {
            Topic(title: $0.title, subtitle: "High accuracy", percentage: $0.percent)
        }
        
        // Слабые (1 самый худший, но где есть хотя бы одна попытка и процент < 100)
        if sortedStats.count > 1, let last = sortedStats.last, last.percent < 100 {
            self.weakThemes = [Topic(title: last.title, subtitle: "Needs practice", percentage: last.percent)]
        } else {
            self.weakThemes = []
        }
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 20, bottom: 24, trailing: 20)
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 12
                section.contentInsets = .init(top: 12, leading: 20, bottom: 24, trailing: 20)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                // Скрываем хедер, если в секции нет данных
                let hasData = (sectionIndex == 1 && !self.strongThemes.isEmpty) || (sectionIndex == 2 && !self.weakThemes.isEmpty)
                section.boundarySupplementaryItems = hasData ? [header] : []
                
                return section
            }
        }
    }
}

extension StatisticsVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return generalData != nil ? 1 : 0 }
        if section == 1 { return strongThemes.count }
        if section == 2 { return weakThemes.count }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainStatisticsCell
            if let data = generalData {
                cell.configure(with: data)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicStatCell
            let theme = indexPath.section == 1 ? strongThemes[indexPath.row] : weakThemes[indexPath.row]
            cell.configure(with: theme, isStrongSection: indexPath.section == 1)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! SectionHeaderView
        if indexPath.section == 1 {
            header.configure(title: "Strong themes", iconName: "chart_up")
        } else if indexPath.section == 2 {
            header.configure(title: "Weak themes", iconName: "chart_down")
        }
        return header
    }
}
