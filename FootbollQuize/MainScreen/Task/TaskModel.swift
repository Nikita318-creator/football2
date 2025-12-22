import Foundation

// MARK: - Model
struct QuizQuestion: Codable {
    let id: String
    let topic: String
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

// MARK: - ViewModel
class QuizQuestionViewModel {
    
    private let incorrectKey = "LastIncorrectQuestions"
    private(set) var allQuestions: [QuizQuestion] = []
    
    init() {
        setupMockData()
    }
    
    func getQuestions(for categoryIndex: Int) -> [QuizQuestion] {
        guard allQuestions.count >= 60 else { return [] }
        
        switch categoryIndex {
        case 0:
            return Array(allQuestions.prefix(25))
        case 1:
            return Array(allQuestions[0..<30]).reversed()
        case 2:
            return Array(allQuestions[15..<45])
        case 3:
            return Array(allQuestions[30..<60]).reversed()
        case 4:
            let last20 = allQuestions.suffix(20)
            let first10 = allQuestions.prefix(10)
            return Array(last20 + first10)
        default:
            return Array(allQuestions.prefix(25))
        }
    }
    
    func getIncorrectQuestions() -> [QuizQuestion] {
        guard let data = UserDefaults.standard.data(forKey: incorrectKey) else { return [] }
        do {
            return try JSONDecoder().decode([QuizQuestion].self, from: data)
        } catch {
            print("Error decoding incorrect questions: \(error)")
            return []
        }
    }
    
    func saveIncorrectQuestion(_ question: QuizQuestion) {
        var currentErrors = getIncorrectQuestions()
        
        currentErrors.removeAll { $0.id == question.id }
        currentErrors.insert(question, at: 0)        
        let limitedErrors = Array(currentErrors.prefix(5))
        
        do {
            let data = try JSONEncoder().encode(limitedErrors)
            UserDefaults.standard.set(data, forKey: incorrectKey)
        } catch {
            print("Error encoding incorrect questions: \(error)")
        }
    }
    
