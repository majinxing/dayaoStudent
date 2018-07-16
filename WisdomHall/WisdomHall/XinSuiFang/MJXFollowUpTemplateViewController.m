//
//  MJXFollowUpTemplateViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/20.
//  Copyright © 2016年 majinxing. All rights reserved.
//随访模板

#import "MJXFollowUpTemplateViewController.h"
#import "MJXFollowUpTemplateInfoViewController.h"
#import "MJXTemplateNameTableViewCell.h"
#import "MJXRootViewController.h"
@interface MJXFollowUpTemplateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *ary;
@end

@implementation MJXFollowUpTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    
    _ary = [[NSArray alloc] initWithObjects:@"心衰",@"心肌炎",@"糖尿病高血压并发症", nil];
    
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"随访模板"];
    
    [self addBackButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view.
}
-(void)addBackButton{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image = [UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXTemplateNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXTemplateNameTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    //cell.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
//    cell.textLabel.text = _ary[indexPath.row];
    [cell setTemplateName:_ary[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MJXFollowUpTemplateInfoViewController *fInfo = [[MJXFollowUpTemplateInfoViewController alloc] init];
    fInfo.templateName = _ary[indexPath.row];
    fInfo.whetherTemplate = YES;
    fInfo.patients = _patients;
    fInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fInfo animated:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
