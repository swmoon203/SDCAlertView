import UIKit

final class ActionCell: UICollectionViewCell {

    @IBOutlet fileprivate(set) var titleLabel: UILabel!
    @IBOutlet fileprivate var highlightedBackgroundView: UIView!

    fileprivate var textColor: UIColor?
    
    var enabled = true {
        didSet { self.titleLabel.isEnabled = self.enabled }
    }

    override var isHighlighted: Bool {
        didSet { self.highlightedBackgroundView.isHidden = !self.isHighlighted }
    }

    func setAction(_ action: AlertAction, withVisualStyle visualStyle: AlertVisualStyle) {
        action.actionView = self

        self.titleLabel.font = visualStyle.font(forAction: action)
        
        self.textColor = visualStyle.textColor(forAction: action)
        self.titleLabel.textColor = self.textColor ?? self.tintColor
        
        self.titleLabel.attributedText = action.attributedTitle

        self.highlightedBackgroundView.backgroundColor = visualStyle.actionHighlightColor

        self.accessibilityLabel = action.attributedTitle?.string
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.isAccessibilityElement = true
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.titleLabel.textColor = textColor ?? self.tintColor
    }
}

final class ActionSeparatorView: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        if let attributes = layoutAttributes as? ActionsCollectionViewLayoutAttributes {
            self.backgroundColor = attributes.backgroundColor
        }
    }
}
