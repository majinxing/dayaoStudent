//
//  CourseDetailsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "ClassManagementViewController.h"
#import "DYHeader.h"
#import "ShareView.h"
#import "TextViewController.h"
#import "SignListViewController.h"

#import "VoteViewController.h"
#import "DataDownloadViewController.h"
#import "SignPeople.h"
#import "AFHTTPSessionManager.h"
#import "AllTestViewController.h"
#import "MeetingTableViewCell.h"
#import "QRCodeGenerateVC.h"
#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "QrCodeViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZFSeatViewController.h"
#import "PhotoPromptBox.h"
#import "AlterView.h"
#import "AllOrPersonalDataViewController.h"
#import "PersonalUploadDataViewController.h"
#import "HomeWorkViewController.h"

#import "RHScanViewController.h"//二维码

#import "PictureQuizViewController.h"

#import "TestAllViewController.h"

#import "MessageListViewController.h"

#import "VoiceViewController.h"
#import "AskForLeaveView.h"
#import "UIImageView+WebCache.h"


@interface CourseDetailsViewController ()<UIActionSheetDelegate,ShareViewDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,MeetingTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIDocumentInteractionControllerDelegate,AlterViewDelegate,MessageViewControllerUserDelegate,AskForLeaveViewDelegate>

@property (nonatomic,assign)BOOL isEnable;


@property (strong, nonatomic)UserModel * user;
@property (strong, nonatomic) NSMutableArray * signAry;
@property (strong, nonatomic) NSMutableArray * notSignAry;

@property (nonatomic,assign)NSInteger n;//签到人数
@property (nonatomic,assign)NSInteger m;//未签到人数


@property (nonatomic,copy)NSString * selfSignStatus;

@property (nonatomic,copy)NSString * seatNo;

@property (nonatomic,assign)int temp;//记录mac不被覆盖

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)PhotoPromptBox * photoView;

@property (nonatomic,copy)NSString * pictureType;//标明是问答还是签到照片

@property (nonatomic,strong)AlterView * alterView;

@property (nonatomic,strong) NSTimer * t;

@property (nonatomic,strong)AskForLeaveView * askLeaveView;

@property (nonatomic,copy)NSString * laevePictureId;//请假图片id

@end

@implementation CourseDetailsViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _signAry = [NSMutableArray arrayWithCapacity:1];
    
    _notSignAry = [NSMutableArray arrayWithCapacity:1];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _n = 0;
    
    _m = 0;
    
    _temp = 0;
    
    _isEnable = NO;
    
    [self setNavigationTitle];
    
    [self getData];
    
    [self addTableView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}
-(void)viewDidAppear:(BOOL)animated{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.sclassId,@"id",_c.courseDetailId,@"courseDetailId", nil];
    [[NetworkRequest sharedInstance] GET:QueryCourseMemBer dict:dict succeed:^(id data) {
        //        NSLog(@"成功%@",data);
        NSArray *ary = [data objectForKey:@"body"];
        
        [_c.signAry removeAllObjects];
        
        for (int i = 0; i<ary.count;i++) {
            
            SignPeople * s = [[SignPeople alloc] init];
            
            [s setInfoWithDict:ary[i]];
        
            [_c.signAry addObject:s];
            
            if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"3"]) {
                _m = _m + 1;
                [_notSignAry addObject:s];
            }else{
                _n = _n + 1;
            }
            if ([[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",_user.peopleId]]) {
                if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"1"]) {
                    _selfSignStatus = @"签到状态：未签到";
                    _c.signStatus = @"1";
                }else if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"2"]){
                    _selfSignStatus = @"签到状态：已签到";
                    _c.signStatus = @"2";
                    _isEnable = YES;
                }else if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"3"]){
                    _selfSignStatus = @"签到状态：请假";
                    _c.signStatus = @"3";
                    _isEnable = YES;
                }else if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"4"]){
                    _selfSignStatus = @"签到状态：迟到";
                    _c.signStatus = @"4";
                    _isEnable = YES;
                }else if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"5"]){
                    _selfSignStatus = @"签到状态：早退";
                    _c.signStatus = @"5";
                    _isEnable = YES;
                }
                _seatNo = [NSString stringWithFormat:@"%@",s.seat];
            }
            [_signAry addObject:s];
        }
