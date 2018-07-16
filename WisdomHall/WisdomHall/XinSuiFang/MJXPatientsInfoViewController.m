//
//  MJXPatientsInfoViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/2.
//  Copyright © 2016年 majinxing. All rights reserved.
//病历夹主VC

#import "MJXPatientsInfoViewController.h"
#import "MJXPatientsInfoTableViewCell.h"
#import "MJXAddCourseOfDiseaseViewController.h"
#import "MJXRootViewController.h"
#import "MJXCourseOfDiseaseTableViewCell.h"
#import "MJXMedicalRecords.h"
#import "MJXAddFollowUpViewController.h"
#import "FMDBTool.h"
#import "MJXFollowUpPlanViewController.h"
#import "MJXPatientsWithSetViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "NSDate+Utilities.h"
#import "MJXAddPatientsViewController.h"
#import "MJXChatViewController.h"
#import "MJXEditTheDiagnosisViewController.h"
@interface MJXPatientsInfoViewController ()<UITableViewDelegate,UITableViewDataSource,courseOfDiseaseTableViewCellDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *medicalRecordsArry;//承载所有病程
@property (nonatomic,strong)UIView *moreView;
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) MBProgressHUD * HUD;
@property (nonatomic,strong)NSMutableDictionary * imageDrafDict;
@property (nonatomic,assign) int asign;
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) NSMutableDictionary * patientInfoDict;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,assign) int sign;
@end
@implementation MJXPatientsInfoViewController
-(void)dealloc{
    NSLog(@"%s",__func__);
}
-(void)viewDidDisappear:(BOOL)animated{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _sign = 6;
    _medicalRecordsArry = [NSMutableArray arrayWithCapacity:10];
    _imageDrafDict = [[NSMutableDictionary alloc] init];
    _patientInfoDict = [[NSMutableDictionary alloc] init];
    _phone = [[NSString alloc] init];
    
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"病历夹"];
    _asign = 0;
    [self addBackButton];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-100) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //加载更多数据
    __weak  typeof(self)vc = self;
    [_tableView addHeaderWithCallback:^{
        [vc headerRereshing];
    }];
    [_tableView addFooterWithCallback:^{
        [vc footerRereshing];
    }];
   // [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setAddDiagnosisButton];
    
    [self getAllPatientInfo];
    
    // [self getData];
    
    // Do any additional setup after loading the view.
}
-(void)headerRereshing{
    [self getPatientsInfo];
    [self getData];
    [_tableView reloadData];
}
-(void)footerRereshing{
    _sign = _sign + 6;
    [_tableView reloadData];
    [_tableView footerEndRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    if (_moreView) {
        [_moreView removeFromSuperview];
        _moreView = nil;
    }
    [self getPatientsInfo];
    if (_asign == 1) {
        [_tableView reloadData];
        [self getData];
    }
    _asign = 1;
}
-(void)getPatientsInfo{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url=[NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/patient/findPatient"];
    [manger POST:url parameters:@{
                                  @"username" : [[MJXAppsettings sharedInstance] getUserPhone]  ,
                                  @"patientId" : _patients.patientId
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          [_patients saveAllInfoPatient:[responseObject objectForKey:@"result"]];
                                      }
                                      [self.tableView reloadData];
                                      _patientInfoDict = [responseObject objectForKey:@"result"];
                                      // NSLog(@"1");
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"0");
                                  }];
}

