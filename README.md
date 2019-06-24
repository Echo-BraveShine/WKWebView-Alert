# WKWebView-Alert
拦截WKWebView 中长按 图片 a标签等 弹出的UIAlertController点击UIAlertAction

使用
```swift
 NotificationCenter.default.rx.notification(.imageActionSheetClick).subscribe(onNext: { [weak self] (notif) in
            
            guard let web : WKWebView = notif.userInfo?["webView"] as? WKWebView, web == self?.webview else {
                return;
            }
                        
            guard let idx : Int = notif.userInfo?["idx"] as? Int else{return}
            
            if idx == 0 {
                self?.view.showHint(hint: "图片保存成功")
            }else if idx == 1{
                self?.view.showHint(hint: "图片拷贝成功")
            }
            
        }).disposed(by: disposeBag)
```
