//
//  GHXingXingView.m
//  GodHorses
//
//  Created by Mac on 2017/11/21.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STXingXIngView.h"
#define tagBase 10000
@interface STXingXIngView()
@property(nonatomic, strong) NSMutableArray                     *buttonArray;
@property(nonatomic, assign) NSInteger                          maxsNum;
@end
@implementation STXingXIngView

- (instancetype)initWithFrame:(CGRect)frame maxsNum:(NSInteger)maxsNum{
    if (self == [super initWithFrame:frame]) {
        self.maxsNum = maxsNum;
        [self configSubView];
    }
    return self;
}
#pragma mark --subView
- (void)configSubView{
    self.buttonArray = [NSMutableArray new];
    for (int i = 0; i< self.maxsNum; i++) {
        STButton * xingxingButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)
                                                              title:nil
                                                         titleColor:nil
                                                          titleFont:0
                                                       cornerRadius:0
                                                    backgroundColor:nil
                                                    backgroundImage:nil
                                                              image:[UIImage imageNamed:@"weixuanzhong"]];
        xingxingButton.tag = i + tagBase;
        xingxingButton.centerY = self.height / 2;
        xingxingButton.left = 22* i;
        [xingxingButton setImage:[UIImage imageNamed:@"yixuanzhong"] forState:UIControlStateSelected];
        xingxingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [xingxingButton addTarget:self action:@selector(onSelectedXingXingButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:xingxingButton];
        [self addSubview:xingxingButton];
    }
}
#pragma mark --Action Method
- (void)onSelectedXingXingButton:(UIButton*)sender{
    
    for (UIButton * button in self.buttonArray) {
        if (button.tag <= sender.tag ) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    self.chosedNum = sender.tag - tagBase + 1;
}
- (void)makeXingXingSelectedWithNum:(NSInteger)num{
    NSInteger tag = num - 1 + tagBase;
    for (UIButton * button in self.buttonArray) {
        if (button.tag <= tag) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    self.chosedNum = num + 1;
}
@end


