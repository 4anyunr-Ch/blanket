//
//  BLMineTableViewCell.m
//  blanket
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "BLMineTableViewCell.h"

@implementation BLMineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSubView];
    }
    return self;
}
#pragma mark --subView
- (void)configSubView{
    self.ghImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 22, 22)];
    self.ghImageView.st_centerY = 23;
    [self addSubview:self.ghImageView];
    
    STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(self.ghImageView.st_right + 10, 0, 300, 44)
                                                     text:@""
                                                textColor:BL_firstTextColor
                                                     font:14
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentLeft];
    self.lable = titleLable;
    [self addSubview:titleLable];
    
}
@end
