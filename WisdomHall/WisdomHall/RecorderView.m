//
//  RecorderView.m
//  Recorder
//
//  Created by Japho on 15/10/15.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import "RecorderView.h"
#import <AVFoundation/AVFoundation.h>
//#import "Header.h"

#define LIGHT_WHITE_COLOR [UIColor colorWithRed:231.0/255.0f green:231.0/255.0f blue:231.0/255.0f alpha:1.0f]
#define LIGHT_GREEN_COLOR [UIColor colorWithRed:83.0/255.0f green:181.0/255.0f blue:70.0/255.0f alpha:1.0f]
#define LIGHT_RED_COLOR [UIColor colorWithRed:239.0/255.0f green:86.0/255.0f blue:70.0/255.0f alpha:1.0f]

#define COUNT 30

@interface RecorderView ()
{
    UIImageView *_microphone;
    UIImageView *_microphoneInside;//麦克风内部
    AVAudioRecorder *_recorder;//录音器
    NSTimer *_listenAveragePowerTimer;//监听录音的平均力度的定时器
    NSString *_tempPath;//语音缓存路径
    UILabel *_countLabel;//倒计时标签
    NSTimer *_countTimer;//倒计时计时器
    int _count;
}
@end

@implementation RecorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImage *microphoneImage = [UIImage imageNamed:@"lp_microphone"];
        _microphone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, microphoneImage.size.width, microphoneImage.size.height)];
        _microphone.center = self.center;
        _microphone.image = microphoneImage;
        [self addSubview:_microphone];
        
        UIImage *microphoneInsideImage = [UIImage imageNamed:@"lp_microphone_inside1"];
        _microphoneInside = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, microphoneInsideImage.size.width, microphoneInsideImage.size.height)];
        _microphoneInside.center = CGPointMake(_microphone.bounds.size.width / 2, _microphone.bounds.size.height / 2 - 10);
        [_microphoneInside setImage:microphoneInsideImage];
        [_microphone addSubview:_microphoneInside];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.bounds.size.width, 80)];
        [_countLabel setFont:[UIFont boldSystemFontOfSize:80]];
        [_countLabel setTextAlignment:NSTextAlignmentCenter];
        [_countLabel setTextColor:LIGHT_GREEN_COLOR];
        [self addSubview:_countLabel];
    }
    return self;
}

//显示
- (void)showInView:(UIView *)view
{
    [self startRecording];
    
    [view addSubview:self];
    [UIView animateWithDuration:0.4f animations:^{
        [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
    } completion:^(BOOL finished) {
    }];
}

//隐藏
- (void)hide
{
    if ([_recorder isRecording])
    {
        [self stopRecording];
    }
    
    [UIView animateWithDuration:0.4f animations:^{
        [self setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        if (self.superview)
        {
            [self removeFromSuperview];
        }
    }];
}

//开始录音
- (void)startRecording
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
        {
            NSLog(@"Error creating session: %@", [sessionError description]);
        }
        else
        {
            [session setActive:YES error:nil];
        }
    }
    
    //开始录音时 倒计时重置
    _count = COUNT;
    [_countLabel setText:[NSString stringWithFormat:@"%d",_count]];
    [_countLabel setTextColor:LIGHT_GREEN_COLOR];
    
    if (!_tempPath)
    {
        NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tempPath"];
        
        //判断是否存在该路径
        if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //语音存储路径
        tempPath = [tempPath stringByAppendingPathComponent:@"tempAudio.m4a"];
        
        _tempPath = tempPath;
        
    }
    if (!_recorder)
    {
        NSURL *tempPathUrl = [NSURL fileURLWithPath:_tempPath];
        
        NSLog(@"%@",tempPathUrl);
        
        //录音设置字典，设置录音格式为m4a，设置采样频率为22050.0，设置音频通道为1，设置录音质量为最低
        NSMutableDictionary* recordSetting = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                                              [NSNumber numberWithFloat:22050.0], AVSampleRateKey,
                                              [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                              [NSNumber numberWithInt:AVAudioQualityMin], AVEncoderAudioQualityKey,
                                              [NSNumber numberWithInt:AVAudioQualityMin], AVSampleRateConverterAudioQualityKey,
                                              [NSNumber numberWithInt:8], AVLinearPCMBitDepthKey,
                                              [NSNumber numberWithInt:8], AVEncoderBitDepthHintKey,
                                              nil];
        _recorder = [[AVAudioRecorder alloc] initWithURL:tempPathUrl
                                                settings:recordSetting
                                                   error:nil];
    }
    
    [_recorder prepareToRecord];
    [_recorder setMeteringEnabled:YES];
    [_recorder record];
    
    if (!_listenAveragePowerTimer)
    {
        _listenAveragePowerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(listenAveragePower) userInfo:nil repeats:YES];
    }
    [_listenAveragePowerTimer setFireDate:[NSDate distantPast]];
    
    if (!_countTimer)
    {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    
    [_countTimer setFireDate:[NSDate distantPast]];
}

