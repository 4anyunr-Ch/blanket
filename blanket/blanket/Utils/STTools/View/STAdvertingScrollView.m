//
//  STAdvertingScrollView.m
//  STTools
//
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.


#import "STAdvertingScrollView.h"
#import "UIButton+WebCache.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface STAdvertingScrollView()<UIScrollViewDelegate>
@property(nonatomic,strong)NSTimer                          *timer;
@property(nonatomic)       CGPoint                          ypoint;
@property(nonatomic,strong)NSMutableArray<UIButton*>        *butArray;
@property(nonatomic,copy)  STAdvertingScrollViewHandle        action;
@property(nonatomic,strong)UIScrollView                     *scrollView;
@property(nonatomic,assign)NSInteger                         timerNum;
@end
@implementation STAdvertingScrollView
-(instancetype)initWithFrame:(CGRect)frame andWithArray:(NSArray<NSString *> *)array handle:(STAdvertingScrollViewHandle)handle
{
    if (self = [super initWithFrame:frame]) {
        self.timerNum = 0;
        _dataSouce = array;
        _titleInset = UIEdgeInsetsZero;
        _ypoint = CGPointMake(0, 0);
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollStyle = ScrollStyleDefult;
        [self addSubview:self.scrollView];
        self.scrollView.pagingEnabled = YES;
        self.canAutoScroll = NO;
        self.scrollView.alwaysBounceHorizontal = YES;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.butArray = [NSMutableArray new];
        self.action = handle;
        __weak typeof(self) weakSelf =self;
        self.pageControll = [[STPageControl alloc] initWithPages:array.count handle:^(NSInteger tag) {
            [weakSelf scrollViewDidEndDragging:weakSelf.scrollView willDecelerate:YES];
            [weakSelf.scrollView setContentOffset:CGPointMake(tag * weakSelf.scrollView.frame.size.width, 0) animated:YES];
        }];
        [self addSubview:self.pageControll];
       
    }
    return self;
}
-(void)removeFromSuperview
{
    [self.timer invalidate];
    [super removeFromSuperview];
}
-(void)setHidden:(BOOL)hidden
{
    [self.timer invalidate];
    [super setHidden: hidden];
}
#pragma mark --Geter And Setter
-(void)setTime:(NSTimeInterval)time
{
    if (time) {
        _time = time;
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    }
}
-(void)setTitleInset:(UIEdgeInsets)titleInset
{
        _titleInset = titleInset;
    if (self.scrollStyle == ScrollStyleString) {
        for (UIButton * but in [self subviews]) {
            but.titleEdgeInsets = titleInset;
        }
    }

}
-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    if (self.scrollStyle == ScrollStyleString) {
        for (UIButton * but in [self subviews]) {
            [but setTitleColor:titleColor forState:UIControlStateNormal];
        }
    }
}
-(void)setTitleFont:(CGFloat)titleFont
{
    _titleFont = titleFont;
    if (self.scrollStyle == ScrollStyleString) {
        for (UIButton * but in [self subviews]) {
            [but.titleLabel setFont:[UIFont systemFontOfSize:titleFont]];
        }
    }
}
-(void)setScrollStyle:(ScrollStyle)scrollStyle
{
     self.butArray = [NSMutableArray new];
    if (scrollStyle == ScrollStyleString) {
       
        for (UIView * view in [self.scrollView subviews]) {
            [view removeFromSuperview];
        }
        _scrollStyle = scrollStyle;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.alwaysBounceHorizontal = NO;
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollView.contentSize = CGSizeMake(0, self.frame.size.height * self.dataSouce.count) ;
        
        for (int i = 0; i<self.dataSouce.count; i++) {
            UIButton * but = [[UIButton alloc ] initWithFrame:CGRectMake(0, self.frame.size.height * i, self.frame.size.width, self.frame.size.height)];
            [but setTitle:self.dataSouce[i] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
            but.tag = i;
            if (!UIEdgeInsetsEqualToEdgeInsets(_titleInset, UIEdgeInsetsZero)) {
                but.titleEdgeInsets = _titleInset;
            }
            if (_titleColor) {
                [but setTitleColor:_titleColor forState:UIControlStateNormal];
            }
            if (_titleFont) {
                [but.titleLabel setFont:[UIFont systemFontOfSize:_titleFont]];
            }
            [self.scrollView addSubview:but];
            [self.butArray addObject:but];
            
        }
    }
    else
    {
        for (UIView * view in [self.scrollView subviews]) {
            [view removeFromSuperview];
        }
        _scrollStyle = scrollStyle;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.alwaysBounceHorizontal = YES;
        self.scrollView.alwaysBounceVertical = NO;
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.dataSouce.count, 0) ;
        NSLog(@"%f",self.scrollView.contentSize.width);
        for (int i=0; i<self.dataSouce.count; i++) {
            UIButton * but = [[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.frame.size.height)];
            [but setBackgroundImage:[UIImage imageNamed:self.dataSouce[i]] forState:UIControlStateNormal];
            [but setBackgroundImage:[UIImage imageNamed:self.dataSouce[i]] forState:UIControlStateSelected];
            [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
            but.tag = i;
            [self.scrollView addSubview:but];
            [self.butArray addObject:but];
            
        }
    }
    
}
-(void)setCanAutoScroll:(BOOL)canAutoScroll
{
    if (canAutoScroll) {
        _timer=nil;
        _canAutoScroll=canAutoScroll;
        
        _timer=[NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        
    }
    else{
        _timer=nil;
    }
}

#pragma mark -----timer事件
-(void)timerAction{
    self.timerNum ++ ;
    if (self.scrollStyle == ScrollStyleDefult) {
        CGPoint offSet = self.scrollView.contentOffset;
        offSet = CGPointMake(self.scrollView.frame.size.width * (self.timerNum%self.dataSouce.count), 0);
        if (offSet.x > self.frame.size.width * _dataSouce.count) {
            offSet.x = 0;
            
        }
        [self.scrollView setContentOffset:offSet animated:YES];
    }
    
    else{
        
        _ypoint.y += self.frame.size.height;
        
        if (_ypoint.y >= self.frame.size.height * _dataSouce.count) {
            _ypoint.y = 0;
            
        }
        [self.scrollView setContentOffset:_ypoint animated:NO];

    
    
    }
    

    
}
#pragma mark -----数据源
-(void)setDataSouce:(NSArray *)dataSouce
{
    self.pageControll.numberOfPages = dataSouce.count;
    self.pageControll.currentPage = 0 ;
    if (dataSouce&&[dataSouce.firstObject isKindOfClass:[NSString class]]) {
        _dataSouce = dataSouce;
    }
    else{
        NSLog(@"轮播数组必须是字符串");
        _dataSouce=nil;
    }
    
}
-(void)setImageUrlsArray:(NSArray *)imageUrlsArray
{
    _imageUrlsArray = imageUrlsArray;
    self.pageControll.numberOfPages = imageUrlsArray.count;
    self.pageControll.currentPage = 0 ;
    self.dataSouce = self.imageUrlsArray;
    self.scrollStyle = ScrollStyleDefult;
    for (int i =0; i<self.imageUrlsArray.count; i++) {
        [self.butArray[i] sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrlsArray[i]]  forState:UIControlStateNormal placeholderImage:_placeholderImage];
    }
    
}
-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    for (int i =0; i<self.imageUrlsArray.count; i++) {
        [self.butArray[i] sd_setBackgroundImageWithURL:[NSURL URLWithString:_imageUrlsArray[i]]  forState:UIControlStateNormal placeholderImage:_placeholderImage];
    }
}
#pragma mark -----点击事件
-(void)butAction:(id)sender
{
    if (self.dataSouce.count==0) {
        return;
    }
    
    UIButton * but=sender;
    NSLog(@"%lu",but.tag);
    if (self.action) {
        self.action(but.tag);
        
    }
    
}
#pragma mark -----拖拽重新纪时间
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        self.timerNum = scrollView.contentOffset.x/scrollView.frame.size.width;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{



}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger num = (self.scrollView.contentOffset.x + 10 ) / self.scrollView.frame.size.width ;
//    NSLog(@"xx--%f",self.scrollView.contentOffset.x );
//    NSLog(@"num----%ld",num);
    self.pageControll.currentPage = num;

}
@end







