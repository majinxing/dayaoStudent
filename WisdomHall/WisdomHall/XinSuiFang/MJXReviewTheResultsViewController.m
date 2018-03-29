 //
//  MJXReviewTheResultsViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/26.
//  Copyright © 2016年 majinxing. All rights reserved.
//查看复查结果

#import "MJXReviewTheResultsViewController.h"
#import "MJXRootViewController.h"
#import "MJXPatientsNodeInfoTableViewCell.h"
@interface MJXReviewTheResultsViewController ()<UITableViewDelegate,UITableViewDataSource,MJXPatientsNodeInfoTableViewCellDelegate,UITextViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * ary;
@property (nonatomic,strong)NSMutableDictionary * dict;
@property (nonatomic,copy) NSString * message;
@end

@implementation MJXReviewTheResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _message = [[NSString alloc] init];
    _dict = [[NSMutableDictionary alloc] init];
    
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"复查结果"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackButton];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self getData];
    _ary = [[NSMutableArray alloc] initWithObjects:@"http://120.27.29.242:8081/images/5f490522629f4825997d2e06dd081e321476678680382L.jpg",@"http://120.27.29.242:8081/images/4a9d0b28532e40009d9106bd8dcdac801476678922219L.jpg",@"http://120.27.29.242:8081/images/fe11189dcd84477c95f40f59ff68f6b31476678950868L.jpg",@"http://120.27.29.242:8081/images/1f535cd58df94632a33a13bafbcac6e91476678968036L.jpg",@"http://120.27.29.242:8081/images/6c0b65dd9f2b43268c62d8e8783781701476678985608L.jpg",@"http://120.27.29.242:8081/images/4cd265a478664a35828d6d0a2ca04be21476679003514L.jpg", nil];
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
-(void)getData{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/followup/findReviewResults",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"patientId":_patients.patientId,
                                  @"nodeId" : _patients.nodeId
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          _dict = [responseObject objectForKey:@"result"][0];
                                          [_tableView reloadData];
                                      }
                                      
                                      NSLog(@"1");
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"0");
                                  }];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{

}
#pragma mark MJXPatientsNodeInfoTableViewCellDelegate
-(void)sendInfoBtnPressed{

}
-(void)selectTheFeedbackPressed:(UIButton *)btn{

    
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatientsNodeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXPatientsNodeInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        [cell setInitializeDataWithPatient:_patients];
    }else if (indexPath.section == 1){
        NSString *time = [_dict objectForKey:@"createTime"];
        NSArray * array = [_dict objectForKey:@"medicalDocType_list"];
        NSMutableArray * ary = [[NSMutableArray alloc] init];
        NSString * description = [NSString stringWithFormat:@""];
        if (![array isKindOfClass:[NSNull class]]&&array!=nil&&array.count>0) {
            NSDictionary * dict = [_dict objectForKey:@"medicalDocType_list"][0];

            ary = [[dict objectForKey:@"imagesL"]componentsSeparatedByString:@","];
            description =[dict objectForKey:@"description"];

        }
        
        
        
        [cell addPatientsInfoWithTemplateName:_patients.tempLateName withTime:time withImageArray:ary withIllnessDescription:description];
        cell.handleVC = self;
        cell.textView.delegate = self;
    }else if (indexPath.section == 2){
        [cell feedback];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  60;
    }else if (indexPath.section == 1){
        MJXPatientsNodeInfoTableViewCell *cell = (MJXPatientsNodeInfoTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }else if (indexPath.section == 2){
        return 200;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