//获取全部病程数据
-(void)getData{
    
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/patient/showSimpleMedicaRecord",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"patientId" : _patients.patientId,
                                  @"pageNum" : @"1",
                                  @"pageSize" : @"1000"
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self hide:0];
                                      
                                      [_tableView headerEndRefreshing];
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          id data = [responseObject objectForKey:@"result"];
                                          if (![data isKindOfClass:[NSString class]]) {
                                              _medicalRecordsArry = [responseObject objectForKey:@"result"];
                                              [self saveALLPatientsInfoWithArray:_medicalRecordsArry];
                                              [_tableView reloadData];
                                          }
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [self hide:0];
                                      [_tableView headerEndRefreshing];
                                      [_tableView reloadData];
                                      //[self getAllPatientInfo];
                                      
                                      NSLog(@"1");
                                  }];
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
-(void)setAddDiagnosisButton{
    UIButton *addDiagnosisButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addDiagnosisButton.frame=CGRectMake(0, APPLICATION_HEIGHT-59, APPLICATION_WIDTH,60);
    [addDiagnosisButton setBackgroundImage:[UIImage imageNamed:@"添加新病程"] forState:UIControlStateNormal];
    [addDiagnosisButton addTarget:self action:@selector(addDiagnosis) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addDiagnosisButton];
    
    UIImageView *consulting = [[UIImageView alloc] initWithFrame:CGRectMake(51.0/375.0*APPLICATION_WIDTH, 17, 24, 21)];
    consulting.image = [UIImage imageNamed:@"xiaoxi"];
    [addDiagnosisButton addSubview:consulting];
    
    UILabel *conLabel = [[UILabel alloc] initWithFrame:CGRectMake(41.0/375.0*APPLICATION_WIDTH, CGRectGetMaxY(consulting.frame)+5, 50, 11)];
    conLabel.font = [UIFont systemFontOfSize:11];
    conLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    conLabel.text = @"最近咨询";
    [addDiagnosisButton addSubview:conLabel];
    
    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    message.frame = CGRectMake(20, APPLICATION_HEIGHT-49, 100, 50);
    [message addTarget:self action:@selector(messageSend) forControlEvents:UIControlEventTouchUpInside];
    message.backgroundColor = [UIColor clearColor];
    [self.view addSubview:message];
    
    UIButton *patient = [UIButton buttonWithType:UIButtonTypeCustom];
    patient.frame = CGRectMake(APPLICATION_WIDTH-120, APPLICATION_HEIGHT-49, 100, 50);
    //[patient setTitle:@"更多" forState:UIControlStateNormal];
    [patient addTarget:self action:@selector(pat) forControlEvents:UIControlEventTouchUpInside];
    patient.backgroundColor = [UIColor clearColor];
    
    UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-75.0/375.0*APPLICATION_WIDTH, 17, 24, 21)];
    moreImage.image = [UIImage imageNamed:@"pguanli"];
    [addDiagnosisButton addSubview:moreImage];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-85.0/375.0*APPLICATION_WIDTH, CGRectGetMaxY(consulting.frame)+5, 50, 11)];
    moreLabel.font = [UIFont systemFontOfSize:11];
    moreLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    moreLabel.text = @"患者管理";
    [addDiagnosisButton addSubview:moreLabel];
    [self.view addSubview:patient];
    
}
-(void)messageSend{
    if (![_patients.targetId isKindOfClass:[NSNull class]]&&![_patients.targetId isEqualToString:@""]&&_patients.targetId!=nil) {
        
        MJXChatViewController * vc = [[MJXChatViewController alloc] init];
        vc.patients = _patients;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:[NSString stringWithFormat: @"您还没邀请%@成为您的可沟通患者，是否立即邀请？",_patients.patientsName]
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];
        
    }
    
}
-(void)pat{
    if (_moreView) {
        [_moreView removeFromSuperview];
        _moreView = nil;
        return;
    }
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT-50)];
    [self.view addSubview:_moreView];
    
    UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = _moreView.frame;
    b.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    b.alpha = 0.2;
    [b addTarget:self action:@selector(pat) forControlEvents:UIControlEventTouchUpInside];
    [_moreView addSubview:b];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-125, APPLICATION_HEIGHT-20-170, 115, 130)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [_moreView addSubview:buttonView];
    
    NSArray *ary = [NSArray arrayWithObjects:@"添加随访",@"随访计划",@"患者设置", nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"tjsf",@"sfjh",@"hzgl", nil];
    for (int i=0; i<3; i++) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15+40*i, 15, 15)];
        image.image = [UIImage imageNamed:imageArray[i]];
        [buttonView addSubview:image];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, 15+40*i, 70, 15)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.text = ary[i];
        [buttonView addSubview:label];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, i*40, buttonView.frame.size.width, 30);
        [buttonView addSubview:btn];
        [btn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIImageView * i = [[UIImageView alloc] initWithFrame:CGRectMake(buttonView.frame.origin.x+buttonView.frame.size.width/2-9, CGRectGetMaxY(buttonView.frame), 18, 10)];
    i.image = [UIImage imageNamed:@"xxsj"];
    //i.backgroundColor = [UIColor redColor];
    [_moreView addSubview:i];
    
}
-(void)moreBtn:(UIButton *)btn{
    [_moreView removeFromSuperview];
    if ([btn.titleLabel.text isEqualToString:@"添加随访"]) {
        if (![_patients.targetId isKindOfClass:[NSNull class]]&&![_patients.targetId isEqualToString:@""]&&_patients.targetId!=nil) {
        MJXAddFollowUpViewController *add = [[MJXAddFollowUpViewController alloc] init];
        add.titleStr = btn.titleLabel.text;
        add.patients = _patients;
        add.hidesBottomBarWhenPushed = YES;
        
            [self.navigationController pushViewController:add animated:YES];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:[NSString stringWithFormat: @"您还没邀请%@成为您的可沟通患者，是否立即邀请？",_patients.patientsName]
                                      message:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"确定", nil];
            alertView.tag = 1;
            [alertView show];
        }
        
    }else if ([btn.titleLabel.text isEqualToString:@"随访计划"]){
         if (![_patients.targetId isKindOfClass:[NSNull class]]&&![_patients.targetId isEqualToString:@""]&&_patients.targetId!=nil) {
        MJXFollowUpPlanViewController *plan = [[MJXFollowUpPlanViewController alloc] init];
        plan.patients = _patients;
        plan.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:plan animated:YES];
         }else{
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:[NSString stringWithFormat: @"您还没邀请%@成为您的可沟通患者，是否立即邀请？",_patients.patientsName]
                                       message:nil
                                       delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定", nil];
             alertView.tag = 1;
             [alertView show];
         }

        
    }else if ([btn.titleLabel.text isEqualToString:@"患者日记"]){
        
    }else if ([btn.titleLabel.text isEqualToString:@"患者设置"]){
        MJXPatientsWithSetViewController *p = [[MJXPatientsWithSetViewController alloc] init];
        p.patients =_patients;
        p.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:p animated:YES];
    }
    
}
-(void)addDiagnosis{
    MJXAddCourseOfDiseaseViewController *add = [[MJXAddCourseOfDiseaseViewController alloc] init];
    add.patients = self.patients;
    add.titleStr = @"新添病程";
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)getImageNSStringWithTitle:(NSString *)title{
    
    if ([title isEqualToString:@"首诊"]) {
        return @"首";
    }else if ([title isEqualToString:@"复诊"])
    {
        return @"复";
    }else if ([title isEqualToString:@"入院"])
    {
        return @"入";
    }else if ([title isEqualToString:@"住院"]){
        return @"住";
    }else if ([title isEqualToString:@"手术"]){
        return @"手";
    }
    else if ([title isEqualToString:@"出院"]){
        return @"出";
    }
    return @"";
}
-(NSString *)getsmallClassId:(NSString *)title{
    
    if ([title isEqualToString:@"病史"]) {
        return @"0";
    }else if ([title isEqualToString:@"化验"])
    {
        return @"1";
    }else if ([title isEqualToString:@"影像"])
    {
        return @"2";
    }else if ([title isEqualToString:@"用药"]){
        return @"3";
    }
    return @"";
}
//页面数据后台取出完成
-(NSMutableArray *)getImageDataFromeFile:(NSString *)patientId diseaseclassId:(NSString *)dicId smallClass:(NSString *)sCId{
    
    NSMutableArray *imageInfoArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    if (!_db) {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
    if ([_db open]) {
        FMResultSet *rs = [FMDBTool queryWithDB:_db tableName:TABLE_NAME withPatientId:patientId withDiseaseCourse:dicId withSmallClass:sCId];
        
        int imageCount = 0;
        if (rs.next) {
            imageCount = [rs intForColumn:@"imagecount"];
        }else{
            // return nil;
        }
        //存储图片路径
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *docPath = [docPaths lastObject];
        //草稿的图片路径
        NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/patient%@/diseaseCourse%@/smallClassId%@/image",patientId,dicId,sCId]];
        //判断文件夹是否存在，若存在从文件夹中获取图片
        if ([[NSFileManager defaultManager] fileExistsAtPath:draftPath])
        {
            
            //dispatch_queue_t queue = dispatch_queue_create("mjx", DISPATCH_QUEUE_CONCURRENT);
            // dispatch_async(queue, ^{
            
            for (int i = 0; i < imageCount; i++)
            {
                NSString *imagePath = [draftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d",i]];
                
                // UIImage *image = [UIImage imageWithContentsOfFile:imagePath];mjxxx
                NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
                UIImage * image = [UIImage imageWithData:imageData];
                
                if (image) {
                    [imageInfoArray addObject:image];
                }
            }
            //});
            [_db close];
            return imageInfoArray;
            
        }
    }
    [_db close];
    
    return imageInfoArray;
}
-(void)sendPatientsPhoneMessage{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    [self.view addSubview:_backView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.4;
    [btn addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:btn];
    
    UIView * tishi = [[UIView alloc] initWithFrame:CGRectMake(20, 150, APPLICATION_WIDTH-40, 170)];
    tishi.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    
    [_backView addSubview:tishi];
    
    UILabel * t = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 50, 15)];
    t.textColor = [UIColor colorWithHexString:@"#01aeff"];
    t.font = [UIFont systemFontOfSize:15];
    t.text = @"提示";
    [tishi  addSubview:t];
    
    UITextField * textFile = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, tishi.frame.size.width-40, 50)];
    textFile.backgroundColor = [UIColor whiteColor];
    textFile.font = [UIFont systemFontOfSize:15];
    textFile.placeholder = @"请输入患者手机号";
    textFile.delegate = self;
    [tishi addSubview:textFile];
    [textFile addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (![_patients.patientNumberPhone isEqualToString:@""]&&![_patients.patientNumberPhone isKindOfClass:[NSNull class]]&&_patients.patientNumberPhone!=nil) {
        textFile.text = _patients.patientNumberPhone;
    }
    
    UIView * lineW = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textFile.frame)+20, tishi.frame.size.width, 1)];
    lineW.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [tishi addSubview:lineW];
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, CGRectGetMaxY(textFile.frame)+20, tishi.frame.size.width/2, 50);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    [tishi addSubview:cancel];
    
    UIView * lineH = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancel.frame), CGRectGetMaxY(textFile.frame)+20, 1, 50)];
    lineH.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    
    [tishi addSubview:lineH];
    
    UIButton * sendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMessage.frame = CGRectMake(CGRectGetMaxX(cancel.frame), CGRectGetMaxY(textFile.frame)+20, tishi.frame.size.width/2, 50);
    [sendMessage setTitle:@"确定" forState:UIControlStateNormal];
    sendMessage.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendMessage setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [sendMessage addTarget:self action:@selector(sendMessageButton) forControlEvents:UIControlEventTouchUpInside];
    [tishi addSubview:sendMessage];
}
-(void)outView{
    [_backView removeFromSuperview];
}
//邀请患者发送短信
-(void)sendMessageButton{
    if ([_phone isEqualToString:@""]&&![_patients.patientNumberPhone isEqualToString:@""]&&![_patients.patientNumberPhone isKindOfClass:[NSNull class]]) {
        _phone = _patients.patientNumberPhone;
    }
    if ([MJXUIUtils isSimplePhone:_phone]&&![_phone isEqualToString:@""]&&![_phone isKindOfClass:[NSNull class]]) {
        
        AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
        
        NSString * urlChangePhone = [NSString stringWithFormat:@"%@/patient/editPatient",MJXBaseURL];
        if ([_patientInfoDict allKeys].count == 15) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            dict = [self getPatientInfo];
            [manger POST:urlChangePhone parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                    [self send];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MJXUIUtils show404WithDelegate:self];
            }];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"请填写正确的手机号"
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"我知道了", nil];
        [alertView show];
    }
}
-(void)send{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/followup/sendInvitation",MJXBaseURL];
    
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"patientId":_patients.patientId
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self outView];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MJXUIUtils show404WithDelegate:self];
                                  }];
}