//        if ([[NSString stringWithFormat:@"%@",_c.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
            _c.n = (int)_n;
            _c.m = (int)_m;
//        }
        [self hideHud];
        [_tableView reloadData];
    } failure:^(NSError *error) {
//        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

        [self hideHud];
    }];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   
    self.title = @"课程";
    
}

-(void)signPictureUpdate{
    if (![[NSString stringWithFormat:@"%@",_c.signWay] isEqualToString:@"9"]) {
        [UIUtils showInfoMessage:@"已签到" withVC:self];
        return;
    }
    if (!_photoView) {
        _photoView = [[PhotoPromptBox alloc] initWithBlack:^(NSString * str) {
            [_photoView removeFromSuperview];
        } WithTakePictureBlack:^(NSString *str) {
            [self selectImage];
            [_photoView removeFromSuperview];
        }];
        _photoView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    }
    _pictureType = @"SignPicture";
    [self.view addSubview:_photoView];
}

//选择照片完成之后的代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //info是所选择照片的信息
    
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    
    
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        // 异步执行任务创建方法
//        dispatch_async(queue, ^{
            UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            
            //    NSString * filePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
            
            NSString * str = [NSString stringWithFormat:@"%@-%@-%@",user.userName,user.studentId,[UIUtils getTime]];
            
            if ([_pictureType isEqualToString:@"LeavePicture"]) {
                
                [self hideHud];
                [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
                
                NSDictionary * dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",str,@"description",@"25",@"function",[NSString stringWithFormat:@"%@",_c.sclassId],@"relId",@"false",@"deleteOld",nil];
                
                [[NetworkRequest sharedInstance] POSTImage:FileUpload image:resultImage dict:dict1 succeed:^(id data) {
                    NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
                    if ([code isEqualToString:@"0000"]) {
                        
                        _laevePictureId = [NSString stringWithFormat:@"%@",[data objectForKey:@"body"][0]];
                        
                        UIImageView * image = [[UIImageView alloc] init];
                        
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",_user.host,FileDownload,_laevePictureId]]];
                        
                        image.image = [UIImage imageWithData:data];
                        
                        [_askLeaveView.picturebtn setBackgroundImage:image.image forState:UIControlStateNormal];
                        
                    }else{
                        [UIUtils showInfoMessage:@"图片上传失败，请重新上传" withVC:self];
                    }
                    [self hideHud];
                } failure:^(NSError *error) {
                    [UIUtils showInfoMessage:@"上传失败,请检查网络" withVC:self];
                    [self hideHud];
                }];
                
                
            }else if ([_pictureType isEqualToString:@"SignPicture"]){
                
                NSDictionary * dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",str,@"description",@"10",@"function",[NSString stringWithFormat:@"%@",_c.courseSignId],@"relId",@"true",@"deleteOld",nil];
                
                UIImage * image = [UIUtils addWatemarkTextAfteriOS7_WithLogoImage:resultImage watemarkText:[NSString stringWithFormat:@"%@-%@-%@",_user.userName,_user.studentId,[UIUtils getCurrentDate]]];
                
                [[NetworkRequest sharedInstance] POSTImage:FileUpload image:image dict:dict1 succeed:^(id data) {
                    NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
                    if ([code isEqualToString:@"0000"]) {
                        [UIUtils showInfoMessage:@"上传成功" withVC:self];
                    }else{
                        [UIUtils showInfoMessage:@"上传失败" withVC:self];
                    }
                } failure:^(NSError *error) {
                    [UIUtils showInfoMessage:@"上传失败，请检查网络" withVC:self];
                }];
            }
            
//        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AlterView
-(void)alterViewDeleageRemove{
    
    [_alterView removeFromSuperview];
    
    [_t invalidate];
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
        [cell addFirstCOntentViewWithClassModel:_c];
    }else if (indexPath.section == 2){
        if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_c.teacherId]]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellSecond"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:1];
            }
            [cell addSecondContentViewWithClassModel:_c];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellThird"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:2];
            }
            [cell addThirdContentViewWithClassModel:_c isEnable:_isEnable];
        }
        
    }else if (indexPath.section==1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellFourth"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:3];
        }
        [cell addFourthContentViewWithClassModel:_c];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 300;
    }else if (indexPath.section==1){
        return 220;
    }else if (indexPath.section==2){
        return 60;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma mark - MessageViewControllerUserDelegate
//从本地获取用户信息, IUser的name字段为空时，显示identifier字段
- (IUser*)getUser:(int64_t)uid {
    IUser *u = [[IUser alloc] init];
    u.uid = uid;
    u.name = @"";
    u.avatarURL = @"http://api.gobelieve.io/images/e837c4c84f706a7988d43d62d190e2a1.png";
    u.identifier = [NSString stringWithFormat:@"uid:%lld", uid];
    return u;
}
//从服务器获取用户信息
- (void)asyncGetUser:(int64_t)uid cb:(void(^)(IUser*))cb {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IUser *u = [[IUser alloc] init];
        u.uid = uid;
        u.name = [NSString stringWithFormat:@"name:%lld", uid];
        u.avatarURL = @"http://api.gobelieve.io/images/e837c4c84f706a7988d43d62d190e2a1.png";
        u.identifier = [NSString stringWithFormat:@"uid:%lld", uid];
        dispatch_async(dispatch_get_main_queue(), ^{
            cb(u);
        });
    });
}
#pragma mark - AskForLeaveViewDelegate
-(void)askForLeaveWithReationDelegate:(NSString *)reasionStr{
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",reasionStr],@"reason",_laevePictureId,@"resourceId",[NSString stringWithFormat:@"%@",_c.courseDetailId],@"detailId",nil];
    
    [[NetworkRequest sharedInstance] POST:StudentLeave dict:dict succeed:^(id data) {
        [self outSelfViewDelegate];
       
        [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        
        NSString *message = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        
        [UIUtils showInfoMessage:message withVC:self];

        
    } failure:^(NSError *error) {
        
        [UIUtils showInfoMessage:@"请假失败,服务器异常" withVC:self];
        
    }];
}
-(void)picturebtnPressedDelegate:(UIButton *)btn{
    
    _pictureType = @"LeavePicture";
    
    [self selectImage];
    
}
-(void)outSelfViewDelegate{
    [_askLeaveView removeFromSuperview];
    _askLeaveView = nil;
}
-(void)endEditeDelegate{
    [self.view endEditing:YES];
}
#pragma mark MeetingCellDelegate
-(void)shareButtonClickedDelegate:(NSString *)platform{

    if ([platform isEqualToString:InteractionType_Vote]){
        VoteViewController * v = [[VoteViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        v.classModel = _c;
        v.type = @"classModel";
        [self.navigationController pushViewController:v animated:YES];
        NSLog(@"投票");
    }else if ([platform isEqualToString:InteractionType_Data]){
        NSLog(@"资料");
        DataDownloadViewController * d = [[DataDownloadViewController alloc] init];
        d.classModel = _c;
        d.type = @"classModel";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: d animated:YES];
    }else if ([platform isEqualToString:InteractionType_Responder]){
        NSLog(@"抢答");
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];

        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"relType", [NSString stringWithFormat:@"%@",_c.courseDetailId],@"relDetailId",nil];
        [[NetworkRequest sharedInstance] POST:StudentGointo dict:dict succeed:^(id data) {
            NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
            if ([code isEqualToString:@"成功"]||[code isEqualToString:@"该用户已经进入互动"]) {
                VoiceViewController* msgController = [[VoiceViewController alloc] init];
                msgController.userDelegate = self;
                
                NSString * str = [NSString stringWithFormat:@"%@%@",_user.school,_c.teacherWorkNo];
                NSString * str1 = [NSString stringWithFormat:@"%@%@",_user.school,_user.studentId];
                
                msgController.peerUID = [str integerValue];//con.cid;
                
                msgController.peerName = _c.teacherName;//con.name;
                
                msgController.currentUID = [str1 integerValue];
                
                msgController.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:msgController animated:YES];
            }else{
                [UIUtils showInfoMessage:code withVC:self];
            }
            [self hideHud];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"抢答失败" withVC:self];
            [self hideHud];
        }];
    }
    else if ([platform isEqualToString:InteractionType_Test]){
        NSLog(@"测试");
        self.hidesBottomBarWhenPushed = YES;
        TestAllViewController * textVC = [[TestAllViewController alloc] init];
        textVC.classModel = _c;
        [self.navigationController pushViewController:textVC animated:YES];
    }else if ([platform isEqualToString:InteractionType_Discuss]){
        MessageListViewController * d = [[MessageListViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        d.type = @"enableCreate";
        d.peopleAry = [NSMutableArray arrayWithArray:_c.signAry];
        [self.navigationController pushViewController:d animated:YES];
        NSLog(@"讨论");
    }else if ([platform isEqualToString:InteractionType_Picture]){
        PictureQuizViewController * d = [[PictureQuizViewController alloc] init];
        d.classModel = _c;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: d animated:YES];
        
    }else if ([platform isEqualToString:InteractionType_Sit]){
        [self getCourseRoomSeat];
    }else if ([platform isEqualToString:InteractionType_Homework]){
        HomeWorkViewController * vc = [[HomeWorkViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        vc.c = _c;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([platform isEqualToString:Leave]){
        if (!_askLeaveView) {
            _askLeaveView = [[AskForLeaveView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        }
        [_askLeaveView addContentViewWithAry:nil];
        _askLeaveView.delegate = self;
        [self.view addSubview:_askLeaveView];
    }
    else if ([platform isEqualToString:InteractionType_Add]){
        NSLog(@"更多");
    }
}

//课程抢答收集
-(void)sentNumberResponder{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.courseDetailId,@"detailId",_user.peopleId,@"userId",@"1",@"type",@"0",@"successNum",nil];
    [[NetworkRequest sharedInstance] POST:ClassResponder dict:dict succeed:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)getCourseRoomSeat{
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_c.courseDetailId],@"courseDetailId", nil];
    [[NetworkRequest sharedInstance] GET:QueryRoomSeat dict:dict succeed:^(id data) {
        //        NSLog(@"%@",data);
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            ZFSeatViewController * z = [[ZFSeatViewController alloc] initWithAction:^(NSString *str) {
                [self getData];
            }];
            z.seatTable = [NSString stringWithFormat:@"%@",[data objectForKey:@"body"]];
            z.type = @"class";
            z.classModel = _c;
            z.seat = _seatNo;
            self.hidesBottomBarWhenPushed = YES;
            if (![UIUtils isBlankString:z.seatTable]) {
                [self.navigationController pushViewController:z animated:YES];
            }else{
                [UIUtils showInfoMessage:@"会场拉取失败，请稍微在操作" withVC:self];
            }
        }else{
            NSString * str1 = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
            
            [UIUtils showInfoMessage:str1 withVC:self];
        }
        [self hideHud];

    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"请求失败，请检查网络" withVC:self];
        [self hideHud];

    }];
}
-(void)peopleManagementDelegate{
    ClassManagementViewController * classManegeVC = [[ClassManagementViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    classManegeVC.manage = ClassManageType;
    classManegeVC.signAry = [NSMutableArray arrayWithCapacity:1];
    classManegeVC.signAry = _signAry;
    [self.navigationController pushViewController:classManegeVC animated:YES];
}
-(void)signNOPeopleDelegate{
    SignListViewController * signListVC = [[SignListViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    signListVC.signType = SignClassRoom;
    signListVC.ary = [NSMutableArray arrayWithCapacity:1];
    signListVC.ary = _notSignAry;
    [self.navigationController pushViewController:signListVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_c.teacherId]]) {
        return;
    }
    if (![UIUtils validateWithStartTime:_c.signStartTime withExpireTime:nil]) {
        return;
    }else{
        if (![[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"1"]) {
            return;
        }else{
            [self autoSign];
        }
    }
}
-(void)autoSign{
    if (![UIUtils validateWithStartTime:_c.signStartTime withExpireTime:nil]) {
  
        return;
    }else{
        if (![[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"1"]) {
            return;
        }
    }
    
    _isEnable = YES;
    [_tableView reloadData];
    NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
    
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",[dictWifi objectForKey:@"BSSID"]]]) {
        
        NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
        
        if ([UIUtils matchingMacWith:_c.mck withMac:bssid]) {
            _temp = 1;
            [self signSendIng];
            [self sendSignInfo];
            
        }else if (_temp == 1){
            
            [self signSendIng];
            [self sendSignInfo];
            
        }else{
            self.alterView = [[AlterView alloc] initWithFrame:CGRectMake(20, 100, APPLICATION_WIDTH-40, 100) withAlterStr:@"未连接上教室指定WiFi"];
            self.alterView.delegate = self;
            [self.view addSubview:self.alterView];
            [self removeView];
        }
        
    }else{
        self.alterView = [[AlterView alloc] initWithFrame:CGRectMake(20, 100, APPLICATION_WIDTH-40, 100) withAlterStr:@"未连接上教室指定WiFi"];
        self.alterView.delegate = self;
        [self.view addSubview:self.alterView];
        [self removeView];
    }
}
-(void)signBtnPressedDelegate:(UIButton *)btn{
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];


    if (![UIUtils validateWithStartTime:_c.signStartTime withExpireTime:nil]) {
        if (![[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"1"]) {
            [UIUtils showInfoMessage:@"已签到" withVC:self];
        }else{
            
            NSString * str = [UIUtils dateTimeDifferenceWithStartTime:_c.signStartTime];
            
            if ([UIUtils isBlankString:str]) {
                [UIUtils showInfoMessage:@"签到已过期" withVC:self];
            }else{
                [UIUtils showInfoMessage:[NSString stringWithFormat:@"距离签到还有 %@",str] withVC:self];
            }
        }
        [self hideHud];
        return;
    }else{
        if (![[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"1"]&&![UIUtils isBlankString:_c.signStatus]) {
//            [UIUtils showInfoMessage:@"已签到"];

            [self hideHud];
            [self signPictureUpdate];
            return;
        }
    }
    
    _isEnable = YES;
    [_tableView reloadData];
    NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
    
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",[dictWifi objectForKey:@"BSSID"]]]) {
        
        NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
        
        if ([UIUtils matchingMacWith:_c.mck withMac:bssid]) {
            
            [[Appsetting sharedInstance] saveWiFiMac:bssid];
            
            _temp = 1;
            [self signSendIng];
            [self sendSignInfo];
            
        }else if (_temp == 1){
            
            [self signSendIng];
            [self sendSignInfo];
            
        }else if ([UIUtils determineWifiAndtimeCorrect:_c.mck]){
            [self signSendIng];
            [self sendSignInfo];
        }else{
            NSString * str = [NSString stringWithFormat:@"请连接老师指定wifi，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，点击签到按钮若网络情况不好，请断开WiFi连接数据流量再次点击签到"];
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
                
            }];
            
            [alertC addAction:alertA];
            
            [self presentViewController:alertC animated:YES completion:nil];
            [self hideHud];
            
        }
        
    }else{
//        NSString * s =[UIUtils returnMac:_c.mck];
        NSString * str = [NSString stringWithFormat:@"请连接老师指定wifi，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，点击签到按钮若网络情况不好，请断开WiFi连接数据流量再次点击签到"];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            
        }];
        
        [alertC addAction:alertA];
        
        [self presentViewController:alertC animated:YES completion:nil];
        [self hideHud];
        
    }
}
-(void)signSendIng{
    _c.signStatus = @"300";
    [_tableView reloadData];
}
-(void)sendSignInfo{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.sclassId,@"Id",_c.courseDetailId,@"courseDetailId",_user.peopleId,@"userId" ,idfv,@"mck",@"2",@"status",nil];
    
    [[NetworkRequest sharedInstance] POST:ClassSign dict:dict succeed:^(id data) {
        
//        [self alter:[[data objectForKey:@"header"] objectForKey:@"code"]];
        
//        NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        
        NSString *message = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        
        _c.signStatus = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"status"]];
        
        _c.courseSignId = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"id"]];
        
        if (![_c.signStatus isEqualToString:@"1"]&&![UIUtils isBlankString:_c.signStatus]) {
            [self signPictureUpdate];
            // 2.创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheClassPage" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
            _c.signStatus = @"1";
            [UIUtils showInfoMessage:message withVC:self];
        }
        
        [self hideHud];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
        NSString * str = [NSString stringWithFormat:@"签到失败请重新签到，请保证数据流量的连接后再次点击"];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            
        }];
        
        [alertC addAction:alertA];
        
        [self presentViewController:alertC animated:YES completion:nil];
        
        [self hideHud];
        
        _c.signStatus = @"400";
        
        [_tableView reloadData];
        
    }];
}

