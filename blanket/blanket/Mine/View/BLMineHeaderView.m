//
//  BLMineHeaderView.m
//  blanket
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "BLMineHeaderView.h"
@interface BLMineHeaderView()
@property(nonatomic, strong) STButton                     *iconButton;
@property(nonatomic, strong) STButton                     *vipButton;
@property(nonatomic, strong) STLabel                     *nickNameLable;

@property(nonatomic, strong) STLabel                     *willPaybadgeValueLable;
@property(nonatomic, strong) STLabel                     *willFahuobadgeValueLable;
@property(nonatomic, strong) STLabel                     *willShouhuobadgeValueLable;
@property(nonatomic, strong) STLabel                     *willCommentbadgeValueLable;
@end
@implementation BLMineHeaderView

#pragma mark --subView
- (void)configSubView{
    __weak typeof(self) weakSelf =  self;
    self.backgroundColor = BL_backgroundColor;
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 110)];
    topView.backgroundColor = BL_BlueBackGroundColor;
    self.iconButton = [[STButton alloc] initWithFrame:CGRectMake(15, 15, 76, 76)
                                                     title:nil
                                                titleColor:nil
                                                 titleFont:0
                                              cornerRadius:38
                                           backgroundColor:nil
                                           backgroundImage:[UIImage imageNamed:@"个人头像"]
                                                     image:nil];
    [topView addSubview:self.iconButton];
    
    self.nickNameLable = [[STLabel alloc] initWithFrame:CGRectMake(12 + _iconButton.right, 32, 100, 16)
                                                     text:@"~~stoneobs"
                                                textColor:[UIColor whiteColor]
                                                     font:15
                                              isSizetoFit:NO
                                          textAlignment:NSTextAlignmentLeft];
    [topView addSubview:self.nickNameLable];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.nickNameLable.left, self.nickNameLable.bottom + 10, 78, 21)];
    imageView.image = [UIImage imageNamed:@"金牌会员"];
    [topView addSubview:imageView];
    
    STButton * settingButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)
                                                     title:nil
                                                titleColor:nil
                                                 titleFont:0
                                              cornerRadius:0
                                           backgroundColor:nil
                                           backgroundImage:nil
                                                         image:[UIImage imageNamed:@"设置"]];
    settingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    settingButton.centerY = self.nickNameLable.centerY;
    settingButton.right = topView.width - 48;
    [settingButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedSettingButton];
    }];
    [topView addSubview:settingButton];
    [self addSubview:topView];
    
    UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom + 10, UIScreenWidth, 44 + 80 + 1)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [whiteView st_showTopLine];
    [whiteView st_showBottomLine];
    [self addSubview:whiteView];
    
    STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)
                                                     text:@"我的订单"
                                                textColor:BL_firstTextColor
                                                     font:15
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentLeft];
    [whiteView addSubview:titleLable];
    
    STButton * allButton = [[STButton alloc] initWithFrame:CGRectMake(titleLable.right, 0, UIScreenWidth - 15 - titleLable.right, 44)
                                                     title:@"  查看全部订单  "
                                                titleColor:BL_secendTextColor
                                                 titleFont:12
                                              cornerRadius:0
                                           backgroundColor:nil
                                           backgroundImage:nil
                                                     image:[UIImage imageNamed:@"查看订单"]];
    allButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [allButton makeImageRight];
    [allButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelectedAllButton];
    }];
    [whiteView addSubview:allButton];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, titleLable.bottom, UIScreenWidth, 0.5)];
    line.backgroundColor = BL_lineColor;
    [whiteView addSubview:line];
    //底部
    UIControl * daifukuan = [self controlWithImageName:@"待付款" title:@"待付款" tag:10001];
    daifukuan.st_left = 0;
    [whiteView addSubview:daifukuan];
    UIControl * daifahuo = [self controlWithImageName:@"待发货" title:@"待发货" tag:10002];
    daifahuo.st_left = 0 + UIScreenWidth / 4;
    [whiteView addSubview:daifahuo];
    UIControl * daishouhuo = [self controlWithImageName:@"待收货" title:@"待收货" tag:10003];
    daishouhuo.st_left = 0 + 2 * UIScreenWidth / 4;
    [whiteView addSubview:daishouhuo];
    UIControl * daipingjia = [self controlWithImageName:@"待评价38" title:@"待评价" tag:10004];
    daipingjia.st_left = 0 + 3 * UIScreenWidth / 4;
    [whiteView addSubview:daipingjia];

    self.height = whiteView.bottom;
}
- (UIControl*)controlWithImageName:(NSString*)imageName title:(NSString*)title tag:(NSInteger)tag{
    UIControl * control = [[UIControl alloc] initWithFrame:CGRectMake(0, 45, UIScreenWidth / 4, 80)];
    control.backgroundColor = [UIColor whiteColor];
    control.tag = tag;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22, 24, 24 )];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.st_centerX = control.st_width / 2;
    [control addSubview:imageView];
    STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(0, imageView.st_bottom + 10, control.st_width, 13)
                                                     text:title
                                                textColor:BL_firstTextColor
                                                     font:12
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentCenter];
    [control addSubview:titleLable];
    [control addTarget:self action:@selector(onSelectedOrderControl:) forControlEvents:UIControlEventTouchUpInside];
    STLabel * badgeValeLable = [[STLabel alloc] initWithFrame:CGRectMake(imageView.right - 6, 0, 20, 14)
                                                         text:@""
                                                    textColor:[UIColor whiteColor]
                                                         font:10
                                                  isSizetoFit:NO
                                                textAlignment:NSTextAlignmentCenter];
    badgeValeLable.bottom = imageView.top + 6;
    badgeValeLable.layer.cornerRadius = 6;
    badgeValeLable.clipsToBounds = YES;
    badgeValeLable.backgroundColor = BL_redColor;
    badgeValeLable.hidden = YES;
    [control addSubview:badgeValeLable];
    
    if (tag == 10001) {
        self.willPaybadgeValueLable = badgeValeLable;
    }
    if (tag == 10002) {
        self.willFahuobadgeValueLable = badgeValeLable;
    }
    if (tag == 10003) {
        self.willShouhuobadgeValueLable = badgeValeLable;
    }
    if (tag == 10004) {
        self.willCommentbadgeValueLable = badgeValeLable;
    }
    return control;
}
#pragma mark --Action Method
- (void)onSelectedIconButton{
    if (self.delegate && [self.delegate  respondsToSelector:@selector(onSelectedIconButton)]) {
        [self.delegate onSelectedIconButton];
    }
}
- (void)onSelectedSettingButton{
    if (self.delegate && [self.delegate  respondsToSelector:@selector(onSelectedSettingButton)]) {
        [self.delegate onSelectedSettingButton];
    }
}
- (void)onSelectedAllButton{
    if (self.delegate && [self.delegate  respondsToSelector:@selector(onSelectedAllButton)]) {
        [self.delegate onSelectedAllButton];
    }
}
- (void)onSelectedChongzhiButton:(UIButton*)sender{
    if (self.delegate && [self.delegate  respondsToSelector:@selector(onSelectedChongzhiButton)]) {
        [self.delegate onSelectedChongzhiButton];
    }
}
- (void)onSelectedTiXianButton:(UIButton*)sender{
    if (self.delegate && [self.delegate  respondsToSelector:@selector(onSelectedTiXianButton)]) {
        [self.delegate onSelectedTiXianButton];
    }
}
- (void)onSelectedOrderControl:(UIControl*)control{
    NSString * title;
    if (control.tag == 10001) {
        title = @"待付款";
    }
    if (control.tag == 10002) {
        title = @"待发货";
    }
    if (control.tag == 10003) {
        title = @"待收货";
    }
    if (control.tag == 10004) {
        title = @"待评价";
    }
    if (control.tag == 10005) {
        title = @"已完成";
    }
    if (self.delegate && [self.delegate  respondsToSelector:@selector(onSlectedOrderButton:)]) {
        [self.delegate onSlectedOrderButton:title];
    }
}
@end
