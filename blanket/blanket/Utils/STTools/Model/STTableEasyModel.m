//
//  STTableEasyModel.m
//  GodHorses
//
//  Created by Mac on 2017/11/25.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STTableEasyModel.h"

@implementation STTableEasyModel
- (instancetype)initWithTextString:(NSString *)textString detailString:(NSString *)detailString
{
    if (self = [super init]) {
        self.detailString = detailString;
        self.textString = textString;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.height = 44;
    }
    return self;
}
- (instancetype)initWithTextString:(NSString*)textString accessoryView:(UIView*)accessoryView;
{
    if (self = [super init]) {
        self.accessoryView = accessoryView;
        self.textString = textString;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.height = 44;
    }
    return self;
    
}
- (instancetype)initWithTextString:(NSString *)textString
                      detailString:(NSString *)detailString
                     accessoryType:(UITableViewCellAccessoryType)accessoryType{
    
    if (self = [super init]) {
        self.detailString = detailString;
        self.textString = textString;
        self.accessoryType = accessoryType;
        self.height = 44;
    }
    return self;
    
}
- (instancetype)initWithTextString:(NSString *)textString imageName:(NSString *)imageName{
    if (self = [super init]) {
        
        self.textString = textString;
        self.image   = [UIImage imageNamed:imageName];
        self.height = 44;
    }
    return self;
}
@end
