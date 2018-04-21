//
//  ConversationVC.m
//  EMChatText
//
//  Created by zzjd on 2017/3/17.
//  Copyright © 2017年 zzjd. All rights reserved.
//

#import "ConversationVC.h"

#import <AVFoundation/AVFoundation.h>
#import "DYHeader.h"
#import "DYTabBarViewController.h"
#import "EMCallOptions+NSCoding.h"

#import <Hyphenate/Hyphenate.h>

@interface ConversationVC ()<EMCallManagerDelegate,AVAudioPlayerDelegate>

@property (nonatomic,strong)UIView * videoView;


@property (nonatomic,strong)UIButton * hangupBtn;
@property (nonatomic,strong)UIButton * receiveBtn;



@property (nonatomic,strong)UILabel * typeLab;
@property (nonatomic,assign) int n;
@property (nonatomic,assign) int m;
@property (nonatomic,assign) EMCallEndReason reasonA;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@end

@implementation ConversationVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonDecline];
        _callSession = nil;
    }
    if (self.reasonBlock != nil) {
        self.reasonBlock(_reasonA);
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (!_callSession) {
        [self playMusic:@"call"];
        
        //        视频之前，设置全局的音视频属性，具体属性有哪些请查看头文件 *EMCallOptions*
        
        EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
        //当对方不在线时，是否给对方发送离线消息和推送，并等待对方回应
        
        options.isSendPushIfOffline = NO;
        
        [[EMClient sharedClient].callManager setCallOptions:options];
        if (_call == CALLED) {
            [self createUI];
            return;
        }
        // NSString * string = ([[[EMClient sharedClient] currentUsername] isEqualToString:@"aaaaa111"])?@"aaaaa1111":@"aaaaa111";
        
        //15243670131"
        [[EMClient sharedClient].callManager startCall:EMCallTypeVoice remoteName:_HyNumaber ext:nil completion:^(EMCallSession *aCallSession, EMError *aError) {
            
            if (!aError) {
                _callSession = aCallSession;
                [self createUI];
            }else{
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
                
            }
            
        }];
    }else{
        [self playMusic:@"called"];
        
        [self createUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _n = 0;
    _m = 0;
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    image.image = [UIImage imageNamed:@"callBg"];
    [self.view addSubview:image];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Do any additional setup after loading the view.
}
-(void)playMusic:(NSString *)str{
    // 1.获取要播放音频文件的URL
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:str withExtension:@".mp3"];
    // 2.创建 AVAudioPlayer 对象
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    
    // 3.设置循环播放
    self.audioPlayer.numberOfLoops = -1;
    self.audioPlayer.delegate = self;
    // 4.开始播放
    [self.audioPlayer play];
}
-(void)createUI{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//休眠关闭
    
    if (!_hangupBtn) {
        
        _hangupBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _hangupBtn.frame = CGRectMake(30, APPLICATION_HEIGHT-70, APPLICATION_WIDTH-60, 40);
        
        [_hangupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_hangupBtn setBackgroundColor:[UIColor redColor]];
        
        
        if (_call == CALLED) {
            [_hangupBtn setTitle:@"接受" forState:UIControlStateNormal];
            
            [_hangupBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_hangupBtn setTitle:@"挂断" forState:UIControlStateNormal];
            
            [_hangupBtn addTarget:self action:@selector(hangupBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        [self.view addSubview:_hangupBtn];
    }
  
    
    UIButton * handsFree = [UIButton buttonWithType:UIButtonTypeCustom];

    handsFree.frame = CGRectMake(APPLICATION_WIDTH/2-50, CGRectGetMaxY(_hangupBtn.frame)-40-100-30, 100, 100);

    [handsFree setBackgroundImage:[UIImage imageNamed:@"call_silence"] forState:UIControlStateNormal];

    [handsFree addTarget:self action:@selector(handsFree:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:handsFree];
    
    
    if (!_receiveBtn) {
        _receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _receiveBtn.frame = CGRectMake(30, APPLICATION_HEIGHT-110, APPLICATION_WIDTH-60, 40);
        
        _receiveBtn.backgroundColor = [UIColor redColor];
        
        [_receiveBtn setTitle:@"receive" forState:UIControlStateNormal];
        
        [_receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //[self.view addSubview:_receiveBtn];
    }
    if (!_typeLab) {
        
        _typeLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, APPLICATION_WIDTH-40, 40)];
        
        _typeLab.textAlignment = NSTextAlignmentCenter;
        
        [_typeLab setTextColor:[UIColor whiteColor]];
        
        [self.view addSubview:_typeLab];
    }
    _typeLab.text = @"正在连接";
    
    
    UIImageView * headIamge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatListCellHead"]];
    
    
    headIamge.frame = CGRectMake(APPLICATION_WIDTH/2-30, 200, 60, 60);
    
    [self.view addSubview:headIamge];
    
    UILabel * teacherName = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, APPLICATION_WIDTH, 20)];
    
    teacherName.text = _teacherName;
    
    teacherName.textAlignment = NSTextAlignmentCenter;
    
    [teacherName setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:teacherName];
    
    
    
    if (_type == 1) {
        
        //对方窗口
        _callSession.remoteVideoView = [[EMCallRemoteView alloc]initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        _callSession.remoteVideoView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_callSession.remoteVideoView];
        
        
        //自己窗口
        _callSession.localVideoView = [[EMCallLocalView alloc]initWithFrame:CGRectMake(APPLICATION_WIDTH-100, 64, 80, 120)];
        [self.view addSubview:_callSession.localVideoView];
        
    }
    
    [self.view bringSubviewToFront:_hangupBtn];
    
    
    
}
-(void)callSilence:(UIButton *)btn{
    if (_n == 0) {
        _n = 1;
        [btn setBackgroundImage:[UIImage imageNamed:@"call_out_h"] forState:UIControlStateNormal];
        [self setSpeakerOn];
    }else if (_n == 1){
        _n = 0;
        [btn setBackgroundImage:[UIImage imageNamed:@"call_out"] forState:UIControlStateNormal];
        [self setSpeakerOff];
    }
    
}
- (void)setSpeakerOff

{
    
    
    
    UInt32 doChangeDefaultRoute = kAudioSessionOverrideAudioRoute_None;
    
    
    
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                             
                             sizeof (doChangeDefaultRoute),
                             
                             &doChangeDefaultRoute
                             
                             );
    
    
    
    //    _isSpeakerOn = [self checkSpeakerOn];
    
}
- (void)setSpeakerOn

{
    
    NSLog(@"setSpeakerOn:%d",[NSThread isMainThread]);
    
    UInt32 doChangeDefaultRoute = kAudioSessionOverrideAudioRoute_Speaker;
    
    
    
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                             
                             sizeof (doChangeDefaultRoute),
                             
                             &doChangeDefaultRoute
                             
                             );
    
    
    
    //    _isSpeakerOn = [self checkSpeakerOn];
    //
    //    _isHeadsetOn = NO;
    //
    
    
    //[self resetOutputTarget];
    
}
- (BOOL)checkSpeakerOn