    private func setupMockData() {
        let rawData: [[String: Any]] = [
            ["id": "q1", "question": "The team leads 1:0, 90+4 minute. What is most profitable?", "answers": ["Attack with large forces", "Control the ball at the corner flag", "Try to score a second goal with a long shot", "Give the ball to the opponent"], "correctIndex": 1, "explanation": "Keeps ball far from your goal and wastes time."],
            ["id": "q2", "question": "You are a defender. An opponent is running one-on-one but far from the goal. Your task?", "answers": ["Foul immediately", "Try to force them to the flank", "Run back without pressure", "Go for a slide tackle from behind"], "correctIndex": 1, "explanation": "Reduces the angle of attack and slows them down."],
            ["id": "q3", "question": "The team is losing 0:1, 2 minutes left. Where is the best place to find a chance?", "answers": ["Through short passes in the center", "Through crosses into the penalty area", "Through ball control near your own goal", "Through shots from your own half"], "correctIndex": 1, "explanation": "The fastest way to deliver the ball to the danger zone."],
            ["id": "q4", "question": "A midfielder received the ball with his back to the goal under pressure. Best decision?", "answers": ["Turn around at any cost", "Keep the ball and pass back", "Shoot from an uncomfortable position", "Dribble between two players"], "correctIndex": 1, "explanation": "Maintains possession when an easy turn is impossible."],
            ["id": "q5", "question": "You are carrying the ball down the flank, teammates are in the penalty area. What increases the chance of a goal?", "answers": ["Blind cross", "Low cross", "Turn back to the defenders", "Stop the ball"], "correctIndex": 1, "explanation": "Harder for defenders to clear and creates chaos."],
            ["id": "q6", "question": "The goalkeeper sees the opponent pressing. What is safer?", "answers": ["Short pass to the center", "Long clearance", "Attempt to dribble", "Hold the ball"], "correctIndex": 1, "explanation": "Eliminates risk of a fatal mistake near the goal."],
            ["id": "q7", "question": "The team is playing with fewer players. What is most important?", "answers": ["Ball control at any cost", "Compactness and discipline", "Constant attacks", "High defensive line"], "correctIndex": 1, "explanation": "Prevents the opponent from using their numerical advantage."],
            ["id": "q8", "question": "You received a yellow card. How to change your game?", "answers": ["Play tougher", "Play more carefully in tackles", "Go for slide tackles more often", "Ignore duels"], "correctIndex": 1, "explanation": "Reduces the risk of being sent off with a second yellow."],
            ["id": "q9", "question": "During a set piece at your own goal, it is best to:", "answers": ["Leave one defender", "Clearly mark the players", "Keep a high line", "Focus only on the ball"], "correctIndex": 1, "explanation": "Prevents opponents from getting free shots on goal."],
            ["id": "q10", "question": "The striker is not receiving the ball. What should he do?", "answers": ["Stand in the center of the box", "Drop deeper and help the buildup", "Wait for a long pass", "Stop moving"], "correctIndex": 1, "explanation": "Creates new passing lanes and confuses defenders."],
            ["id": "q11", "question": "Score 0:0, start of the match. Most reasonable strategy?", "answers": ["Maximum risk", "Calm control and finding rhythm", "Constant shots", "Deep defense"], "correctIndex": 1, "explanation": "Allows the team to adapt and find their game."],
            ["id": "q12", "question": "You are tired in the second half. What is better for the team?", "answers": ["Continue sprinting", "Play simpler and more reliably", "Go for dribbling more often", "Ignore defense"], "correctIndex": 1, "explanation": "Avoids critical errors caused by fatigue."],
            ["id": "q13", "question": "The team wins in possession but not in score. What does this mean?", "answers": ["The game is going perfectly", "Sharpness in attack is needed", "More back passes are needed", "The tempo should be lowered"], "correctIndex": 1, "explanation": "Possession must be converted into scoring chances."],
            ["id": "q14", "question": "In a counterattack, the main thing is:", "answers": ["Slow buildup", "Quick decision making", "Stopping the ball", "Transverse passes"], "correctIndex": 1, "explanation": "Speed is the key factor to catch the defense off guard."],
            ["id": "q15", "question": "A defender went forward. What is important to remember?", "answers": ["Ignore the position", "Return after the attack", "Stay in attack", "Wait for the pass while standing"], "correctIndex": 1, "explanation": "Restores defensive balance to prevent counterattacks."],
            ["id": "q16", "question": "You are the captain. The team is nervous. Best action?", "answers": ["Criticize the players", "Support and calm them down", "Raise your voice", "Ignore the situation"], "correctIndex": 1, "explanation": "Keeps the team focused and prevents panic."],
            ["id": "q17", "question": "Under opponent pressure, it's better to:", "answers": ["Complicate the game", "Play simpler", "Keep the ball near the goal", "Ignore the pressing"], "correctIndex": 1, "explanation": "Minimizes the chance of losing the ball in dangerous areas."],
            ["id": "q18", "question": "Free kick far from the goal. What is more effective?", "answers": ["Direct shot", "Short play (buildup)", "Strong clearance", "Refusal to cross"], "correctIndex": 1, "explanation": "Creates a better angle or more organized attack."],
            ["id": "q19", "question": "In defense, the most important thing is:", "answers": ["Speed", "Positioning", "Beautiful slide tackles", "Individual play"], "correctIndex": 1, "explanation": "A well-positioned defender prevents chances before they happen."],
            ["id": "q20", "question": "You are without the ball. How to be useful?", "answers": ["Stand still", "Open up space", "Watch the ball", "Wait for the pass"], "correctIndex": 1, "explanation": "Movement creates options for the player with the ball."],
            ["id": "q21", "question": "The team plays at home. What does this give?", "answers": ["Automatic victory", "Support and confidence", "Extra rules", "More substitutions"], "correctIndex": 1, "explanation": "The crowd's energy often boosts player morale."],
            ["id": "q22", "question": "After a teammate's mistake, it's better to:", "answers": ["Reproach him", "Support him", "Ignore it", "Play alone"], "correctIndex": 1, "explanation": "Maintains team spirit and collective focus."],
            ["id": "q23", "question": "Passing under pressure. The main thing:", "answers": ["Power", "Accuracy", "Risk", "Flashiness"], "correctIndex": 1, "explanation": "Accuracy ensures the ball reaches its target safely."],
            ["id": "q24", "question": "When should you slow down the game?", "answers": ["When losing", "When leading in score", "When you need to score", "At the beginning of the match"], "correctIndex": 1, "explanation": "Helps manage time and exhaust the opponent."],
            ["id": "q25", "question": "The team is tired. What helps?", "answers": ["Panic", "Tempo control", "Disordered attacks", "Frequent shots"], "correctIndex": 1, "explanation": "Conserves energy and prevents chaotic errors."],
            ["id": "q26", "question": "In the opponent's penalty area, it's important to:", "answers": ["Take many touches", "Make a quick decision", "Stop the ball", "Individual feints"], "correctIndex": 1, "explanation": "Gives the goalkeeper and defenders less time to react."],
            ["id": "q27", "question": "If the opponent is taller:", "answers": ["Play with crosses", "Play low balls", "Foul constantly", "Give up on attacks"], "correctIndex": 1, "explanation": "Negates their height advantage and uses agility."],
            ["id": "q28", "question": "When is it better to shoot at the goal?", "answers": ["From any position", "When there is space", "Always with the first touch", "Only from the center of the field"], "correctIndex": 1, "explanation": "Clear vision of the goal significantly improves accuracy."],
            ["id": "q29", "question": "If the game is not going well:", "answers": ["Lose your temper", "Focus on the simple things", "Play more riskily", "Stop moving"], "correctIndex": 1, "explanation": "Success in simple actions helps regain confidence."],
            ["id": "q30", "question": "The best quality of a midfielder:", "answers": ["Shot power", "Vision", "Height", "Toughness"], "correctIndex": 1, "explanation": "Allows finding teammates and controlling the game flow."],
            ["id": "q31", "question": "In the final minutes of the match, what's more important?", "answers": ["Emotions", "Concentration", "Risk", "Individual actions"], "correctIndex": 1, "explanation": "Mistakes at the end are hardest to correct."],
            ["id": "q32", "question": "When does the team press?", "answers": ["Everyone on their own", "All synchronously", "Only strikers", "Only defenders"], "correctIndex": 1, "explanation": "Synchronized pressure leaves no free space for the opponent."],
            ["id": "q33", "question": "If the opponent plays deep:", "answers": ["Hurry up", "Look for width", "Shoot from distance constantly", "Reduce tempo to zero"], "correctIndex": 1, "explanation": "Stretches the defense and creates gaps in the center."],
            ["id": "q34", "question": "When exiting defense, it's better to:", "answers": ["Long clearance", "Calm buildup", "Stop the game", "Pass to the goalkeeper"], "correctIndex": 1, "explanation": "Allows the team to maintain control and start an attack."],
            ["id": "q35", "question": "A good team is distinguished by:", "answers": ["Stars", "Interaction", "Physics", "Aggression"], "correctIndex": 1, "explanation": "Strong teamwork is more effective than individual skills."],
            ["id": "q36", "question": "Before the match, it's important to:", "answers": ["Get yourself worked up", "Set a calm mood", "Think about the result", "Ignore the plan"], "correctIndex": 1, "explanation": "Calmness helps in making better tactical decisions."],
            ["id": "q37", "question": "If a teammate is open:", "answers": ["Ignore", "Give a pass", "Try to dribble", "Stop the ball"], "correctIndex": 1, "explanation": "The ball moves faster than any player."],
            ["id": "q38", "question": "What's more important in defense?", "answers": ["Slide tackles", "Positional play", "Fouls", "Shot speed"], "correctIndex": 1, "explanation": "Good positioning reduces the need for risky tackles."],
            ["id": "q39", "question": "The team conceded a goal. First action?", "answers": ["Panic", "Gather yourselves", "Risk immediately", "Blame the goalkeeper"], "correctIndex": 1, "explanation": "Emotional stability is crucial to getting back into the game."],
            ["id": "q40", "question": "A back pass is:", "answers": ["A mistake", "Part of control", "Loss of initiative", "A sign of weakness"], "correctIndex": 1, "explanation": "Helps reset the attack and find a better opening."],
            ["id": "q41", "question": "When should you speed up the game?", "answers": ["When leading", "When there is space", "When tired", "Always"], "correctIndex": 1, "explanation": "Exploits gaps in the opponent's formation."],
            ["id": "q42", "question": "A good pass is:", "answers": ["Strong", "Comfortable for the teammate", "Flashy", "Risky"], "correctIndex": 1, "explanation": "Allows the receiver to make their next move immediately."],
            ["id": "q43", "question": "The team is attacking. What's important for defenders?", "answers": ["Go forward", "Maintain balance", "Stay at the opponent's goal", "Don't return"], "correctIndex": 1, "explanation": "Prevents being caught by a quick counterattack."],
            ["id": "q44", "question": "It's better to give a pass:", "answers": ["Into feet under pressure", "Into free space", "Into a struggle", "To the goalkeeper"], "correctIndex": 1, "explanation": "Gives the teammate time and space to operate."],
            ["id": "q45", "question": "A feint is justified when:", "answers": ["Always", "There is an advantage", "There are no teammates", "You want it to be flashy"], "correctIndex": 1, "explanation": "Should be used only when it creates a real advantage."],
            ["id": "q46", "question": "A good captain:", "answers": ["Screams", "Leads by example", "Only attacks", "Doesn't communicate"], "correctIndex": 1, "explanation": "Actions and attitude inspire the rest of the team."],
            ["id": "q47", "question": "During an attacking set piece, it's important to have:", "answers": ["Chaos", "A clear plan", "Improvisation without agreement", "Standing still"], "correctIndex": 1, "explanation": "Organization leads to more effective execution."],
            ["id": "q48", "question": "When is it better to keep the ball?", "answers": ["When losing", "When leading", "At the beginning of an attack", "After a shot"], "correctIndex": 1, "explanation": "Reduces the opponent's time to score."],
            ["id": "q49", "question": "Team play is:", "answers": ["Individual actions", "Common decisions", "Only attack", "Only defense"], "correctIndex": 1, "explanation": "Success depends on shared goals and coordination."],
            ["id": "q50", "question": "If unsure of a decision:", "answers": ["Risk it", "Play simpler", "Delay the ball", "Ignore teammates"], "correctIndex": 1, "explanation": "Simple play minimizes dangerous turnovers."],
            ["id": "q51", "question": "The best moment for a shot:", "answers": ["When there are many defenders", "When there is balance and vision", "Always immediately after receiving", "From any position"], "correctIndex": 1, "explanation": "Improves the likelihood of hitting the target accurately."],
            ["id": "q52", "question": "If the opponent made a mistake:", "answers": ["Stop", "Use the moment", "Return the ball", "Wait"], "correctIndex": 1, "explanation": "Exploiting errors is a key part of scoring strategy."],
            ["id": "q53", "question": "A heel pass is justified:", "answers": ["Always", "When there is confidence", "When there are no other options", "For beauty"], "correctIndex": 1, "explanation": "Should be used only when it’s the most effective option."],
            ["id": "q54", "question": "A good position is:", "answers": ["Closer to the ball", "Where you are useful to the team", "Where it's comfortable to stand", "Where there's less running"], "correctIndex": 1, "explanation": "Optimizes your impact on the game's outcome."],
            ["id": "q55", "question": "In attack, it's important to have:", "answers": ["Many touches", "Tempo and movement", "Standing still", "Waiting for a foul"], "correctIndex": 1, "explanation": "Keeps the defense under constant pressure."],
            ["id": "q56", "question": "When is it better to take a pause?", "answers": ["During a counterattack", "To assess the situation", "Always", "Never"], "correctIndex": 1, "explanation": "Briefly reassessing can lead to a much better pass."],
            ["id": "q57", "question": "A player without the ball should:", "answers": ["Wait", "Move and open up", "Stand still", "Watch the game"], "correctIndex": 1, "explanation": "Active movement creates passing options for others."],
            ["id": "q58", "question": "When a team is confident:", "answers": ["Chaos appears", "The game becomes simpler", "Everyone takes risks", "Discipline disappears"], "correctIndex": 1, "explanation": "Confidence allows for smoother and more direct execution."],
            ["id": "q59", "question": "Best decision under pressure:", "answers": ["Feint", "Pass", "Shot", "Stopping"], "correctIndex": 1, "explanation": "Moving the ball is the fastest way to relieve pressure."],
            ["id": "q60", "question": "Football is primarily:", "answers": ["Speed", "Decision making", "Physics", "Shot power"], "correctIndex": 1, "explanation": "Thinking fast is as important as running fast."]
        ]
        
        self.allQuestions = rawData.compactMap { dict in
            guard let id = dict["id"] as? String,
                  let questionText = dict["question"] as? String,
                  let answers = dict["answers"] as? [String],
                  let correctIndex = dict["correctIndex"] as? Int,
                  let explanation = dict["explanation"] as? String else { return nil }
            
            return QuizQuestion(
                id: id,
                topic: "Football Logic",
                question: questionText,
                options: answers,
                correctIndex: correctIndex,
                explanation: explanation
            )
        }
    }
}