-(void)codePressedDelegate:(UIButton *)btn{
    if ([_c.signStatus isEqualToString:@"1"]) {
        if (![UIUtils validateWithStartTime:_c.signStartTime withExpireTime:nil]) {
            NSString * str = [UIUtils dateTimeDifferenceWithStartTime:_c.signStartTime];
            if ([UIUtils isBlankString:str]) {
                [UIUtils showInfoMessage:@"签到已过期" withVC:self];
            }else{
                [UIUtils showInfoMessage:[NSString stringWithFormat:@"距离签到还有 %@",str] withVC:self];
            }            return;
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
            
            if ([UIUtils matchingMacWith:_c.mck withMac:bssid]) {
                NSString * interval = [UIUtils getCurrentTime];
                NSString * checkcodeLocal = [NSString stringWithFormat:@"%@dayaokeji",interval];
                NSString * md5 = [UIUtils md5:checkcodeLocal];
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:interval,@"date",_c.mck,@"loc_array",md5,@"checkcode",nil];
                QrCodeViewController * q = [[QrCodeViewController alloc] init];
                q.mck = [[NSMutableArray alloc] initWithArray:_c.mck];
                self.hidesBottomBarWhenPushed = YES;
                q.dict = dict;
                [self.navigationController pushViewController:q animated:YES];
            }else{
                [UIUtils showInfoMessage:@"请在连接指定的DAYAO或XTU开头的WiFi下生成二维码" withVC:self];
            }
        }else{
            [UIUtils showInfoMessage:@"请连接老师指定WiFi下生成二维码" withVC:self];
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
        NSString * md5 = [UIUtils md5:checkcodeLocal];
        if ([md5 isEqualToString:checkcode]) {
            if ([UIUtils dateTimeDifferenceWithStartTime:dateTime withTime:CodeEffectiveTime]) {
                if ([UIUtils returnMckIsHave:_c.mck withAccept:loc_array]) {
                    [self sendSignInfo];
                }else{
                    NSString *string1 = [loc_array componentsJoinedByString:@","];
                    NSString *string2 = [_c.mck componentsJoinedByString:@","];
                    [UIUtils showInfoMessage:[NSString stringWithFormat:@"二维码有误，请重新扫描或者连接指定WiFi签到(扫描的mac地址为%@，录入的mac为%@)",string1,string2] withVC:self];
                }
            }else{
                [UIUtils showInfoMessage:[NSString stringWithFormat:@"二维码失效，请重新扫描或者连接指定WiFi签到(扫码时间为%@，二维码生成时间为%@)",dateTime,[UIUtils getTime]] withVC:self];
            }
        }else{
            [UIUtils showInfoMessage:@"二维码无效，请重新扫描或者连接指定WiFi签到（MD5异常）" withVC:self];
        }
    }else{
        [UIUtils showInfoMessage:@"二维码无效，请重新扫描或者连接指定WiFi签到（二维码解析内容为空）" withVC:self];
    }
    
}


//实现button点击事件的回调方法
- (void)selectImage{
    
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    //设置相册呈现的样式
    
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //    //分别按顺序放入每个按钮；
    //    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;//图片分组列表样式
    
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
    //使用模态呈现相册
    [self.navigationController presentViewController:pickerController animated:YES completion:^{
        
    }];
   
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
  
    
}

@end

