//
//  STTableViewController.m
//  SportClub
//
//  Created by stoneobs on 16/7/28.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_FRAME  [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define STBACKROUND_COLOR  STRGB(0xf1f2f7)

#import "STTableViewController.h"
@interface STTableViewController()

@end
@implementation STTableViewController
- (instancetype)init
{
    
    return [self initWithStyle:UITableViewStyleGrouped];
}
-(instancetype)initWithStyle:(UITableViewStyle )style
{
    if (self==[super init]) {
        
        [self loadTableViewWithStyle:style];
    }
    return self;
}
- (CGFloat)insetX
{
    //箭头大小（15，15）,detalilable 距离箭头固定5；
    if ([UIScreen mainScreen].bounds.size.width > 539) {
        return 20.0;//基本大于=6p的大小就20 ，其余15
    }
    return 15;
    
}
-(void)loadView
{
    [super loadView];
    [self.view addSubview:self.tableView];
}
- (void)loadTableViewWithStyle:(UITableViewStyle)style
{
    self.tableView = [[UITableView alloc] initWithFrame:SCREEN_FRAME style:style];
    if (!self.navigationController.navigationBar.translucent) {
        self.tableView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = STBACKROUND_COLOR;
    self.tableView.separatorColor = STRGB(0xe0e4e5);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self loadTableViewWithStyle:UITableViewStyleGrouped];
    }
    return self;
}
#pragma --mark UITableViewDataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier =  @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%lu",indexPath.row];
    cell.textLabel.textColor = STRGB(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = STRGB(0x999999);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma --mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

