//
//  UIView+Extension.m
//  Weibo
//
//  Created by Vincent_Guo on 15-3-16.
//  Copyright (c) 2015年 Fung. All rights reserved.
//

#import "UIView+QL.h"

@implementation UIView (QL)

-(void)setSize:(CGSize)size{
    self.bounds = CGRectMake(0, 0, size.width, size.height);
}

-(CGSize)size{
    return self.bounds.size;
}

-(void)setW:(CGFloat)width{
    
    CGRect frm = self.frame;
    frm.size.width = width;
    self.frame = frm;
}

-(CGFloat)width{
    return self.size.width;
}


-(void)setH:(CGFloat)height{
    CGRect frm = self.frame;
    frm.size.height = height;
    self.frame = frm;
}

-(CGFloat)height{
    return self.size.height;
}

-(void)setX:(CGFloat)x{
    CGRect frm = self.frame;
    frm.origin.x = x;
    
    self.frame = frm;
}
-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y{
    CGRect frm = self.frame;
    frm.origin.y = y;
    
    self.frame = frm;
    
}

-(CGFloat)y{
    return self.frame.origin.y;
}


- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

/** 水平居中 */
- (void)alignHorizontal
{
    self.x = (self.superview.width - self.width) * 0.5;
}

/** 垂直居中 */
- (void)alignVertical
{
    self.y = (self.superview.height - self.height) * 0.5;
}

- (void)setQl_bindName:(NSString *)ql_bindName{
    [self setValue:ql_bindName forUndefinedKey:@"ql_bindName"];
}

- (NSString *)ql_bindName{
    return [self valueForUndefinedKey:@"ql_bindName"];
}

- (void)autoSetValue:(NSDictionary *)info{
    NSString *_bindName = [self ql_bindName];
    if (_bindName == nil) {
        return;
    }
    id _autoValue = [info valueForKey:_bindName];
    [self setValue:_autoValue forUndefinedKey:@"ql_auto_value"];
}

- (id)ql_autoValue{
    return  [self valueForUndefinedKey:@"ql_auto_value"];
}

@end
