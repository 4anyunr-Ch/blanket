//
//  BLMineHeaderView.h
//  blanket
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMBaseView.h"
@protocol BLMineHeaderViewDelegate <NSObject>
@optional;
- (void)onSelectedIconButton;
- (void)onSelectedSettingButton;
- (void)onSelectedAllButton;
- (void)onSelectedChongzhiButton;
- (void)onSelectedTiXianButton;
- (void)onSlectedOrderButton:(NSString*)title;
@end
@interface BLMineHeaderView : TMBaseView
@property(nonatomic, weak) id<BLMineHeaderViewDelegate>                   delegate;
@end
