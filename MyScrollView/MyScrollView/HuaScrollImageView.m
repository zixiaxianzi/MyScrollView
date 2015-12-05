//
//  HuaScrollImageView.m
//  MyScrollView
//
//  Created by lanou3g on 15/12/4.
//  Copyright © 2015年 候美花. All rights reserved.
//

#import "HuaScrollImageView.h"

@implementation HuaScrollImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //打开用户交互
        self.userInteractionEnabled = YES;
        
    }
    return self;
}


- (void)addTarger:(id)target action:(SEL)action{
    
    //赋给属性
    self.target = target;
    self.action = action;
    
}


//点击图片的时候
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    //如果self.target表示的对象中, self.action表示的方法存在的话
    if ([self.target respondsToSelector:self.action]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [self.target performSelector:self.action withObject:self];
        
#pragma clang diagnostic pop
        
    }
    
}





//忽略performSelector警告
//
//#pragma clang diagnostic push
//
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//
//[viewController performSelector:finishMethod withObject:request];
//
//#pragma clang diagnostic pop





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