{
    
    CFStringRef route;
    
    UInt32 propertySize = sizeof(CFStringRef);
    
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    
    
    
    if((route == NULL) || (CFStringGetLength(route) == 0))
        
    {
        
        // Silent Mode
        
        NSLog(@"AudioRoute: SILENT, do nothing!");
        
    }
    
    else
        
    {
        
        NSString* routeStr = (__bridge NSString*)route;
        
        NSRange speakerRange = [routeStr rangeOfString : @"Speaker"];
        
        if (speakerRange.location != NSNotFound)
            
            return YES;
        
    }
    
    
    
    return NO;
    
}
-(void)handsFree:(UIButton *)btn{
    if (_m == 0) {
        _m = 1;
        [btn setBackgroundImage:[UIImage imageNamed:@"call_silence_h"] forState:UIControlStateNormal];
        [self.callSession pauseVoice];
        
        
    }else if(_m == 1){
        _m = 0;
        [btn setBackgroundImage:[UIImage imageNamed:@"call_silence"] forState:UIControlStateNormal];
        [self.callSession resumeVoice];
        
    }
    
}
/*!
 *  \~chinese
 *  通话通道建立完成，用户A和用户B都会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidConnect:(EMCallSession *)aSession{
    NSLog(@"callDidConnect 通话通道完成");
    if ([aSession.callId isEqualToString:_callSession.callId]) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
    
}

/*!
 *  \~chinese
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidAccept:(EMCallSession *)aSession{
    
    NSLog(@"callDidAccept 同意通话");
    _typeLab.text = @"正在通话中";
    [_audioPlayer stop];
    
    
}

/*!
 *  \~chinese
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 */
- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError{
    
    NSLog(@"callDidEnd 通话结束 ：%@  reason = %u",aError.errorDescription,aReason);
    
    _reasonA = aReason;
    
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    
    _callSession = nil;
    if (self.navigationController.viewControllers.count>1) {
        [self dismissViewControllerAnimated:YES completion:^{

        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
           
        }];
        
        //        DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
        //        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
    
}
-(void)returnReason:(refused)reasonBlock{
    _reasonBlock = reasonBlock;
}

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A中断或者继续数据流传输时，用户B会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aType     改变类型
 */
- (void)callStateDidChange:(EMCallSession *)aSession
                      type:(EMCallStreamingStatus)aType{
    
    NSLog(@"callStateDidChange 用户A和用户B正在通话中，用户A中断或者继续数据流传输");
    
}



#pragma mark -------------------同意

-(void)receiveBtnClick:(UIButton *)btn{
    
    EMError * error = [[EMClient sharedClient].callManager answerIncomingCall:_callSession.callId];
    
    if (error) {
        [_audioPlayer stop];
        
        NSLog(@"receiveBtnClick errorDescription = %@",error.errorDescription);
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonFailed];
    }else{
        [_hangupBtn setTitle:@"挂断" forState:UIControlStateNormal];
        
        [_hangupBtn addTarget:self action:@selector(hangupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark -------------------挂断

-(void)hangupBtnClick{
    

    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonDecline];
        _callSession = nil;
    }
    //    if (self.call == CALLING) {
    [self.navigationController popViewControllerAnimated:YES];
    //    }else{
    //        DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
    //        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    //    }
}



-(void)dealloc{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//休眠关闭
    
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonDecline];
        _callSession = nil;
    }
    
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonHangup];
    }
    
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    _callSession = nil;
    
    
    //    [self stopSystemSound];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

