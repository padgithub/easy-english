//
//  WPPickerView.h
//  WeddingPlan
//
//  Created by Minh Tri on 1/3/14.
//  Copyright (c) 2014 Nikmesoft Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
@protocol WPPickerViewDelegate;

@interface WPPickerView : NSObject

@property(nonatomic,retain) id <WPPickerViewDelegate> delegate;
@property(nonatomic,retain) UINavigationBar *navigationBar;
@property(nonatomic,strong) UIPickerView *pickerview;
@property(nonatomic,retain) UIAlertController *actionSheet;

@end

//khai bao protocol delegate
@protocol WPPickerViewDelegate <NSObject>

@optional

- (void)WPPickerView:(WPPickerView*)pickerview dismissWithDone:(BOOL)done;
- (void)WPPickerView:(WPPickerView*)pickerview senMessage:(NSString*)message;
@end
