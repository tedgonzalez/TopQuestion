//
//  ViewController.swift
//  TopQuestion
//
//  Created by Matteo Manferdini on 25/05/2017.
//  Copyright © 2017 Pure Creek. All rights reserved.
//

import UIKit

class TopQuestionViewController: UIViewController {
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var ownerNameLabel: UILabel!
	@IBOutlet weak var ownerAvatarImageView: UIImageView!
	@IBOutlet weak var ownerReputationLabel: UILabel!
	@IBOutlet weak var askedLabel: UILabel!
	@IBOutlet weak var tagsLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var questionView: UIView!
	fileprivate var request: AnyObject?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		ownerAvatarImageView.layer.borderColor = UIColor.amethystSmoke.cgColor
		ownerAvatarImageView.layer.borderWidth = 1.0
		fetchQuestion()
	}
}

private extension TopQuestionViewController {
	func configureUI(with question: Question) {
		questionView.isHidden = false
		scoreLabel.text = question.score.thousandsFormatting
		titleLabel.text = question.title
		set(tags: question.tags)
		ownerNameLabel.text = question.owner?.name
		ownerReputationLabel.text = question.owner?.reputation?.thousandsFormatting ?? nil
	}
	
	func set(tags: [String]) {
		guard tags.count > 0 else {
			tagsLabel.text = nil
			return
		}
		tagsLabel.text = tags[0]
			+ tags.dropFirst().reduce("") { $0 + ", " + $1 }
	}
	
	func fetchQuestion() {
		let questionsResource = QuestionsResource()
		let questionsRequest = ApiRequest(resource: questionsResource)
		request = questionsRequest
		questionsRequest.load { [weak self] (questions: [Question]?) in
			self?.activityIndicator.stopAnimating()
			guard let questions = questions,
				let topQuestion = questions.first else {
					return
			}
			self?.configureUI(with: topQuestion)
			if let owner = topQuestion.owner {
				self?.fetchAvatar(for: owner)
			}
		}
	}
	
	func fetchAvatar(for user: User) {
		guard let avatarURL = user.profileImageURL else {
			return
		}
		let avatarRequest = ImageRequest(url: avatarURL)
		self.request = avatarRequest
		avatarRequest.load(withCompletion: { [weak self] (avatar: UIImage?) in
			guard let avatar = avatar else {
				return
			}
			self?.ownerAvatarImageView.image = avatar
		})
	}
}

extension Int {
	var thousandsFormatting: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter.string(from: NSNumber(value: self))!
	}
}

extension Date {
	var timeAgo: String {
		let calendar = Calendar.current
		let units: Set<Calendar.Component> = [.month, .year]
		let components = calendar.dateComponents(units, from: self, to: Date())
		let year = components.year!
		let month = components.month!
		return "\(year) "
			+ (year > 1 ? "years" : "year")
			+ ", \(month) "
			+ (month > 1 ? "months" : "month")
			+ " ago"
	}
}
