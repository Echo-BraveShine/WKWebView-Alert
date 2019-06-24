//
//  NSObject+Extension.h
//  DuoDuo
//
//  Created by Hong Zhang on 2019/6/13.
//  Copyright © 2019 Muqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// 监听WKWebView 长按alert点击

//NS_ASSUME_NONNULL_BEGIN


/**
 WKWebView 长按Alert类型

 - WKActionSheetModeLink: 链接长按
 - WKActionSheetModeImage: 图片长按
 - WKActionSheetModeDataDetectors: 数据探测器长按
 */
typedef NS_ENUM(NSInteger, WKActionSheetMode) {
    WKActionSheetModeLink = 0,
    WKActionSheetModeImage,
    WKActionSheetModeDataDetectors
};

@interface NSObject (Extension)

@property (nonatomic,assign) WKActionSheetMode actionSheetMode;

@end

typedef void(^ UIAlertActionCompleteHandle)(UIAlertAction *action);

@interface UIAlertAction (Extension)

@property (nonatomic,strong) UIAlertActionCompleteHandle actionCompleteHandle;

@end

//NS_ASSUME_NONNULL_END
