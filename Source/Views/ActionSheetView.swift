final class ActionSheetView: AlertControllerView {

    @IBOutlet fileprivate var primaryView: UIView!
    @IBOutlet fileprivate weak var cancelActionView: UIView?
    @IBOutlet fileprivate weak var cancelLabel: UILabel?
    @IBOutlet fileprivate weak var cancelButton: UIButton?
    @IBOutlet fileprivate var contentViewConstraints: [NSLayoutConstraint]!
    @IBOutlet fileprivate var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var cancelHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var titleWidthConstraint: NSLayoutConstraint!

    override var actions: [AlertAction] {
        didSet {
            if let cancelActionIndex = self.actions.index(where: { $0.style == .preferred }) {
                self.cancelAction = self.actions[cancelActionIndex]
                self.actions.remove(at: cancelActionIndex)
            }
        }
    }

    override var actionTappedHandler: ((AlertAction) -> Void)? {
        didSet { self.actionsCollectionView.actionTapped = self.actionTappedHandler }
    }

    override var visualStyle: AlertVisualStyle! {
        didSet {
            let widthOffset = self.visualStyle.contentPadding.left + self.visualStyle.contentPadding.right
            self.titleWidthConstraint.constant -= widthOffset
        }
    }

    fileprivate var cancelAction: AlertAction? {
        didSet { self.cancelLabel?.attributedText = self.cancelAction?.attributedTitle }
    }

    override func prepareLayout() {
        super.prepareLayout()

        self.collectionViewHeightConstraint.constant = self.actionsCollectionView.displayHeight
        self.collectionViewHeightConstraint.isActive = true

        self.primaryView.layer.cornerRadius = self.visualStyle.cornerRadius
        self.primaryView.layer.masksToBounds = true
        self.cancelActionView?.layer.cornerRadius = self.visualStyle.cornerRadius
        self.cancelActionView?.layer.masksToBounds = true

        self.cancelLabel?.textColor = self.visualStyle.textColor(forAction: self.cancelAction) ?? self.tintColor
        self.cancelLabel?.font = self.visualStyle.font(forAction: self.cancelAction)
        let cancelButtonBackground = UIImage.imageWithColor(self.visualStyle.actionHighlightColor)
        self.cancelButton?.setBackgroundImage(cancelButtonBackground, for: .highlighted)
        self.cancelHeightConstraint.constant = self.visualStyle.actionViewSize.height

        let showContentView = self.contentView.subviews.count > 0
        self.contentView.isHidden = !showContentView
        self.contentViewConstraints.forEach { $0.isActive = showContentView }
    }

    override func highlightActionForPanGesture(_ sender: UIPanGestureRecognizer) {
        super.highlightActionForPanGesture(sender)
        let cancelIsSelected = self.cancelActionView?.frame.contains(sender.location(in: self)) == true
        self.cancelButton?.isHighlighted = cancelIsSelected

        if cancelIsSelected && sender.state == .ended {
            self.cancelButton?.sendActions(for: .touchUpInside)
        }
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.cancelLabel?.textColor = self.visualStyle.textColor(forAction: self.cancelAction) ?? self.tintColor
    }

    @IBAction fileprivate func cancelTapped() {
        guard let action = self.cancelAction else { return }
        self.actionTappedHandler?(action)
    }
}

private extension UIImage {

    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        let context = UIGraphicsGetCurrentContext()!
        color.setFill()
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }
}
