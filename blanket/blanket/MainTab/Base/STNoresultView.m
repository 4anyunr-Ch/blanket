//
//  STNoresultView.m
//  KunLun
//
//  Created by Mac on 2017/11/27.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STNoresultView.h"

@implementation STNoresultView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                  buttonTitle:(NSString *)buttonTitle
                 buttonHandle:(void (^)(NSString *))handle{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 214, 162)];
        iconImageView.image = [UIImage imageNamed:@"缺省页"];
        iconImageView.st_centerX = self.st_width / 2 - 15;
        [self addSubview:iconImageView];
        
        STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(0, iconImageView.st_bottom + 13, self.st_width, 15)
                                                         text:title
                                                    textColor:KL_firstTextColor
                                                         font:14
                                                  isSizetoFit:NO
                                                textAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLable];
        
        STButton * buyButton = [[STButton alloc] initWithFrame:CGRectMake(0, titleLable.st_bottom + 15, 125, 44)
                                                         title:buttonTitle
                                                    titleColor:FirstTextColor
                                                     titleFont:14
                                                  cornerRadius:5
                                               backgroundColor:BackgroundColor
                                               backgroundImage:nil
                                                         image:nil];
        buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [buyButton st_setBorderWith:1 borderColor:KL_BlueBackGroundColor cornerRadius:5];
        buyButton.st_centerX = self.st_width / 2;
        [buyButton setClicAction:^(UIButton *sender) {
            if (handle) {
                handle(sender.currentTitle);
            }
        }];
        [self addSubview:buyButton];
        self.clipsToBounds = YES;
        self.st_centerX = UIScreenWidth / 2;
        
        buyButton.hidden = !buttonTitle.length;
    }
    return self;
}
@end
