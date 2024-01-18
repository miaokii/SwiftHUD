//
//  ViewController.swift
//  SwiftHUD
//
//  Created by yoctech on 2024/1/17.
//

import UIKit

fileprivate struct MBExample {
    var title: String
    var selector: Selector?
    var closure: (()->Void)?
    static func example(title: String, selector: Selector? = nil, closure: (()->Void)? = nil) -> MBExample {
        MBExample.init(title: title, selector: selector, closure: closure)
    }
}

class MBHudDemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDelegate {

    // MARK: - Properties

    private var examples: [[MBExample]] = []
    var canceled: Bool = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.enableDarkMode = false
        HUD.bgColor = .black
        HUD.contentColor = .white
        HUD.margin = 15
        HUD.bgRadius = 2
        HUD.exceptionDelayHideSec = 2
        
        examples = [
            [MBExample.example(title: "Indeterminate mode", selector: #selector(indeterminateExample)),
             MBExample.example(title: "延迟展示关闭按钮", closure: {
                 HUD.show(.labelIndicator(title: "加载中", detail: "时间异常"))
             }),
            ],
            [
                MBExample.example(title: "Success", closure: {
                    HUD.flash(.labelSuccess(title: "成功", detail: "正在下载内容"), delay: 4, completion: nil)
                }),
                
            ]
        ]
        
        let safeArea = UIApplication.shared.windows.first?.safeAreaInsets ?? .zero

        let button = UIButton.init(frame: .init(x: 20, y: safeArea.top+20, width: 150, height: 30))
        button.setTitle("Loading View", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(presentLoadingView), for: .touchUpInside)
        
        let tableView = UITableView.init(frame: .init(x: 0, y: button.frame.maxY+20, width: view.frame.width, height: view.frame.height-button.frame.maxY-20-safeArea.bottom), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    @objc private func presentLoadingView() {
        let vc = LoadingViewController.init()
        present(vc, animated: true )
    }

    // MARK: - Examples

    @objc func indeterminateExample() {
        HUD.flash(.label(title: "提示", detail: "Hello World\n你好世界")) {
            print("Label HUD hide")
        }
    }

    // MARK: - Tasks

    func doSomeWork() {
        // Simulate by just waiting.
        Thread.sleep(forTimeInterval: 3.0)
    }

    func doSomeWork(withProgressObject progressObject: Progress) {
        // This just increases the progress indicator in a loop.
        while progressObject.fractionCompleted < 1.0 {
            if progressObject.isCancelled {
                break
            }
            progressObject.becomeCurrent(withPendingUnitCount: 1)
            progressObject.resignCurrent()
            usleep(50000)
        }
    }

    func doSomeWork(withProgress progress: Progress) {
        canceled = false

        // This just increases the progress indicator in a loop.
        var currentProgress: Float = 0.0
        while currentProgress < 1.0 {
            if canceled {
                break
            }
            currentProgress += 0.01
            DispatchQueue.main.async {
//                MBProgressHUD(for: self.navigationController!.view)?.progress = currentProgress
            }
            usleep(50000)
        }
    }

    // ... (Other methods unchanged)

    // MARK: - UITableViewDelegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return examples.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let example = examples[indexPath.section][indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "MBExampleCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "MBExampleCell")
        }
        cell!.textLabel?.text = example.title
        cell!.textLabel?.textColor = view.tintColor
        cell!.textLabel?.textAlignment = .center
        cell!.selectedBackgroundView = UIView()
        cell!.selectedBackgroundView?.backgroundColor = cell!.textLabel?.textColor?.withAlphaComponent(0.1)
        return cell!
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = examples[indexPath.section][indexPath.row]

        if let selector = example.selector {
            perform(selector)
        }
        
        if let closure = example.closure {
            closure()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - URLSessionDelegate

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Do something with the data at location...

        // Update the UI on the main thread
        DispatchQueue.main.async {
//            let hud = MBProgressHUD(for: self.navigationController!.view)
//            let image = UIImage(named: "Checkmark")!.withRenderingMode(.alwaysTemplate)
//            let imageView = UIImageView(image: image)
//            hud?.customView = imageView
//            hud?.mode = .customView
//            hud?.label.text = NSLocalizedString("Completed", comment: "HUD completed title")
//            hud?.hide(animated: true, afterDelay: 3.0)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)

        // Update the UI on the main thread
        DispatchQueue.main.async {
//            let hud = MBProgressHUD(for: self.navigationController!.view)
//            hud?.mode = .determinate
//            hud?.progress = progress
        }
    }
}