-(NSMutableDictionary *)getPatientInfo{
    NSMutableDictionary * d = [[NSMutableDictionary alloc] init];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"headimg"]] forKey:@"heading"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"id"]] forKey:@"patientId"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"name"]] forKeyedSubscript:@"patientName"];
    [d setObject:[NSString stringWithFormat:@"%@",_phone] forKeyedSubscript:@"patientPhone"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"medicalRecordNum"]] forKey:@"medicalRecordNum"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"sex"]] forKey:@"gender"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"birthday"]] forKey:@"birthday"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"group"]] forKey:@"group"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"zhenduan"]] forKey:@"diagnosticInfo"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"address"]] forKey:@"address"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"idCode"]] forKey:@"idcard"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"nation"]] forKey:@"national"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"occupation"]] forKey:@"professional"];
    [d setObject:[NSString stringWithFormat:@"%@",[_patientInfoDict objectForKey:@"marriageInfo"]] forKey:@"marriageInfo"];
    [d setObject:[[MJXAppsettings sharedInstance] getUserPhone] forKey:@"username"];
    return d;
}
#pragma mark UITextFiledDelegate
-(void)textFieldDidChange:(UITextField *)textField{
    _phone = textField.text;
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex==1) {
            [self sendPatientsPhoneMessage];
        }
    }
    
}
#pragma mark HUD
//展示风火轮HUD
- (void)showHUD:(UIView *)view mode:(MBProgressHUDMode)mode text:(NSString *)text detailText:(NSString *)detailText
{
    _HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [_HUD setMode:mode];
    [_HUD setLabelText:text];
    [_HUD setDetailsLabelText:detailText];
}

