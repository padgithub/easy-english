//
//  WPPickerView.m
//  WeddingPlan
//
//  Created by Minh Tri on 1/3/14.
//  Copyright (c) 2014 Nikmesoft Ltd. All rights reserved.
//

#import "WPPickerView.h"

@implementation WPPickerView

-(id)init
{
    self = [super init];
    if (self)
    {
        self.delegate = nil;
        
        self.actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.actionSheet.view addSubview:self.navigationBar];
        
        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        [self.navigationBar pushNavigationItem:navigationItem animated:NO];
        
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        self.navigationBar.topItem.leftBarButtonItem = cancelButtonItem;
        self.navigationBar.topItem.rightBarButtonItem = doneButtonItem;
        
        self.pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 170)];
        self.pickerview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.actionSheet.view addSubview:self.pickerview];
    }
    return self;
}
- (void)dealloc
{
    self.delegate = nil;
    
    self.navigationBar = nil;
    self.pickerview = nil;
    self.actionSheet = nil;
    
}

-(void)done
{
    
    if (self.delegate && [_delegate respondsToSelector:@selector(WPPickerView:dismissWithDone:)])
    {
        [_delegate WPPickerView:self dismissWithDone:YES];
    }
    [self.actionSheet dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)cancel
{
    
    
    if (self.delegate && [_delegate respondsToSelector:@selector(WPPickerView:senMessage:)])
    {
        [_delegate WPPickerView:self senMessage:@"gui tin tu WPPickerView"];
    }
    
    [self.actionSheet dismissViewControllerAnimated:YES completion:nil];
}

@end
