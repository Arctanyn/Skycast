//
//  MessageViewWithAction.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 21.12.2022.
//

import UIKit

final class MessageViewWithAction: BaseView {
    
    //MARK: - Views
    
    private lazy var mainVStack = UIStackView(
        axis: .vertical,
        spacing: 20,
        alignment: .center,
        arrangedSubviews: [labelsVStack, actionButton]
    )
    
    private lazy var labelsVStack = UIStackView(
        axis: .vertical,
        spacing: 10,
        alignment: .center,
        arrangedSubviews: [messageTitleLabel, messageDescriptionLabel]
    )
        
    private lazy var messageTitleLabel = UILabel(
        font: Resources.Fonts.system(size: 25, weight: .bold),
        textAlignment: .center,
        numberOfLines: 2
    )
    
    private lazy var messageDescriptionLabel = UILabel(
        textColor: .secondaryLabel, font: Resources.Fonts.system(),
        textAlignment: .center,
        numberOfLines: 5
    )
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Resources.Fonts.system(weight: .medium)
        return button
    }()
    
    //MARK: - Methods
    
    override func setupViews() {
        addSubview(mainVStack, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setupMessage(withTitle messageTitle: String, messageDescription: String, actionButtonText: String) {
        messageTitleLabel.text = messageTitle
        messageDescriptionLabel.text = messageDescription
        actionButton.setTitle(actionButtonText, for: .normal)
    }
    
    func addTargetToButton(_ target: Any?, action: Selector, forEvent event: UIControl.Event) {
        actionButton.addTarget(target, action: action, for: event)
    }
}
