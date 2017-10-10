import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var stampBaseView: UIView!
    @IBOutlet private var stamps: [UIImageView]!
    @IBOutlet weak var btnAddStamp: UIButton!

    private var currentStampNo: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let _ = stamps.map { $0.isHidden = true }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addStamp(_ sender: UIButton) {
        if currentStampNo < stamps.count {
            animationStamp(target: stamps[currentStampNo])
            currentStampNo += 1
        }
    }

    private func animationStamp(target stamp: UIImageView) {
        btnAddStamp.isEnabled = false
        stamp.alpha = 0.0
        stamp.isHidden = false

        let b = stamp.bounds

        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 10,
                       options: [], animations: {
                           stamp.bounds = CGRect(x: b.origin.x,
                                                 y: b.origin.y,
                                                 width: b.size.width + 130,
                                                 height: b.size.height + 130) },
                       completion: nil)

        UIView.animate(withDuration: 0.05,
                       delay: 0.2,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 90,
                       options: [], animations: {
                           stamp.bounds = CGRect(x: b.origin.x,
                                                 y: b.origin.y,
                                                 width: b.size.width,
                                                 height: b.size.height)
                           stamp.alpha = 1.0 },
                       completion: { [weak self] _ in
                           guard let weakSelf = self else { return }

                           weakSelf.vibrate(amount: 3.0, view: weakSelf.stampBaseView) { [weak self] _ in
                               guard let weakSelf = self else { return }

                               weakSelf.btnAddStamp.isEnabled = true
                           }
                       })
    }

    private func vibrate(amount: Float, view: UIView, completion: ((Bool) -> Swift.Void)) {
        if amount > 0 {
            var animation: CABasicAnimation
            animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.1
            animation.fromValue = amount * Float.pi / 180.0
            animation.toValue = 0 - (animation.fromValue as! Float)
            animation.repeatCount = 1.0
            animation.autoreverses = true
            view.layer .add(animation, forKey: "VibrateAnimationKey")
        } else {
            view.layer.removeAnimation(forKey: "VibrateAnimationKey")
        }

        completion(true)
    }
}