//---pageControl  ----------------
@interface STPageControl()
@property(nonatomic,copy)STPageControlHandle           handle;
@end
@implementation STPageControl

-(instancetype)initWithPages:(NSInteger)numberOfPages handle:(STPageControlHandle)handle
{
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 10*numberOfPages + 5 * (numberOfPages-1), 10);
        self.numberOfPages = numberOfPages;
        self.currentPage = 0;
        self.backgroundColor = [UIColor clearColor];
        if (handle) {
            self.handle = handle;
        }
    }
    return self;
}
-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.superview) {
        self.center = CGPointMake(self.superview.frame.size.width/2, self.superview.frame.size.height - 25);
    }
    for (NSInteger i =0; i<numberOfPages; i++) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(i*4 + 10* i, 3, 4, 4)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = i+1;
        view.layer.cornerRadius = 2;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSlectedPageControl:)];
        [view addGestureRecognizer:tap];
        
        [self addSubview:view];
    }
    _numberOfPages = numberOfPages;
}
-(void)didSlectedPageControl:(UITapGestureRecognizer*)sender
{
    if (self.handle) {
        self.handle(sender.view.tag - 1);
    }
    
}
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    for (UIView * view in self.subviews) {
        if (view.tag!=self.currentPage+1) {
            //未选中状态
            
            view.backgroundColor = pageIndicatorTintColor;
        }
        else
        {
            //选中状态
            if (_currentPageIndicatorTintColor) {
                view.backgroundColor = _currentPageIndicatorTintColor;
            }
            else
            {
                
                view.backgroundColor = [UIColor orangeColor];
            }
            
        }
    }
    _pageIndicatorTintColor = pageIndicatorTintColor;
}
-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    
    for (UIView * view in self.subviews) {
        if (view.tag   == self.currentPage+1) {
            view.backgroundColor = currentPageIndicatorTintColor;
        }
        else
        {
            //未选中状态
            if (_pageIndicatorTintColor) {
                view.backgroundColor = _pageIndicatorTintColor;
            }
            else
            {
                
                view.backgroundColor = [UIColor whiteColor];
            }
            
        }
    }
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}
-(void)setCurrentPage:(NSInteger)currentPage
{
    for (UIView * view in self.subviews) {
        if (view.tag == (currentPage  + 1) ) {
            //选中状态
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 7, 7);
            view.layer.cornerRadius = 3.5;
            view.center = CGPointMake(view.center.x, self.frame.size.height/2);
            if (_currentPageIndicatorTintColor) {
                view.backgroundColor = _currentPageIndicatorTintColor;
            }
            else
            {
                
                view.backgroundColor = [UIColor orangeColor];
            }
        }
        else
        {
            //未选中状态
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 4, 4);
            view.layer.cornerRadius = 2;
            view.center = CGPointMake(view.center.x, self.frame.size.height/2);
            if (_pageIndicatorTintColor) {
                view.backgroundColor = _pageIndicatorTintColor;
            }
            else
            {
                
                view.backgroundColor = [UIColor whiteColor];
            }
            
        }
    }
    
    _currentPage = currentPage;
}

@end
