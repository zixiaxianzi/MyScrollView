//
//  HuaScrollView.h
//  MyScrollView
//
//  Created by lanou3g on 15/12/4.
//  Copyright © 2015年 候美花. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^scrollImageSelectBlock)(NSInteger);

@interface HuaScrollView : UIView

//放图片地址的数组
@property (nonatomic,strong)NSMutableArray *imagesArray;
//page当前页 点 的颜色
@property (nonatomic,strong)UIColor *currentPageIndicatorTintColor;
//page 未选中  点  的颜色
@property (nonatomic,strong)UIColor *pageIndicatorTintColor;
//图片点击事件
@property (nonatomic,copy)scrollImageSelectBlock scrollViewSelectAction;
//滚动间隔时间
@property (nonatomic,strong)NSNumber *autoTime;


- (void)start;   //加载初始化, 必须实现


@end
