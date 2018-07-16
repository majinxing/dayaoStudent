//
//  MJXEditTheDiagnosisViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/11/2.
//  Copyright © 2016年 majinxing. All rights reserved.
//  诊断编辑页面VC

#import "MJXEditTheDiagnosisViewController.h"

@interface MJXEditTheDiagnosisViewController ()<UITextViewDelegate>
@property (nonatomic,strong)NSString * patientDiagnosis;
@end

@implementation MJXEditTheDiagnosisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"修改诊断"];
    _patientDiagnosis = [[NSString alloc] init];
    [self addBackButton];
    [self addTextView];
    // Do any additional setup after loading the view.
}
-(void)addTextView{
    UITextView * text = [[UITextView alloc] initWithFrame:CGRectMake(0, 70, APPLICATION_WIDTH, 170)];
    text.backgroundColor = [UIColor whiteColor];
    text.font = [UIFont systemFontOfSize:15];
    text.textColor = [UIColor colorWithHexString:@"#333333"];
    text.text = _patients.patientDiagnosis;
    text.delegate = self;
    [self.view addSubview:text];
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
-(NSMutableDictionary *)savePatientsInfo{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];

    [dict setObject:[NSString stringWithFormat:@"%@",_patients.patientsName] forKey:@"patientName"];
    [dict setObject:[NSString stringWithFormat:@"%@",_patients.patientNumberPhone] forKey:@"patientPhone"];
    [dict setObject:[NSString stringWithFormat:@"%@",_patients.medicalRecordNumber] forKey:@"medicalRecordNum"];
    [dict setObject:_patients.patientSex forKey:@"gender"];
    [dict setObject:_patients.dateOfBirth forKey:@"birthday"];
    [dict setObject:_patients.groupNameStr forKey:@"group"];
    [dict setObject:_patients.patientDiagnosis forKey:@"diagnosticInfo"];
    [dict setObject:_patients.address forKey:@"address"];
    [dict setObject:_patients.idCard forKey:@"idcard"];
    [dict setObject:_patients.MaritalStatus forKey:@"marriageInfo"];
    [dict setObject:_patients.national forKey:@"national"];
    [dict setObject:_patients.professional forKey:@"professional"];
    [dict setObject:_patients.patientHeadImageUrl forKey:@"heading"];
    [dict setObject:[NSString stringWithFormat:@"%@",_patients.patientId] forKey:@"patientId"];
    [dict setObject:_patients.patientId forKey:@"username"];
    return dict;
}
-(void)save{
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//    dict = [self savePatientsInfo];
    
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
   NSString * url = [NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/patient/updateZhenDuanXinXi"];
    [manger POST:url parameters:@{
                                  @"username": [[MJXAppsettings sharedInstance] getUserPhone],
                                  @"patientId": _patients.patientId,
                                  @"diagnosticInfo" :_patientDiagnosis
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self back];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
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
    //_patients.patientDiagnosis = textView.text;
    if (![textView.text isEqualToString:@""]) {
        _patientDiagnosis = textView.text;
    }else{
        _patientDiagnosis = @"";
    }
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
