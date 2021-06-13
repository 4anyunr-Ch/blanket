//
//  KLSettingViewController.m
//  blanket
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "BLSettingViewController.h"
#import "STPhotoUrlImageBrowerController.h"
@interface BLSettingViewController ()<STPhotoUrlImageBrowerControllerDelegate>
@property(nonatomic, strong) NSArray  <STTableEasyModel*>                   *dataSouce;
@property(nonatomic, strong) STButton                     *iconButton;
@property(nonatomic, strong) UISwitch                     *messageSwitch;
@end

@implementation BLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    [self configSubView];
    [self reloadData];
    // Do any additional setup after loading the view.
}
#pragma mark --subView
- (void)configSubView{
    self.iconButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)
                                                     title:nil
                                                titleColor:nil
                                                 titleFont:0
                                              cornerRadius:20
                                           backgroundColor:nil
                                           backgroundImage:[UIImage imageNamed:@"个人头像"]
                                                     image:nil];
    
    self.messageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.messageSwitch.onTintColor = BL_BlueBackGroundColor;
    
}
- (void)reloadData{
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    STTableEasyModel * versionModel = [[STTableEasyModel alloc] initWithTextString:@"当前版本"
                                                                      detailString:[NSString stringWithFormat:@"v%@",version]];
    NSArray * sectionOne = @[
                             [[STTableEasyModel alloc] initWithTextString:@"头像" accessoryView:self.iconButton],
                             [[STTableEasyModel alloc] initWithTextString:@"昵称" detailString:@""],
                             [[STTableEasyModel alloc] initWithTextString:@"修改密码" detailString:@""],
                             [[STTableEasyModel alloc] initWithTextString:@"服务评价" detailString:@""],
                             [[STTableEasyModel alloc] initWithTextString:@"意见反馈" detailString:@""],
                             versionModel,
                             [[STTableEasyModel alloc] initWithTextString:@"消息推送" accessoryView:self.messageSwitch]];
    
    
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
    
    return 24;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseIdentifier =  @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        
    }
    cell.textLabel.textColor = UIColorFromRGBA(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = UIColorFromRGBA(0x999999);
    
    STTableEasyModel * model = self.dataSouce[indexPath.row];
    cell.textLabel.text = model.textString;
    cell.detailTextLabel.text = model.detailString;
    if (model.accessoryView) {
        cell.accessoryView = model.accessoryView;
    }else{
        cell.accessoryType = model.accessoryType;
    }
    return cell;
}
#pragma --mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self onSelectedIconCell];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)onSelectedIconCell{
    STUrlPhotoModel * model = [STUrlPhotoModel new];
    model.thumbImage = self.iconButton.currentBackgroundImage;
    STPhotoUrlImageBrowerController * vc = [[STPhotoUrlImageBrowerController alloc] initWithArray:@[model] curentIndex:0];
    vc.STPhotoUrlImageBrowerControllerdelegate = self;
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark --STPhotoUrlImageBrowerControllerDelegate
- (UIView*)STPhotoSystemBrowserControllerDidScrollToIndexpath:(NSIndexPath*)indexPath model:(STUrlPhotoModel*)model{
    return self.iconButton;
}
@end
