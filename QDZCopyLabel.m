//
//  QDZCopyLabel.m
//  BlockDemo
//
//  Created by 亓大志 on 16/6/16.
//  Copyright © 2016年 亓大志. All rights reserved.
//

#import "QDZCopyLabel.h"
@implementation QDZCopyLabel
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    NSLog(@"%@",NSStringFromSelector(action));
    return (action == @selector(duplicate:));
}

- (void)duplicate:(id)sender{
    [self resignFirstResponder];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

- (void)attachLongHandle{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHide) name:UIMenuControllerWillHideMenuNotification object:nil];
    self.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleAction:)];
    longPress.minimumPressDuration = 1.0;
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
}

- (void)menuControllerWillHide{
    [self resignFirstResponder];
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self attachLongHandle];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self attachLongHandle];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)handleAction:(UIGestureRecognizer *)recognizer{
    [recognizer.view becomeFirstResponder];
    self.backgroundColor = [UIColor redColor];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(duplicate:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[item]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)dealloc{
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

@end