//结束录音
- (void)stopRecording
{
    _recordSecond = _recorder.currentTime;
    
    NSString *newPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/newPath"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:newPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
//    newPath = [newPath stringByAppendingPathComponent:[NSString stringWithFormat:@"newAudio%d.m4a",_index]];
    newPath = [newPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",_audioName]];
    _myNewPath = newPath;
    
    //结束录音
    [_recorder stop];
    //关闭定时器
    [_listenAveragePowerTimer setFireDate:[NSDate distantFuture]];
    [_countTimer setFireDate:[NSDate distantFuture]];
    
    if (_recordSecond > 0)
    {
        NSLog(@"nnn %d",_recordSecond);
        
        [[NSFileManager defaultManager] removeItemAtPath:_myNewPath error:nil];
        
        [[NSFileManager defaultManager] moveItemAtPath:_tempPath toPath:_myNewPath error:nil];
    }
    else
    {
        [_recorder deleteRecording];
        
    }
}

- (void)listenAveragePower
{
    [_recorder updateMeters];
    CGFloat averagePower = [_recorder averagePowerForChannel:0];
    NSLog(@"average power %f",averagePower);
    int imageIndex;
    if (averagePower <= - 50.543) {
        imageIndex = 1;
    } else if ( - 50.543 <averagePower && averagePower<= - 46.686) {
        imageIndex = 1;
    } else if ( - 46.686 <averagePower && averagePower<= - 42.829) {
        imageIndex = 1;
    } else if ( - 42.829 <averagePower && averagePower<= - 38.982) {
        imageIndex = 1;
    } else if ( - 38.982 <averagePower && averagePower<= - 35.135) {
        imageIndex = 2;
    } else if ( - 35.135 <averagePower && averagePower<= - 31.288) {
        imageIndex = 3;
    } else if ( - 31.288 <averagePower && averagePower<= - 27.441) {
        imageIndex = 4;
    } else if ( - 27.441 <averagePower && averagePower<= - 23.594) {
        imageIndex = 5;
    } else if ( - 23.594 <averagePower && averagePower<= - 19.747) {
        imageIndex = 6;
    } else if ( - 19.747 <averagePower && averagePower<= - 15.900) {
        imageIndex = 7;
    } else if ( - 15.900 <averagePower && averagePower<= - 12.053) {
        imageIndex = 8;
    } else if ( - 12.053 <averagePower && averagePower<= - 8.206) {
        imageIndex = 9;
    } else if ( - 8.206 <averagePower && averagePower<= - 4.359) {
        imageIndex = 9;
    } else if ( - 4.359 <averagePower && averagePower<= 0) {
        imageIndex = 9;
    } else {
        imageIndex = 9;
    }
    
//    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"lp_microphone_inside%d",imageIndex]];
//    [_microphoneInside setImage:image];
    _microphoneInside.image = [UIImage imageNamed:[NSString stringWithFormat:@"lp_microphone_inside%d",imageIndex]];
}

//倒计时
- (void)countDown
{
    if (_count <= 10)
    {
        [_countLabel setTextColor:LIGHT_RED_COLOR];
    }
    else
    {
        [_countLabel setTextColor:LIGHT_GREEN_COLOR];
    }
    
    if (_count == 0)
    {
        [self hide];
    }
    [_countLabel setText:[NSString stringWithFormat:@"%d",_count]];
    _count--;
}


@end
