//
//  UIViewController+STNavigationTools.m
//  SportHome
//
//  Created by stoneobs on 17/1/11.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import "UIViewController+STNavigationTools.h"

@implementation UIViewController (STNavigationTools)
- (void)st_setLeftItemWithTitle:(NSString *)title
{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(st_leftBarAction:)];
    self.navigationItem.leftBarButtonItem = left;
}
- (void)st_setLeftItemWithTitle:(NSString *)title titleColor:(UIColor*)color;
{

    UIBarButtonItem * left =[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(st_leftBarAction:)];
    [left setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
    left.tintColor = color;
    self.navigationItem.leftBarButtonItem = left;
   
}
- (void)st_setLeftItemWithImage:(UIImage *)image
{
    UIImage * editimgae = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * leftImageItem = [[UIBarButtonItem alloc]initWithImage:editimgae style:UIBarButtonItemStyleDone target:self action:@selector(st_leftBarAction:)];
    self.navigationItem.leftBarButtonItem = leftImageItem;
}
- (void)st_setLeftItemWithImage:(UIImage *)image andwithTitle:(NSString *)title  titleColor:(UIColor*)titleColor
{
    UIButton * but =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
    [but setImage:image forState:UIControlStateNormal];
    [but setImage:image forState:UIControlStateSelected];
    [but setImage:image forState:UIControlStateHighlighted];
    [but setTitle:title forState:UIControlStateNormal];
    [but setTitleColor:titleColor forState:UIControlStateNormal];
    but.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [but addTarget:self action:@selector(st_leftBarAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:but];
    self.navigationItem.leftBarButtonItem = left;
}
- (void)st_setRightItemWithTitle:(NSString *)title
{
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(st_rightBarAction:)];
    right.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = right;
}
- (void)st_setRightItemWithTitle:(NSString *)title titleColor:(UIColor*)color
{
    UIBarButtonItem * right =[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(st_rightBarAction:)];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil] forState:UIControlStateHighlighted];
    right.tintColor = color;
    self.navigationItem.rightBarButtonItem = right;
}
- (void)st_setRightItemWithImage:(UIImage *)image
{
    UIImage * editimgae = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * rightImage = [[UIBarButtonItem alloc]initWithImage:editimgae style:UIBarButtonItemStyleDone target:self action:@selector(st_rightBarAction:)];
    self.navigationItem.rightBarButtonItem = rightImage;
}
- (void)st_setRightItemWithImage:(UIImage *)image andwithTitle:(NSString *)title
{
    UIButton * but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
    [but setImage:image forState:UIControlStateNormal];
    [but setTitle:title forState:UIControlStateNormal];
    [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //but.contentEdgeInsets=UIEdgeInsetsMake(0, -20, 0, 25);
    [but addTarget:self action:@selector(st_rightBarAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:but];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)st_setLeftItemWithView:(UIView *)view
{
    UIBarButtonItem * left =[[UIBarButtonItem alloc]initWithCustomView:view];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(st_leftBarAction:)];
    [view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem=left;
}

- (void)st_setRightItemWithView:(UIView *)view
{
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:view];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(st_rightBarAction:)];
    [view addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)st_setNavgationTitleColor:(UIColor *)titleColor
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:titleColor
       }
     ];
}
- (void)st_setNavgationBarColor:(UIColor *)barColor
{
    // 层级图
    //                                                    UIVisualEffectBackDropView
    //                            UIVieualEffectView ---> UIVisualEffectFilter(灰色)
    // nav --》UIBarBackground -->UiiamgeView(黑线)        UIVisualEffectFilter
    //         leftbar
    //         titleView
    //         rigthtBar
    //第一个subview 就是 UIBarBackground
    //尝试遍历修改子控件颜色，无效，移除
    
    UINavigationBar * navBar = self.navigationController.navigationBar;
    navBar.translucent = NO;//关闭透明
    navBar.barTintColor = barColor;
    navBar.backgroundColor = barColor;
}
- (void)st_rightBarAction:(id)sender
{
    
}
- (void)st_leftBarAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)st_showNavagationbarAnimated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)st_hideNavagetionbarAnimated:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (UIImageView *)st_findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self st_findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
