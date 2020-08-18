import UIKit
import Foundation

//MARK: - PROTOCOL VISIBLE CELL
fileprivate protocol ListSkeletonable {
    func ba_visibleContentViews()->[UIView]
}

//MARK: - STATE TABLEVIEW
public enum BATableViewState {
    case loading(indicatorWidth: CGFloat = 100,
        indicatorHeight: CGFloat = 100,
        indicatorColor: UIColor = UIColor.gray,
        backgroundColor: UIColor = UIColor.white)
    case customLoadingView
    case skeletonLoading
    case emptyData
    case availableData
    case unknown
    
    func description() -> String {
        switch self {
        case .loading(_, _, _, _):
            return "loading"
        case .customLoadingView:
            return "customLoadingView"
        case .skeletonLoading:
            return "skeletonLoading"
        case .emptyData:
            return "emptyData"
        case .availableData:
            return "availableData"
        case .unknown:
            return "unknown"
        }
    }
}

@IBDesignable
public class BAStateTableView: UITableView, ListSkeletonable {
    //MARK: - CURRENT STATE
    public var currentState: BATableViewState = .unknown {
        didSet {
            switch currentState {
            case .availableData:
                isScrollEnabled = true
            default:
                isScrollEnabled = false
            }
        }
    }
    
    //MARK: - LOADING VIEW
    open var loadingView: UIView?
    open var emptyView: UIView?
    
    //MARK: - SET STATE
    public func setState(_ state: BATableViewState) {
        //Note: - Avoid repeat dialing
        guard currentState.description() != state.description() else { return}
        
        currentState = state
        
        removeAllSubviews()
        
        switch state {
        case .loading(let indicatorWidth, let indicatorHeight, let indicatorColor, let backgroundColor):
            configureStateLoading(indicatorWidth: indicatorWidth,
                                  indicatorHeight: indicatorHeight,
                                  indicatorColor: indicatorColor,
                                  backgroundColor: backgroundColor)
        case .customLoadingView:
            configureStateCustomLoading()
        case .emptyData:
            configureStateEmptyView()
        case .skeletonLoading:
            reloadData()
            skeletonStatus = .on
            SkeletonLoader.addLoaderTo(self)
        case .availableData:
            if isSkeletonActive {
                SkeletonLoader.removeLoaderFrom(self) { [weak self] in
                    self?.skeletonStatus = .off
                    self?.reloadData()
                }
            } else {
                reloadData()
            }
        default:
            break
        }
    }
    
    //MARK: - CONFIGURE STATE
    private func configureStateLoading(indicatorWidth: CGFloat, indicatorHeight: CGFloat, indicatorColor: UIColor, backgroundColor: UIColor) {
        loadingView = UIView()
        guard let loadingView = loadingView else { return }
        
        loadingView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        loadingView.tag = 111
        loadingView.backgroundColor = backgroundColor

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight))
        loadingIndicator.color = indicatorColor
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        
        loadingView.addSubview(loadingIndicator)
        self.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureStateCustomLoading() {
        guard let customLoadingView = loadingView else { return }
        
        customLoadingView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        customLoadingView.tag = 112
        
        self.addSubview(customLoadingView)
    }
    
    private func configureStateEmptyView() {
        guard let emptyView = emptyView else { return }
        
        emptyView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        emptyView.tag = 113
        
        self.addSubview(emptyView)
    }
    
    //MARK: - REMOVE SUBVIEWS
    private func removeAllSubviews() {
        for s in self.subviews {
            if s.tag == 111 || s.tag == 112 || s.tag == 113 {
                s.removeFromSuperview()
            }
        }
    }
    
    //MARK: - VISIBLE CELLS
    fileprivate func ba_visibleContentViews()->[UIView] {
        return (self.visibleCells as NSArray).value(forKey: "contentView") as! [UIView]
    }
}

//MARK: - OBJECT FUNC SKELETON LOADER
fileprivate class SkeletonLoader: NSObject {
    static func addLoaderToViews(_ views : [UIView]) {
        views.forEach { $0.ba_addSkeletonLoader() }
    }
    
    static func removeLoaderFromViews(_ views: [UIView], completion: (()->Void)?) {
        views.forEach { $0.ba_removeSkeletonLoader() }

        completion?()
    }
    
    public static func addLoaderTo(_ list : ListSkeletonable ) {
        self.addLoaderToViews(list.ba_visibleContentViews())
    }
    
    public static func removeLoaderFrom(_ list : ListSkeletonable, completion: (()->Void)?) {
        self.removeLoaderFromViews(list.ba_visibleContentViews()) {
            completion?()
        }
    }
}

extension UIView {
    fileprivate func ba_addSkeletonLoader() {
        let subview = self.getAllSubviews()
        subview.forEach { (view) in
            if view.isSkeletonable {
                let gradientView = GradientView(frame: view.bounds)
                gradientView.layer.cornerRadius = CGFloat(view.skeletonCornerRadius)
                gradientView.clipsToBounds = true

                //MARK: -  Custom Direction
                gradientView.startGradientPoint = .right
                gradientView.endGradientPoint = .left

                //MARK: -  Custom Duration
                gradientView.animationDuration = 1.0
                
                //MARK: -  Custom Color
                gradientView.setGradientColors(.gray)
                
                gradientView.startAnimation()
                view.addSubview(gradientView)
                view.defaultCornerRadius = view.layer.cornerRadius
                view.layer.cornerRadius = CGFloat(view.skeletonCornerRadius)
                view.clipsToBounds = true
            }
        }
    }
    
    fileprivate func ba_removeSkeletonLoader() {
        let subview = self.getAllSubviews()
        subview.forEach { (view) in
            if view.isSkeletonable {
                view.subviews.forEach { (v) in
                    if v is GradientView {
                        v.removeFromSuperview()
                        view.layer.cornerRadius = CGFloat(view.defaultCornerRadius)
                        view.clipsToBounds = true
                    }
                }
            }
        }
    }
}
