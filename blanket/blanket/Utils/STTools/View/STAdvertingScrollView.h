//
//  STAdvertingScrollView.h
//  STTools
//
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
// 说明：轮播广告，默认时间两秒，有两种模式，上下文字，左右图片,需要完善

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ScrollStyle)
{
    ScrollStyleImage,//图片左右滑动
    ScrollStyleString,//文字上下滑动
    ScrollStyleDefult = ScrollStyleImage,
    
};
@class  STPageControl;
typedef void(^STAdvertingScrollViewHandle)(NSInteger num);
@interface STAdvertingScrollView : UIView
@property(nonatomic)BOOL                    canAutoScroll;//是否允许自动轮播 默认是no

@property(nonatomic)UIEdgeInsets            titleInset;//设置but的titleedge，只有在文字轮播模式下才有效
@property(nonatomic)CGFloat                 titleFont;//设置but的titlefont，只有在文字轮播模式下才有效
@property(nonatomic,strong)UIColor          *titleColor;//只有在文字轮播模式下才有效

@property(nonatomic)ScrollStyle             scrollStyle;//轮播方式，默认是图片
@property(nonatomic)NSTimeInterval          time;//滑动时间间隔，默认2秒
@property(nonatomic,strong)UIImage          *placeholderImage;//默认是nil
@property(nonatomic,strong)NSArray          *imageUrlsArray;//网络图片，
@property(nonatomic,strong)NSArray          *dataSouce;//本地图片
@property(nonatomic,strong)STPageControl    *pageControll;//pagecontrol ,可控制颜色等属性
- (instancetype)initWithFrame:(CGRect)frame  andWithArray:(NSArray<NSString*>*)array handle:(STAdvertingScrollViewHandle)handle;

@end



//pageControll
typedef void(^STPageControlHandle)(NSInteger tag);
@interface STPageControl : UIControl
@property(nonatomic) NSInteger              currentPage;// 当前page
@property(nonatomic) BOOL                   isShowAnimation;// 默认显示动画，待完善
@property(nonatomic,strong) UIColor         *pageIndicatorTintColor;//普通状态颜色
@property(nonatomic)  CGSize                 pageSize;//普通状态大小，有默认值（4.4），需要的时候在重写set
@property(nonatomic,strong) UIColor         *currentPageIndicatorTintColor ; //选择后状态颜色
@property(nonatomic)CGSize                  currentPageSize;//选择状态大小，有默认值 （7，7）需要的时候在重写set
@property(nonatomic)NSInteger               numberOfPages;// 数量
-(instancetype)initWithPages:(NSInteger)Pages handle:(STPageControlHandle)handle;
@end
