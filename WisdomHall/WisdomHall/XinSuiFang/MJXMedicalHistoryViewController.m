//
//  MJXMedicalHistoryViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/13.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXMedicalHistoryViewController.h"
#import "MJXRootViewController.h"
#import "MJXMedicalHistoryTableViewCell.h"
#import "MJXEditTheTextViewController.h"
@interface MJXMedicalHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong)NSMutableArray *textFiledText;
@property (nonatomic,strong)NSMutableArray *placeholderText;
@end

@implementation MJXMedicalHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"病史详情"];
    [self addBackButton];
    
    [self getData];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view.
}
-(void)getData{
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"确定诊断",@"主诉",@"现病史",@"既往史",@"个人史",@"婚育史",@"家族史",@"体格检查",@"辅助检查", nil];
    _placeholderText = [[NSMutableArray alloc] initWithObjects:@"请输入诊断信息",@"请输入主诉信息",@"请输入现病史信息",@"请输入既往史信息",@"请输入个人史信息",@"请输入婚育史信息",@"请输入家族史信息",@"请输入体格检查信息",@"请输入辅助检查信息", nil];
    _textFiledText = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<9; i++) {
        [_textFiledText setObject:@"" atIndexedSubscript:i];
    }

}
-(void)addBackButton{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image = [UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    UIButton *save=[UIButton buttonWithType:UIButtonTypeCustom];
    save.frame=CGRectMake(APPLICATION_WIDTH-70,20,60, 44);
    [save setTitle:@"保 存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    save.titleLabel.font=[UIFont systemFontOfSize:15];
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
-(void)save{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/patient/saveMedicalRecordDetails",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"patientId":_patients.patientId,
                                  @"qdzd":_textFiledText[0],
                                  @"zz":_textFiledText[1],
                                  @"xbs" :_textFiledText[2],
                                  @"jws":_textFiledText[3],
                                  @"grs":_textFiledText[4],
                                  @"hys":_textFiledText[5],
                                  @"jzs":_textFiledText[6],
                                  @"tgjc":_textFiledText[7],
                                  @"fzjc":_textFiledText[8]
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSLog(@"1");
                                      id data = [responseObject objectForKey:@"result"];
                                      if (![data isEqual:@""]) {
                                          _medicaid = [data objectForKey:@"result"];
                                          if (self.returnTextBlock != nil) {
                                              self.returnTextBlock(_medicaid);
                                          }
                                      }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"0");

    }];
    [self back];
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
    return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXMedicalHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXMedicalHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#fefefe"];
    }
    
    
    [cell addCellViewWithLabelText:_titleArray[indexPath.row] withTextFieldP:_placeholderText[indexPath.row] withTextFieldText:_textFiledText[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MJXEditTheTextViewController *eVC = [[MJXEditTheTextViewController alloc] init];
    eVC.titleStr = _titleArray[indexPath.row];
    eVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:eVC animated:YES];
  
    
    [eVC returnText:^(NSString *showText) {
        [_textFiledText setObject:showText atIndexedSubscript:indexPath.row];
        [self.tableView reloadData];
    }];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
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
