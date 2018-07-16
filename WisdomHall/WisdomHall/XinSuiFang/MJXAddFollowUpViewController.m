//
//  MJXAddFollowUpViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/19.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXAddFollowUpViewController.h"
#import "MJXRootViewController.h"
#import "MJXFollowUpTemplateViewController.h"
#import "MJXFollowUpTemplateInfoViewController.h"
#import "MJXTemplateNameTableViewCell.h"
#import "MJXTemplate.h"
@interface MJXAddFollowUpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary *dict;
@property (nonatomic,strong)NSMutableDictionary *dictId;
@end

@implementation MJXAddFollowUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dict = [[NSMutableDictionary alloc] init];
    _dictId = [[NSMutableDictionary alloc] init];
    [MJXUIUtils addNavigationWithView:self.view withTitle:_titleStr];
    [self addBackButton];
    if ([_titleStr isEqualToString:@"添加随访"]) {
        [self addContentView];
    }else if([_titleStr isEqualToString:@"修改随访"]){
        [self addContentView];
    }
    
    [self getData];
    // Do any additional setup after loading the view.
    
    
}
-(void)getData{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/followup/findMyTemplate",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone]
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSArray *ary = [responseObject objectForKey:@"result"];
                                      for (int i=0; i<ary.count; i++) {
                                          NSMutableArray *ary1 = [NSMutableArray arrayWithCapacity:10];
                                          NSString *name = [ary[i] objectForKey:@"name"];
                                          NSArray *array = [ary[i] objectForKey:@"node"];
                                        [_dictId setValue:[ary[i] objectForKey:@"followupId"] forKey:name];
                                          
                                          for (int j=0; j<array.count; j++) {
                                              MJXTemplate *one = [[MJXTemplate alloc] init];
                                              one.advice = [array[j] objectForKey:@"content"];
                                              [self returnSendDateWithSendDate:[array[j] objectForKey:@"sendDate"] withTemplate:one];
                                              [ary1 setObject:one atIndexedSubscript:j];
                                          }
                                          [_dict setValue:ary1 forKey:name];
                                      }
                                      [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"0");

    }];
}
-(void)returnSendDateWithSendDate:(NSString *)sendData withTemplate:(MJXTemplate *)one{
    NSString *temp2 = [sendData substringFromIndex:[sendData length]-1];
    one.timeStr = temp2;
    if ([temp2 isEqualToString:@"Y"]) {
        one.timeYear =  [sendData substringToIndex:[sendData length]-1];
    }else if ([temp2 isEqualToString:@"M"]) {
        one.timeMonth =  [sendData substringToIndex:[sendData length]-1];
    }else if ([temp2 isEqualToString:@"W"]) {
        one.timeWeeks =  [sendData substringToIndex:[sendData length]-1];
    }else if ([temp2 isEqualToString:@"D"]) {
        one.timeDay =  [sendData substringToIndex:[sendData length]-1];
    }
}
-(void)addContentView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}
-(void)addBackButton{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image = [UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
//    UIButton *save=[UIButton buttonWithType:UIButtonTypeCustom];
//    save.frame=CGRectMake(APPLICATION_WIDTH-70,20,60, 44);
//    [save setTitle:@"保 存" forState:UIControlStateNormal];
//    [save setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
//    save.titleLabel.font=[UIFont systemFontOfSize:15];
//    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:save];
    
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
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else if (section==1){
        return _dict.count+1;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXTemplateNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXTemplateNameTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0&&indexPath.row==0) {
        [cell setUserTemplateWithImage:@"muban" withTitleText:@"使用随访模板"];
    }
    if (indexPath.section==0&&indexPath.row==1) {
        [cell setUserTemplateWithImage:@"zidingyi" withTitleText:@"自定义随访模板"];
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            [cell setTemplateName:@"我的随访方案"];
        }else{
        [cell setTemplateName:[_dict allKeys][indexPath.row-1]];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0) {
        MJXFollowUpTemplateViewController *FVC = [[MJXFollowUpTemplateViewController alloc] init];
        FVC.patients = _patients;
        FVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:FVC animated:YES];
    }
    if (indexPath.section==0&&indexPath.row==1) {
        MJXFollowUpTemplateInfoViewController *fUTInfo = [[MJXFollowUpTemplateInfoViewController alloc] init];
        fUTInfo.patients = _patients;
        fUTInfo.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:fUTInfo animated:YES];
    }
    if (indexPath.section==1&&indexPath.row>0) {
        MJXFollowUpTemplateInfoViewController *fUTInfo = [[MJXFollowUpTemplateInfoViewController alloc] init];
        fUTInfo.patients = _patients;
        fUTInfo.whetherTemplate = YES;
        MJXTemplateNameTableViewCell *cell = (MJXTemplateNameTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        fUTInfo.timeAdviceArray = [NSMutableArray arrayWithCapacity:10];
        
        fUTInfo.timeAdviceArray = [_dict objectForKey:cell.templateName];
        
        fUTInfo.templateName = cell.templateName;
        fUTInfo.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:fUTInfo animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//指定行是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row>0) {
        return YES;
    }
    return NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJXTemplateNameTableViewCell *cell = (MJXTemplateNameTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *followUp = [NSString stringWithFormat:@"%@",[_dictId objectForKey:cell.templateName]];
    
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/followup/deleteMyTemplate",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"templateId" :followUp
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                         [_dictId removeObjectForKey:cell.templateName];
                                         [_dict removeObjectForKey:cell.templateName];
                                         [self showAlter];
                                         [_tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [MJXUIUtils show404WithDelegate:self];
                                 }];
}
-(void)showAlter{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"随访方案已删除"
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil, nil];
    [alert show];
	[alert dismissWithClickedButtonIndex:0 animated:YES];
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
