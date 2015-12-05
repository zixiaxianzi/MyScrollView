//
//  HuaScrollView.m
//  MyScrollView
//
//  Created by lanou3g on 15/12/4.
//  Copyright © 2015年 候美花. All rights reserved.
//

#import "HuaScrollView.h"
#import "HuaScrollImageView.h"
#import "UIImageView+WebCache.h"

@interface HuaScrollView ()<UIScrollViewDelegate>
{
    NSInteger _currentIndex;   //当前页
}
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *page;

@end


@implementation HuaScrollView

//开始
- (void)start{
    
    [self _initScrollView];
}

//自定义的方法, 创建scrollView 和 pageControll
- (void)_initScrollView{
    
    //1.scrollView
    if (_scrollView) {
        return;
    }
    _scrollView = ({
       
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        scrollView.bounces = YES;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.userInteractionEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        //如果只有一张图片, 就不能划动
        if (self.imagesArray.count < 2) {
            scrollView.scrollEnabled = NO;
        }
        [self addSubview:scrollView];
        scrollView;

    });
    
    
    //2.page
    _page = ({
        //将page显示在底部中间位置
        UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 100) / 2, CGRectGetHeight(self.frame) - 18, 100, 15)];
        //给 点 赋颜色(选中和未选中)
        [pageControl setCurrentPageIndicatorTintColor:self.currentPageIndicatorTintColor ? self.currentPageIndicatorTintColor : [UIColor purpleColor]];
        [pageControl setPageIndicatorTintColor:self.pageIndicatorTintColor ? self.pageIndicatorTintColor : [UIColor grayColor]];
        //点的个数
        pageControl.numberOfPages = _imagesArray.count;
        //初始化时默认显示第一页
        pageControl.currentPage = 0;
        //如果只有一张图片, 隐藏pageControl
        if (self.imagesArray.count < 2) {
            pageControl.hidden = YES;
        }
        [self addSubview:pageControl];
        pageControl;
    });
    
    
    
    
    //3.把外界给的imagesArray中图片请求下来, 并赋给scrollView
    //中间放所有展示的图片
    for (int i = 0; i < _imagesArray.count; i++) {
        
        HuaScrollImageView *scrollImage = [[HuaScrollImageView alloc]init];
        //让图片根据外界给的轮播图的frame 按比例填满
        scrollImage.contentMode = UIViewContentModeScaleToFill;
        [scrollImage sd_setImageWithURL:[NSURL URLWithString:_imagesArray[i]]];
        scrollImage.tag = 1000 + i;
        scrollImage.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) * (i + 1), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        //给图片添加点击事件
        [scrollImage addTarger:self action:@selector(imageAction:)];
        
        [_scrollView addSubview:scrollImage];
    }
    
    //取数组最后一张图片  放在第0页
    HuaScrollImageView *firstScrollImage = [[HuaScrollImageView alloc]init];
    firstScrollImage.contentMode = UIViewContentModeScaleToFill;
    [firstScrollImage sd_setImageWithURL:[NSURL URLWithString:_imagesArray[_imagesArray.count - 1]]];
    firstScrollImage.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    [_scrollView addSubview:firstScrollImage];
    
    
    //取数组的第一张图片  放在最后1页
    HuaScrollImageView *endScrollImage = [[HuaScrollImageView alloc]init];
    endScrollImage.contentMode = UIViewContentModeScaleToFill;
    [endScrollImage sd_setImageWithURL:[NSURL URLWithString:_imagesArray[0]]];
    endScrollImage.frame = CGRectMake((_imagesArray.count + 1) * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    [_scrollView addSubview:endScrollImage];
    
    
    //设置轮播图
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame)* (_imagesArray.count + 2), CGRectGetHeight(_scrollView.frame));
#warning 这里什么意思??
//    _scrollView.contentOffset = CGPointMake(0, 0);
    [_scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:YES];
    
    
    //如果外界没有设置滚动间隔时间, 就给它赋个值
    if (!self.autoTime) {
        self.autoTime = [NSNumber numberWithFloat:2.0f];
    }
    //如果外界设置了, 就是用外界给的值
    NSTimer *myTimer = [NSTimer timerWithTimeInterval:[self.autoTime floatValue] target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
#warning runloop
    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
   
    
}



//定时器方法
- (void)runTimePage{
    
    NSInteger page = self.page.currentPage;
    page ++;
    [self turnPage:page]; //播到哪一页
    
}
//播到哪一页
- (void)turnPage:(NSInteger)page{
    //记录当前页
    _currentIndex = page;
    [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(_scrollView.frame) * (page + 1), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:YES];
    
}


//图片的点击事件
- (void)imageAction:(UIImageView *)sender{
    
    if (_scrollViewSelectAction) {
        _scrollViewSelectAction(sender.tag - 1000);//调用block,传参数(当前第几页)
    }
    
}



#pragma mark  ----------- scrollView Delegate -----------------------
//已经滚动
#warning   ???/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat pageWith = self.scrollView.frame.size.width;
    NSInteger page = floor((self.scrollView.contentOffset.x - pageWith/2)/pageWith) + 1;
    page --;
    self.page.currentPage = page;
    
}

//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //计算page当前页
    CGFloat pageWith = self.scrollView.frame.size.width;
    NSInteger currentPage = _scrollView.contentOffset.x / pageWith - 1;
    //记录page当前页
    _currentIndex = currentPage;
    
    //-----
    _page.currentPage = currentPage;
    
    
    //如果第一页(放最后一张图片)
    if (_scrollView.contentOffset.x == 0) {
        
        [_scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(_scrollView.frame) * _imagesArray.count, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:NO];
        
        
     //最后一页(放第一张图片)
    }else if (_scrollView.contentOffset.x == CGRectGetWidth(_scrollView.frame) * (_imagesArray.count + 1)){
        
        [_scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:NO];
        
    }
    
    
    
    
}



//结束滚动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    //如果第一页(放最后一张图片)
    if (_scrollView.contentOffset.x == 0) {
        
        [_scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(_scrollView.frame) * _imagesArray.count, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:NO];
        
        
        //最后一页(放第一张图片)
    }else if (_scrollView.contentOffset.x == CGRectGetWidth(_scrollView.frame) * (_imagesArray.count + 1)){
        
        [_scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:NO];
        
    }
    
    
    //计算page当前页
    CGFloat pageWith = self.scrollView.frame.size.width;
    NSInteger currentPage = _scrollView.contentOffset.x / pageWith - 1;
    //记录page当前页
    _currentIndex = currentPage;
    
    //-----
    _page.currentPage = currentPage;
    
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
