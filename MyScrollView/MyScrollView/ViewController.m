//
//  ViewController.m
//  MyScrollView
//
//  Created by lanou3g on 15/12/4.
//  Copyright © 2015年 候美花. All rights reserved.
//

#import "ViewController.h"
#import "HuaScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];



    //存放图片的数组:
    NSArray *dataArray = @[@"http://cdn6.jinxidao.com/uploads/201512/56614adcb95e6.jpg",@"http://cdn6.jinxidao.com/uploads/201511/56458e4e693c9.jpg",@"http://cdn6.jinxidao.com/uploads/201512/565e6509ca248.jpg",@"http://cdn6.jinxidao.com/uploads/201511/565816acd50fb.jpg",@"http://cdn6.jinxidao.com/uploads/201512/565e932d64069.jpg"];
    
    
    HuaScrollView *scroll = [[HuaScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 120)];
    scroll.imagesArray = dataArray.mutableCopy;
    
    scroll.autoTime = @"5";
    scroll.scrollViewSelectAction = ^(NSInteger i){
        
        NSLog(@"%ld",i);
    };
    
    [scroll start];
    [self.view addSubview:scroll];
    
    
    
    
    
    
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
