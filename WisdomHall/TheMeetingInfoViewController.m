//
//  TheMeetingInfoViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/20.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TheMeetingInfoViewController.h"
#import "MeetingModel.h"
#import "DYHeader.h"
#import "ShareView.h"
#import "VoteViewController.h"
#import "ConversationVC.h"
#import "DiscussViewController.h"
#import "ClassManagementViewController.h"
#import "SignListViewController.h"
#import "DataDownloadViewController.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import "ZFSeatViewController.h"
#import "SeatIngModel.h"
#import "AFHTTPSessionManager.h"
#import "MeetingTableViewCell.h"
#import "QRCodeGenerateVC.h"
#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "QrCodeViewController.h"
#import "PhotoPromptBox.h"
#import "AlterView.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

@interface TheMeetingInfoViewController ()<UINavigationControllerDelegate, UIVideoEditorControllerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,MeetingTableViewCellDelegate,UIImagePickerControllerDelegate,UIDocumentInteractionControllerDelegate,AlterViewDelegate>
@property (nonatomic,strong) ShareView * interaction;
@property (nonatomic,strong)UserModel * user;
@property (nonatomic,assign)int temp;
@property (nonatomic,strong)NSTimer * timeRun;
@property (nonatomic,strong)SeatIngModel * seatModel;
@property (nonatomic,assign)int mac;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)BOOL isEnabel;
@property (nonatomic,strong)PhotoPromptBox * photoView;
@property (nonatomic,copy) NSString * pictureType;//标明是问答还是签到照片
@property (nonatomic,strong)AlterView * alterView;
@property (nonatomic,strong) NSTimer * t;
@end

