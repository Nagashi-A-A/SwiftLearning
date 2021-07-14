//
//  ActionViewController.swift
//  Extension
//
//  Created by Anton Yaroshchuk on 30.06.2021.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem{
                    if let itemProvider = inputItem.attachments?.first {
                        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String){
                            [weak self] (dict, error) in
                            guard let itemDictionary = dict as? NSDictionary else { return }
                            guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                            
                            
                            self?.pageTitle = javaScriptValues["title"] as? String ?? "nil"
                            self?.pageURL = javaScriptValues["URL"] as? String ?? "nil"
                            
                            
                            DispatchQueue.main.async {
                                self?.title = self?.pageTitle
                            }
                        }
                    }
                }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text!]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
            print("We are inside zero statement")
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            print("We are inside else statement of adjustForKeyboard")
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
        print("We are here")
    }

}
