//
//  UIView+Extension.h
//  MoGoWeiBo
//
//  Created by 李策 on 16/4/7.
//  Copyright © 2016年 李策. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
//设置圆弧
- (void)setCornerRadius:(CGFloat)cornerRadius;
//返回一条线view
- (UIView *)lineV;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@end
