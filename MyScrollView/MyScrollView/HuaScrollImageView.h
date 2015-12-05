//
//  HuaScrollImageView.h
//  MyScrollView
//
//  Created by lanou3g on 15/12/4.
//  Copyright © 2015年 候美花. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuaScrollImageView : UIImageView

@property (nonatomic,assign)id target;
@property (nonatomic,assign)SEL action;

- (void)addTarger:(id)target action: (SEL)action;

@end
