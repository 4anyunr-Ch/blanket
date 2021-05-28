//
//  STRadioButton.m
//  STTools
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STRadioButton.h"
@interface STRadioButton()
@property(nonatomic,strong)NSMutableArray<UIButton*>        *butArray;
@end
@implementation STRadioButton
- (void)dealloc
{

}
-(instancetype)initWithRadio:(NSArray <NSString*>*)array andWithFrame:(CGRect)frame

{
    if (self=[super initWithFrame:frame]) {
        NSInteger num = array.count;
        _count = num;
        self.butArray = [[NSMutableArray alloc]init];
        self.checkedNum = [NSNumber numberWithInt:0];
        for (int i=0; i<num; i++) {
            UIButton * but = [[UIButton alloc]initWithFrame:CGRectMake(i*frame.size.width/array.count, 10, frame.size.width/array.count, frame.size.height-20)];
            [but setImage:[UIImage imageNamed:@"购物选中"] forState:UIControlStateSelected];
            [but setImage:[UIImage imageNamed:@"购物未选中"] forState:UIControlStateNormal];
            [but setTitle:array[i] forState:UIControlStateNormal];
            [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(clic:) forControlEvents:UIControlEventTouchUpInside];
            but.tag = i;
            but.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 6);
            [but.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [self addSubview:but];
            [self.butArray addObject:but];
            
        }
        
    }
    return self;
}
-(void)clic:(id)sender
{
    UIButton * but= sender;
    int num = (int)[sender tag];
    for (int i = 0; i<num; i++) {
        self.butArray[i].selected = NO;
        
    }
    for (int k=num; k<self.count; k++) {
        self.butArray[k].selected = NO;
    }
    self.checkedString = self.butArray[num].titleLabel.text;
    self.checkedNum = [NSNumber numberWithInteger:num];
    but.selected = !but.selected;
    //NSLog(@"%@",self.checkedString);
    if (self.actionHandle) {
        self.actionHandle(num);
    }
}
#pragma mark --Getter And Setter
-(void)setMakenumOfarrayChecked:(NSInteger)makenumOfarrayChecked
{
    UIButton * but =self.butArray[makenumOfarrayChecked];
    but.selected = YES;
    _makenumOfarrayChecked = makenumOfarrayChecked;
    _checkedString = but.currentTitle;
    _checkedNum = [NSNumber numberWithInteger:makenumOfarrayChecked];
}
-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    for (UIButton * but in self.butArray) {
        [but setTitleColor:titleColor forState:UIControlStateNormal];
    }
}
-(void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    for (UIButton * but in self.butArray) {
        [but setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }

}
@end
