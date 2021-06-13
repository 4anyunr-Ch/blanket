//
//  BLMineViewController.m
//  blanket
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "BLMineViewController.h"
#import "BLMineHeaderView.h"
#import "BLMineTableViewCell.h"
#import "BLSettingViewController.h"
@interface BLMineViewController ()<BLMineHeaderViewDelegate>
@property(nonatomic, strong) BLMineHeaderView                     *header;
@property(nonatomic, strong) NSArray  <STTableEasyModel*>                   *dataSouce;
@end

@implementation BLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self configSubView];
    [self reloadData];
    // Do any additional setup after loading the view.
}

#pragma mark --subView
- (void)configSubView{
    
    self.header = [[BLMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 10)];
    self.header.delegate = self;
    self.tableView.tableHeaderView = self.header;
}
- (void)reloadData{
    
    NSArray * sectionOne = @[
                             [[STTableEasyModel alloc] initWithTextString:@"申请洗涤业务" imageName:@"洗涤图标-2"],
                             [[STTableEasyModel alloc] initWithTextString:@"申请定制业务" imageName:@"定制"],
                             [[STTableEasyModel alloc] initWithTextString:@"优惠券" imageName:@"优惠券(3)"],
                             [[STTableEasyModel alloc] initWithTextString:@"服务评价" imageName:@"服务评价"],
                             [[STTableEasyModel alloc] initWithTextString:@"购物车" imageName:@"购物车2"],
                             [[STTableEasyModel alloc] initWithTextString:@"收货地址" imageName:@"地址(3)"],
                             [[STTableEasyModel alloc] initWithTextString:@"发票邮寄地址" imageName:@"发票"]];
    
    
    self.dataSouce = sectionOne;
    [self.tableView reloadData];
}
#pragma --mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSouce.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseIdentifier =  @"cell";
    BLMineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[BLMineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    STTableEasyModel * model = self.dataSouce[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.ghImageView.image = model.image;
    cell.lable.text = model.textString;
    return cell;
}
#pragma --mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark --BLMineHeaderViewDelegate
- (void)onSelectedIconButton{
    
}
- (void)onSelectedSettingButton{
    
    [self.navigationController pushViewController:[BLSettingViewController new] animated:YES];
}
- (void)onSelectedAllButton{
    
}

- (void)onSlectedOrderButton:(NSString*)title{
    
}
@end