//隐藏风火轮HUD
- (void)hide:(CGFloat)delay
{
    [_HUD hide:YES afterDelay:delay];
}
#pragma mark courseOfDiseaseTableViewCellDelegate
-(void)bjButtonPressed{
    
}
#pragma mark UITableViewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_medicalRecordsArry.count>0) {
        if (_sign<_medicalRecordsArry.count) {
            return _sign;
        }else{
            return _medicalRecordsArry.count+1;
        }
    }
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_medicalRecordsArry.count>0) {
        if (section==0) {
            return 2;
        }else if(section>0){
            int a = 0;
            for (int i=0; i<4; i++) {
                //展示的时候判断数组有没有内容
                MJXMedicalRecords *model=[[MJXMedicalRecords alloc] init];
                NSArray *ary1 =[_medicalRecordsArry[section-1] objectForKey:@"medicalDocType_list"];
                if (ary1.count>0&&ary1.count>i&&ary1!=nil) {
                    [model setValueWithDict: ary1[i]];
                }else{
                    break ;
                }
                
                NSMutableArray *tary = [NSMutableArray arrayWithCapacity:10];
                tary = [self getImageDataFromeFile:_patients.patientId diseaseclassId:[_medicalRecordsArry[section-1] objectForKey:@"medicaStageId"] smallClass:[self getsmallClassId:model.medicaDocType]];
                [_imageDrafDict setValue:tary forKey:model.medicaDocID];
                if ([model.medicaDocType isEqualToString:@"病史"]) {
                    NSString * blxq = [NSString stringWithFormat:@"%@",[_medicalRecordsArry[section-1] objectForKey:@"blxq"]];
                    if (blxq.length>0&&![blxq isEqualToString:@"<null>"]) {
                        
                    }else{
                        blxq = @"";
                    }
                    
                    if (((model.illnessDescription.length>0&&![model.illnessDescription isEqualToString:@"<null>"])||blxq.length>0||model.imageUrlLArray.count>0||tary.count>0)) {
                        a++;
                    }
                }else{
                    if ((tary.count>0||(model.illnessDescription.length>0&&![model.illnessDescription isEqualToString:@"<null>"])||model.imageUrlLArray.count>0)) {
                        a++;
                    }
                }
            }
            return a;
        }
        
    }else if (section==0) {
        return 2;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXCourseOfDiseaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXCourseOfDiseaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.row==0&&indexPath.section==0) {
        [cell setHeadImageWithName:_patients.patientHeadImageUrl withName:[NSString stringWithFormat:@"%@  %@岁",_patients.patientsName,_patients.patientAge] withSex:_patients.patientSex];
    }else if(indexPath.row==1&&indexPath.section==0) {
        [cell setDiagnosisTextWithString:_patients.patientDiagnosis];
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //展示的时候判断数组有没有内容
        MJXMedicalRecords *model=[[MJXMedicalRecords alloc] init];
        NSArray * ary =[_medicalRecordsArry[indexPath.section-1] objectForKey:@"medicalDocType_list"];
        if (ary.count>0&&ary!=nil) {
            [model setValueWithDict: ary[indexPath.row]];
        }
        NSMutableArray * tary = [[NSMutableArray alloc] init];
        
        [tary addObjectsFromArray :[_imageDrafDict valueForKey:[NSString stringWithFormat:@"%@",model.medicaDocID]]];
        __weak typeof(self) weakSelf=self;

        cell.handleVC = weakSelf;
        
        if (!tary) {
            tary = [[NSMutableArray alloc] initWithArray:model.imageUrlLArray];
        }else{
            [tary addObjectsFromArray:model.imageUrlLArray];
        }
        [cell setTitle:model.medicaDocType Button:0 withButtonTag:indexPath.row ImageUrlArray:tary Description:model.illnessDescription history:@""];
        //        cell.delegate=self;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row ==0) {
        NSLog(@"1");
        MJXAddPatientsViewController * vc = [[MJXAddPatientsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.patients = _patients;
        vc.titleStr = @"修改信息";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
        MJXEditTheDiagnosisViewController * vc = [[MJXEditTheDiagnosisViewController alloc] init];
        vc.patients = _patients;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    MJXCourseOfDiseaseTableViewCell *cell = (MJXCourseOfDiseaseTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height+10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    if (section==0)
    {
        view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        return view;
    }else if(_medicalRecordsArry.count>0&&section!=0){
        view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, 60);
        view.backgroundColor = [UIColor whiteColor];
        UIView *lineW = [[UIView alloc] initWithFrame:CGRectMake(20, 59, APPLICATION_WIDTH, 1)];
        lineW.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
        [view addSubview:lineW];
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, -2, APPLICATION_WIDTH, 10)];
        v.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        [view addSubview:v];
        UIView *lineH = [[UIView alloc] initWithFrame:CGRectMake(13, 25, 1, 60-25)];
        lineH.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [view addSubview:lineH];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 25, 20, 20)];
        NSString *str = [self getImageNSStringWithTitle:[_medicalRecordsArry[ section-1] objectForKey:@"medicalStage"]];
        imageView.image = [UIImage imageNamed:str];
        [view addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 28, 270, 13)];
        
        lable.text = [_medicalRecordsArry[section- 1] objectForKey:@"medicalStage"];
        lable.textColor = [UIColor colorWithHexString:@"#333333"];
        lable.font = [UIFont systemFontOfSize:15];
        lable.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lable];
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-90, 28, 90, 13)];
        time.font = [UIFont systemFontOfSize:12];
        
        NSString * str11 = [NSString stringWithFormat:@"%@",[_medicalRecordsArry[section-1] objectForKey:@"createTime"]];
        
        if (![str11 isKindOfClass:[NSNull class]]&&![str11 isEqualToString:@"<null>"]&&str11!=nil) {
            time.text = str11;
        }else{
            time.text = @"";
        }
        time.textColor = [UIColor colorWithHexString:@"#999999"];
        [view addSubview:time];
        
        UIButton *checkTheDetails = [UIButton buttonWithType:UIButtonTypeCustom];
        checkTheDetails.frame = CGRectMake(0, 0, APPLICATION_WIDTH, 60);
        checkTheDetails.tag = section;
        [checkTheDetails addTarget:self action:@selector(checkTheDetailsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:checkTheDetails];
    }
    return view;
}
-(void)checkTheDetailsBtn:(UIButton *)btn{
    MJXAddCourseOfDiseaseViewController *add = [[MJXAddCourseOfDiseaseViewController alloc] init];
    add.patients = self.patients;
    add.titleStr = @"修改病程";
    //展示的时候判断数组有没有内容
    NSArray *ary1 = [_medicalRecordsArry[btn.tag-1] objectForKey:@"medicalDocType_list"];
    int n = 0;
    if (ary1.count>0) {
        n = (int)ary1.count;
    }
    for (int i=0; i<n; i++) {
        MJXMedicalRecords *model=[[MJXMedicalRecords alloc] init];
        if (ary1.count>0) {
            [model setValueWithDict: ary1[i]];
            NSMutableArray *tary = [NSMutableArray arrayWithCapacity:10];
            tary = [self getImageDataFromeFile:_patients.patientId diseaseclassId:[_medicalRecordsArry[btn.tag-1] objectForKey:@"medicaStageId"] smallClass:[self getsmallClassId:model.medicaDocType]];
            [model.imageAllArray removeAllObjects];
            
            [model.imageLArray addObjectsFromArray:tary];
            [model.imageAllArray addObjectsFromArray:tary];
            [model.imageAllArray addObjectsFromArray:model.imageUrlLArray];
            // [model.imageSArray addObjectsFromArray:tary];
            if ([model.medicaDocType isEqualToString:@"病史"]) {
                [add.medicalRecordsArry setObject:model atIndexedSubscript:0];
            }else if ([model.medicaDocType isEqualToString:@"化验"]){
                [add.medicalRecordsArry setObject:model atIndexedSubscript:1];
            }else if ([model.medicaDocType isEqualToString:@"影像"]){
                [add.medicalRecordsArry setObject:model atIndexedSubscript:2];
            }else if ([model.medicaDocType isEqualToString:@"用药"]){
                [add.medicalRecordsArry setObject:model atIndexedSubscript:3];
            }
            
        }
    }
    add.time = [_medicalRecordsArry[btn.tag-1] objectForKey:@"createTime"];
    add.diseaseId = [NSString stringWithFormat:@"%@",[_medicalRecordsArry[btn.tag-1] objectForKey:@"medicaStageId"]];
    add.classification = [_medicalRecordsArry[btn.tag-1] objectForKey:@"medicalStage"];
    add.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:add animated:YES];
    
}
#pragma mark 缓存
-(void)saveALLPatientsInfoWithArray:(NSMutableArray *)ary{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary * patientsDict = [[NSMutableDictionary alloc] init];
        
        [patientsDict setObject:ary forKey:@"patientAllInfo"];
        
        NSData *resultData = [NSJSONSerialization dataWithJSONObject:patientsDict options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //缓存的路径
        NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/userIdPatientsInfo%@/patients%@",[[MJXAppsettings sharedInstance] getUserPhone],_patients.patientId]];
        
        //判断文件夹是否存在，若不存在创建路径中的文件夹
        if (![[NSFileManager defaultManager] fileExistsAtPath:draftPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:draftPath withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            
            [[NSFileManager defaultManager] removeItemAtPath:draftPath error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:draftPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *imagePath = [draftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_patients.patientId]];
        BOOL result = [resultData writeToFile:imagePath atomically:YES];
    });
}
-(void)getAllPatientInfo{
    //加入到主线程里面，可以避免数据加载卡顿
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *docPath = [docPaths lastObject];
        //草稿的图片路径
        NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/userIdPatientsInfo%@/patients%@",[[MJXAppsettings sharedInstance] getUserPhone],_patients.patientId]];
        NSString *imagePath = [draftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_patients.patientId]];
        
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        if (data==nil) {
            //展示风火轮
            [self showHUD:self.view mode:MBProgressHUDModeIndeterminate text:nil detailText:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_medicalRecordsArry.count>0&&_medicalRecordsArry!=nil) {
                    
                }else{
                    
                    [self getData];
                }
                //[_tableView reloadData];
            });
        }else{
            
            NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray * ary = [NSMutableArray arrayWithCapacity:10];
            ary = [resultDic objectForKey:@"patientAllInfo"];
            _medicalRecordsArry = ary;
            [_tableView reloadData];
            [self getData];
            
        }
        //        if (_medicalRecordsArry.count>0&&_medicalRecordsArry!=nil) {
        //
        //        }else{
        //            //展示风火轮
        //            [self showHUD:self.view mode:MBProgressHUDModeIndeterminate text:nil detailText:nil];
        //        }
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (_medicalRecordsArry.count>0&&_medicalRecordsArry!=nil) {
        //
        //            }else{
        //
        //                [self getData];
        //            }
        //            [_tableView reloadData];
        //        });
    });
    //    [self savePatientWithArray:_medicalRecordsArry];
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