@implementation TheMeetingInfoViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mac = 0;
    _isEnabel = NO;
    if ([[NSString stringWithFormat:@"%@",_meetingModel.signStatus] isEqualToString:@"2"]) {
        _isEnabel = YES;
    }
    
    [self getData];
    
    [self addTableView];
    
    [self setNavigationTitle];
    
    // 1.注册通知
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSignNumber) name:@"SignSucceed" object:nil];
    
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceCalls:) name:@"VoiceCalls" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)voiceCalls:(NSNotification *)dict{
    EMCallSession * aSession = [dict.userInfo objectForKey:@"session"];
    ConversationVC * c  = [[ConversationVC alloc] init];
    c.callSession = aSession;
    int n = (int)[NSString stringWithFormat:@"%@",_user.school].length;
    NSMutableString * str = [NSMutableString stringWithFormat:@"%@",aSession.remoteName];
    [str deleteCharactersInRange:NSMakeRange(0,n)];
    c.teacherName = str;
    c.call = CALLED;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:c animated:YES];
}
-(void)getData{
    _seatModel = [[SeatIngModel alloc] init];
    _seatModel.seatTable = [NSString stringWithFormat:@"%@",_meetingModel.seat];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingDetailId,@"meetingId", nil];
    [[NetworkRequest sharedInstance] GET:QueryMeetingPeople dict:dict succeed:^(id data) {
        //        NSLog(@"%@",data);
        NSArray * ary = [data objectForKey:@"body"];
        [_meetingModel setSignPeopleWithNSArray:ary];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
}

/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"会议详情";
    
    if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_meetingModel.meetingHostId]]) {
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"删除会议" style:UIBarButtonItemStylePlain target:self action:@selector(deleteMeeting)];
        self.navigationItem.rightBarButtonItem = myButton;
    }
    
}
-(void)deleteMeeting{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"删除周期会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showHudInView:self.view hint:NSLocalizedString(@"正在提交数据", @"Load data...")];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingId,@"id", nil];
        [[NetworkRequest sharedInstance] POST:MeetingDelect dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
            if ([str isEqualToString:@"成功"]) {
                // 2.创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheMeetingPage" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                [self.navigationController popViewControllerAnimated:YES];
                [self hideHud];
                
            }else{
                UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"删除会议失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter show];
                [self hideHud];
            }
        } failure:^(NSError *error) {
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"删除会议失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
            [self hideHud];
            
        }];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除当前会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showHudInView:self.view hint:NSLocalizedString(@"正在提交数据", @"Load data...")];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingDetailId,@"detailId", nil];
        
        [[NetworkRequest sharedInstance] POST:MeetingDetailIdDelect dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
            if ([str isEqualToString:@"成功"]) {
                // 2.创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheMeetingPage" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                [self.navigationController popViewControllerAnimated:YES];
                [self hideHud];
                
            }else{
                UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"删除会议失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter show];
                [self hideHud];
            }
        } failure:^(NSError *error) {
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"删除会议失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
            [self hideHud];
            
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ALter
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
            
            [[UIApplication sharedApplication] openURL:url];
            
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }else if(buttonIndex == 1){
            [alertView setHidden:YES];
        }
        
    }else if (alertView.tag == 2){
        
        if (buttonIndex == 0) {
            NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
#pragma mark NSTimer
-(void)removeView{
    NSTimeInterval timeInterval = 3.0 ;
    
    _t = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                          target:self
                                        selector:@selector(handleMaxShowTimer:)
                                        userInfo:nil
                                         repeats:YES];;
}
//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    [_alterView removeFromSuperview];
    [_t invalidate];
}
#pragma mark AlterView
-(void)alterViewDeleageRemove{
    [_alterView removeFromSuperview];
    [_t invalidate];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeetingTableViewCell * cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell addFirstContentView:_meetingModel];
    }else if (indexPath.section == 1){
        if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_meetingModel.meetingHostId]]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellSecond"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:1];
            }
            [cell addSecondContentView:_meetingModel];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellThird"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:2];
            }
            [cell addThirdContentView:_meetingModel isEnable:_isEnabel];
        }
        
    }else if (indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellFourth"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:3];
        }
        [cell addFourthContentView:_meetingModel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 150;
    }else if (indexPath.section ==1){
        return 60;
    }else if (indexPath.section == 2){
        return 200;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 25;
    }else if(section == 2){
        return 25;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = RGBA_COLOR(231, 231, 231, 1);
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 80, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    if (section == 1) {
        label.text = @"签到";
    }else if(section == 2){
        label.text = @"互动";
    }
    return view;
}
#pragma mark MeetingCellDelegate
-(void)shareButtonClickedDelegate:(NSString *)platform{
    if ([platform isEqualToString:InteractionType_Responder]){
        NSLog(@"抢答");
        if (_meetingModel.workNo.length>0) {
            
            ConversationVC * c =[[ConversationVC alloc] init];
            
            c.HyNumaber = [NSString stringWithFormat:@"%@%@",_user.school,_meetingModel.workNo];
            
            c.call = CALLING;
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:c animated:YES];
            
        }else{
            [UIUtils showInfoMessage:@"不能呼叫自己"];
        }
        
    }else if ([platform isEqualToString:InteractionType_Vote]){
        VoteViewController * v = [[VoteViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        v.meetModel = _meetingModel;
        v.type = @"meeting";
        [self.navigationController pushViewController:v animated:YES];
        NSLog(@"投票");
    }else if ([platform isEqualToString:InteractionType_Data]){
        NSLog(@"资料");
        DataDownloadViewController * d = [[DataDownloadViewController alloc] init];
        d.meeting = _meetingModel;
        d.type = @"meeting";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: d animated:YES];
    }else if ([platform isEqualToString:InteractionType_Discuss]){
        DiscussViewController * d = [[DiscussViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:d animated:YES];
        NSLog(@"讨论");
    }else if([platform isEqualToString:InteractionType_Sit]){
        if (![UIUtils isBlankString:_seatModel.seatTable]) {
            ZFSeatViewController * z = [[ZFSeatViewController alloc] init];
            z.seatTable = _seatModel.seatTable;
            z.seat = _meetingModel.userSeat;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:z animated:YES];
        }else{
            [UIUtils showInfoMessage:@"未获取会场信息，请刷新会场页面信息获取"];
        }
    }else {
        [UIUtils showInfoMessage:@"未完待续"];
        return;
    }
    
    
    //  else if ([platform isEqualToString:InteractionType_Responder]){
    //        NSLog(@"抢答");
    //        if (_meetingModel.workNo.length>0) {
    //
    //            ConversationVC * c =[[ConversationVC alloc] init];
    //            c.HyNumaber = [NSString stringWithFormat:@"%@%@",_user.school,_meetingModel.workNo];
    //            c.call = CALLING;
    //            self.hidesBottomBarWhenPushed = YES;
    //            [self.navigationController pushViewController:c animated:YES];
    //
    //        }else{
    //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不能呼叫自己" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //            [alertView show];
    //        }
    //
    //    }
    //    else if ([platform isEqualToString:InteractionType_Test]){
    //        NSLog(@"测试");
    //    }
    //    else if ([platform isEqualToString:InteractionType_Add]){
    //        NSLog(@"更多");
    //    }else if ([platform isEqualToString:InteractionType_Data]){
    //        NSLog(@"资料");
    //        DataDownloadViewController * d = [[DataDownloadViewController alloc] init];
    //        d.meeting = _meetingModel;
    //        d.type = @"meeting";
    //        self.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController: d animated:YES];
    //    }
}
-(void)peopleManagementDelegate{
    ClassManagementViewController * classManegeVC = [[ClassManagementViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    classManegeVC.manage = MeetingManageType;
    classManegeVC.meeting = _meetingModel;
    [self.navigationController pushViewController:classManegeVC animated:YES];
}
-(void)signNOPeopleDelegate{
    SignListViewController * signListVC = [[SignListViewController alloc] init];
    signListVC.signType = SignMeeting;//签到类型
    signListVC.meetingModel = _meetingModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signListVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    if (![UIUtils validateWithStartTime:_meetingModel.meetingTime withExpireTime:nil]) {
        return;
    }else{
        if ([[NSString stringWithFormat:@"%@",_meetingModel.signStatus] isEqualToString:@"2"]) {
            return;
        }else{
            if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_meetingModel.meetingHostId]]) {
                return;
            }else{
                [self autoSign];
            }
        }
    }
}
-(void)autoSign{
    
    if (![UIUtils validateWithStartTime:_meetingModel.meetingTime withExpireTime:nil]) {
        return;
    }
    _isEnabel = YES;
    [_tableView reloadData];
    NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
    
    if (![UIUtils isBlankString:[dictWifi objectForKey:@"BSSID"]]) {
        
        NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
        
        if ([UIUtils matchingMacWith:_meetingModel.mck withMac:bssid]) {
            _mac = 1;
            
            [self signSendIng];
            
            [self sendSignInfo];
            
        }else if (_mac == 1){
            [self signSendIng];
            
            [self sendSignInfo];
        }else{
            self.alterView = [[AlterView alloc] initWithFrame:CGRectMake(20, 100, APPLICATION_WIDTH-40, 100) withAlterStr:@"未连接上教室指定WiFi"];
            self.alterView.delegate = self;
            [self.view addSubview:self.alterView];
            [self removeView];
        }
    }else if (_mac == 1){
        
        [self signSendIng];
        [self sendSignInfo];
        
    }else{
        self.alterView = [[AlterView alloc] initWithFrame:CGRectMake(20, 100, APPLICATION_WIDTH-40, 100) withAlterStr:@"未连接上教室指定WiFi"];
        self.alterView.delegate = self;
        [self.view addSubview:self.alterView];
        [self removeView];
    }
    
}
-(void)signBtnPressedDelegate:(UIButton *)btn{
    
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    
    if (![UIUtils validateWithStartTime:_meetingModel.meetingTime withExpireTime:nil]) {
        if ([[NSString stringWithFormat:@"%@",_meetingModel.signStatus] isEqualToString:@"2"]) {
            [UIUtils showInfoMessage:@"已签到,并已过签到时间不能上传照片"];
        }else{
            [UIUtils showInfoMessage:@"会议开始之后一定时间范围内才可以签到"];
        }
        [self hideHud];
        return;
    }else{
//        signStatus
        if ([[NSString stringWithFormat:@"%@",_meetingModel.signStatus] isEqualToString:@"2"]) {
            [self hideHud];
            [self signPictureUpdate];
            return;
        }
    }
    _isEnabel = YES;
    [_tableView reloadData];
    NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
    
    if (![UIUtils isBlankString:[dictWifi objectForKey:@"BSSID"]]) {
        
        
        NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
        
        if ([UIUtils matchingMacWith:_meetingModel.mck withMac:bssid]) {
            _mac = 1;
            
            [self signSendIng];
            
            [self sendSignInfo];
            
        }else if (_mac == 1){
            [self signSendIng];
            
            [self sendSignInfo];
        }else{
            
            NSString * s = [UIUtils returnMac:_meetingModel.mck];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定的DAYAO或XTU开头的WiFi,再点击签到，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，签到完成之后请连接数据流量保证数据传输"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
            alertView.delegate = self;
            alertView.tag = 1;
            [alertView show];
            [self hideHud];
        }
        
    }else if (_mac == 1){
        
        [self signSendIng];
        [self sendSignInfo];
        
    }else{
        NSString * s = [UIUtils returnMac:_meetingModel.mck];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定DAYAO或XTU开头的WiFi,再点击签到，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，签到完成之后请连接数据流量保证数据传输"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
        alertView.delegate = self;
        alertView.tag = 1;
        [alertView show];
        [self hideHud];
    }
}
-(void)signSendIng{
    _meetingModel.signStatus = @"3";
    [_tableView reloadData];
}
-(void)sendSignInfo{
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingDetailId,@"detailId",_user.peopleId,@"userId" ,idfv,@"mck",@"2",@"status",_meetingModel.meetingId,@"meetingId",nil];
    
    [[NetworkRequest sharedInstance] POST:MeetingSign dict:dict succeed:^(id data) {
//        NSLog(@"succedd:%@",data);
        [self alter:[[data objectForKey:@"header"] objectForKey:@"code"]];
        [self hideHud];

    } failure:^(NSError *error) {
        NSLog(@"失败：%@",error);
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"无网络，请保证数据流量的连接后再次点击签到" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alter.tag = 2;
        [alter show];
        [self hideHud];
        _meetingModel.signStatus = @"4";
        [_tableView reloadData];
    }];
}
-(void)alter:(NSString *) str{
    if ([str isEqualToString:@"1002"]) {
        [UIUtils showInfoMessage:@"暂时不能签到"];
        _meetingModel.signStatus = @"1";

    }else if ([str isEqualToString:@"1003"]){
        [UIUtils showInfoMessage:@"已签到"];
        _meetingModel.signStatus = @"2";
    }else if ([str isEqualToString:@"1004"]){
        [UIUtils showInfoMessage:@"未参加课程"];
        _meetingModel.signStatus = @"1";
    }else if ([str isEqualToString:@"0000"]){
        
        _meetingModel.signStatus = @"2";
        
//        [UIUtils showInfoMessage:@"签到成功"];
        [self signPictureUpdate];
        
        [_tableView reloadData];
        // 2.创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheMeetingPage" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if ([str isEqualToString:@"5000"]){
        [UIUtils showInfoMessage:@"签到失败"];
        _meetingModel.signStatus = @"1";
    }else if ([str isEqualToString:@"1008"]){
        _meetingModel.signStatus = @"1";
        [UIUtils showInfoMessage:@"这台手机已经签到一次了，不能重复使用签到，谢谢"];
    }else if ([str isEqualToString:@"9999"]){
        _meetingModel.signStatus = @"1";
        [UIUtils showInfoMessage:@"系统错误"];
    }
    [_tableView reloadData];
}
-(void)signPictureUpdate{
    if (!_photoView) {
        _photoView = [[PhotoPromptBox alloc] initWithBlack:^(NSString * str) {
            [_photoView removeFromSuperview];

        } WithTakePictureBlack:^(NSString *str) {
            [self getPicture];
            [_photoView removeFromSuperview];
        }];
        _photoView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    }
    [self.view addSubview:_photoView];
}
-(void)getPicture{
    //实现button点事件的回调方法
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    //设置相册呈现的样式
    
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //    //分别按顺序放入每个按钮；
    //    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;//图片分组列表样式
    pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
    //使用模态呈现相册
    [self.navigationController presentViewController:pickerController animated:YES completion:^{
        
    }];
    //    }]];
    
    //    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
    //        //照片的选取样式还有以下两种
    //        //UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册UIImagePickerControllerSourceTypeSavedPhotosAlbum
    //        //UIImagePickerControllerSourceTypeCamera//调取摄像头
    //
    //        //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    //        pickerController.delegate = self;
    //        //使用模态呈现相册
    //        [self.navigationController presentViewController:pickerController animated:YES completion:^{
    //
    //        }];
    //
    //    }]];
    //
    //
    //    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //        //点击按钮的响应事件；
    //    }]];
    //
    //    //弹出提示框；
    //    [self presentViewController:alert animated:true completion:nil];
    
}
//选择照片完成之后的代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //info是所选择照片的信息
    
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    //    NSString * filePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSString * str = [NSString stringWithFormat:@"%@-%@-%@",user.userName,user.studentId,[UIUtils getTime]];
    
    NSDictionary * dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",str,@"description",@"10",@"function",[NSString stringWithFormat:@"%@",_meetingModel.meetingDetailId],@"relId",@"2",@"relType",nil];
    
    UIImage * image = [UIUtils addWatemarkTextAfteriOS7_WithLogoImage:resultImage watemarkText:[NSString stringWithFormat:@"%@-%@-%@",_user.userName,_user.studentId,[UIUtils getCurrentDate]]];

    [[NetworkRequest sharedInstance] POSTImage:FileUpload image:image dict:dict1 succeed:^(id data) {
        NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([code isEqualToString:@"0000"]) {
            [UIUtils showInfoMessage:@"上传成功"];
        }else{
            [UIUtils showInfoMessage:@"上传失败"];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"上传失败"];
    }];
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)codePressedDelegate:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"扫码签到"]) {
        if (![UIUtils validateWithStartTime:_meetingModel.meetingTime withExpireTime:nil]) {
            [UIUtils showInfoMessage:@"会议开始之后一定时间范围内才可以签到"];
            return;
        }
        //     1、 获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                            [vc returnText:^(NSDictionary *returnText) {
                                if (returnText) {
                                    [self codeSign:returnText];
                                }
                            }];
                        });
                        // 用户第一次同意了访问相机权限
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        
                    } else {
                        // 用户第一次拒绝了访问相机权限
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
            } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
                SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                [vc returnText:^(NSDictionary *returnText) {
                    if (returnText) {
                        [self codeSign:returnText];
                    }
                }];
            } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                
            } else if (status == AVAuthorizationStatusRestricted) {
                NSLog(@"因为系统原因, 无法访问相册");
            }
        } else {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }else{
        NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
        
        if (![UIUtils isBlankString:[dictWifi objectForKey:@"BSSID"]]) {
            NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
            
            if ([UIUtils matchingMacWith:_meetingModel.mck withMac:bssid]) {
                NSString * interval = [UIUtils getCurrentTime];
                NSString * checkcodeLocal = [NSString stringWithFormat:@"%@dayaokeji",interval];
                NSString * md5 = [self md5:checkcodeLocal];
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:interval,@"date",_meetingModel.mck,@"loc_array",md5,@"checkcode",nil];
                QrCodeViewController * q = [[QrCodeViewController alloc] init];
                q.mck = [[NSMutableArray alloc] initWithArray:_meetingModel.mck];
                self.hidesBottomBarWhenPushed = YES;
                q.dict = dict;
                [self.navigationController pushViewController:q animated:YES];
            }else{
                [UIUtils showInfoMessage:@"请在连接指定的DAYAO或XTU开头的WiFi下生成二维码"];
            }
        }else{
            [UIUtils showInfoMessage:@"请在连接指定的DAYAO或XTU开头的WiFi下生成二维码"];
        }

    }
}
-(void)codeSign:(NSDictionary *)dict{
    if (dict) {
        NSString * date = [dict objectForKey:@"date"];
        NSArray * loc_array = [dict objectForKey:@"loc_array"];
        NSString * checkcode = [[dict objectForKey:@"checkcode"] lowercaseString];
        NSString * dateTime = [UIUtils getTheTimeStamp:date];
        NSString * checkcodeLocal = [NSString stringWithFormat:@"%@dayaokeji",date];
        NSString * md5 = [self md5:checkcodeLocal];
        if ([md5 isEqualToString:checkcode]) {
            if ([UIUtils dateTimeDifferenceWithStartTime:dateTime]) {
                if ([UIUtils returnMckIsHave:_meetingModel.mck withAccept:loc_array]) {
                    [self sendSignInfo];
                }else{
                    [UIUtils showInfoMessage:@"未识别到指定路由器，请重新扫描或者连接指定WiFi签到"];
                }
            }else{
                [UIUtils showInfoMessage:@"二维码时间失效，请重新扫描或者连接指定WiFi签到"];
            }
        }else{
            [UIUtils showInfoMessage:@"二维码无效，请重新扫描或者连接指定WiFi签到"];
        }
    }else{
        [UIUtils showInfoMessage:@"二维码无效，请重新扫描或者连接指定WiFi签到"];
    }
}
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
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
