//
//  NSObject+Extension.m
//  DuoDuo
//
//  Created by Hong Zhang on 2019/6/13.
//  Copyright © 2019 Muqiu. All rights reserved.
//

#import "WKWebView+Extension.h"
#import <objc/runtime.h>
#import <WebKit/WebKit.h>

@implementation UIAlertAction (Extension)
static NSString *kActionCompleteHandle = @"ActionCompleteHandle";
+(void)load
{
    method_exchangeImplementations(class_getInstanceMethod(self,NSSelectorFromString(@"setHandler:")), class_getInstanceMethod(self, @selector(dd_setHandler:)));
    //     method_exchangeImplementations(class_getInstanceMethod(self,NSSelectorFromString(@"setShouldDismissHandler:")), class_getInstanceMethod(self, @selector(dd_setShouldDismissHandler:)));
    //     method_exchangeImplementations(class_getInstanceMethod(self,NSSelectorFromString(@"setSimpleHandler:")), class_getInstanceMethod(self, @selector(dd_setSimpleHandler:)));
}

-(void)setActionCompleteHandle:(UIAlertActionCompleteHandle)actionCompleteHandle
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(@"setHandler:") withObject:actionCompleteHandle];
#pragma clang diagnostic pop
    
    objc_setAssociatedObject(self, &kActionCompleteHandle, actionCompleteHandle, OBJC_ASSOCIATION_RETAIN);
}
-(UIAlertActionCompleteHandle)actionCompleteHandle
{
    return objc_getAssociatedObject(self, &kActionCompleteHandle);
}

-(void)dd_setHandler:(id)obj
{
    if (obj){
        __block UIAlertActionCompleteHandle clickBlock = (UIAlertActionCompleteHandle)obj;
        UIAlertActionCompleteHandle block = ^(UIAlertAction * _Nonnull action) {
            if (self.actionCompleteHandle) {
                self.actionCompleteHandle(action);
            }
            clickBlock(action);
        };
        [self dd_setHandler:block];
    }else{
        [self dd_setHandler:obj];
        
    }
}

@end




@implementation NSObject (Extension)

static NSString *kWKActionSheetMode = @"kWKActionSheetMode";

-(void)setActionSheetMode:(WKActionSheetMode)actionSheetMode
{
    objc_setAssociatedObject(self, &kWKActionSheetMode, [NSNumber numberWithInteger:actionSheetMode], OBJC_ASSOCIATION_RETAIN);
}

-(WKActionSheetMode)actionSheetMode
{
    NSNumber *mode = objc_getAssociatedObject(self, &kWKActionSheetMode);
    
    switch (mode.integerValue) {
        case 0:
            return WKActionSheetModeLink;
        case 1:
            
            return WKActionSheetModeImage;
        case 2:
            
            return WKActionSheetModeDataDetectors;
            
        default:
            return WKActionSheetModeLink;
    }
    
    return WKActionSheetModeLink;
}

+(void)load
{
    
    method_exchangeImplementations(class_getInstanceMethod(NSClassFromString(@"WKActionSheetAssistant"), NSSelectorFromString(@"showImageSheet")), class_getInstanceMethod(self, @selector(dd_showImageSheet)));
    
    method_exchangeImplementations(class_getInstanceMethod(NSClassFromString(@"WKActionSheetAssistant"), NSSelectorFromString(@"showLinkSheet")), class_getInstanceMethod(self, @selector(dd_showLinkSheet)));
    
    
    method_exchangeImplementations(class_getInstanceMethod(NSClassFromString(@"WKActionSheetAssistant"), NSSelectorFromString(@"showDataDetectorsSheet")), class_getInstanceMethod(self, @selector(dd_showDataDetectorsSheet)));
    
    method_exchangeImplementations(class_getInstanceMethod(NSClassFromString(@"WKActionSheet"), NSSelectorFromString(@"presentSheetFromRect:")), class_getInstanceMethod(self, @selector(dd_presentSheetFromRect:)));
}

-(void)dd_showImageSheet
{
    self.actionSheetMode = WKActionSheetModeImage;
    [self dd_showImageSheet];
}

-(void)dd_showLinkSheet
{
    self.actionSheetMode = WKActionSheetModeLink;
    [self dd_showLinkSheet];
}

-(void)dd_showDataDetectorsSheet
{
    self.actionSheetMode = WKActionSheetModeDataDetectors;
    [self dd_showDataDetectorsSheet];
}

- (BOOL)dd_presentSheetFromRect:(CGRect)presentationRect
{
    BOOL flag = [self dd_presentSheetFromRect:presentationRect];
    UIAlertController *alert = (UIAlertController *)self;
    
    NSObject *actionSheetAssistant = [alert valueForKeyPath:@"_sheetDelegate"];
    UIView *contentView = (UIView *)[actionSheetAssistant valueForKey:@"delegate"];
    WKWebView *webView = (WKWebView *)contentView.superview.superview;
    
    if (actionSheetAssistant) {
        [alert.actions enumerateObjectsUsingBlock:^(__weak UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.actionCompleteHandle = ^(UIAlertAction *action) {
                
                NSString *notifName = @"";
              
                if (actionSheetAssistant.actionSheetMode == WKActionSheetModeLink) {
                    notifName = @"linkActionSheetClick";
                }else if (actionSheetAssistant.actionSheetMode == WKActionSheetModeImage){
                    notifName = @"imageActionSheetClick";
                }else if (actionSheetAssistant.actionSheetMode == WKActionSheetModeDataDetectors){
                    notifName = @"dataDetectorsActionSheetClick";
                }
                
                [[NSNotificationCenter defaultCenter]postNotificationName:notifName object:obj userInfo:@{@"idx":@(idx),@"webView":webView}];
                
            };
        }];
    }
    
    return flag;
}


@end
