//
//  MJXTabBarController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/29.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXTabBarController.h"
#import "MJXMyPatientsViewController.h"
#import "MJXConsultingViewController.h"
#import "MJXFollowUpViewController.h"
#import "MJXPersonalCenterViewController.h"
#import "UIImageView+WebCache.h"


#import "FMDBTool.h"


@interface MJXTabBarController ()<RCIMClientReceiveMessageDelegate>
@property (nonatomic,strong)FMDatabase *db;
@property (nonatomic,strong)NSMutableDictionary * dict;
@property (nonatomic,copy)NSString * chatToken;
@property (nonatomic,strong) UIImageView * image;
@property (nonatomic,strong) UIImageView * imageV;
@end

@implementation MJXTabBarController
//监听结束需要移除
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//单例初始化
+ (MJXTabBarController *)sharedInstance
{
    static MJXTabBarController *sharedMJXTabBarControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedMJXTabBarControllerInstance = [[self alloc] init];
    });
    return sharedMJXTabBarControllerInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getChatToken];
    // 设置消息接收监听
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    
    
    _image = [[UIImageView alloc] init];
    _imageV = [[UIImageView alloc] init];
    _message = [[RCMessage alloc] init];
    
    [self addChildViewControllerWithClassname:[MJXMyPatientsViewController description] imagename:@"gray-patient" title:@"我的患者" withSelectImageName:@"patient"];
    [self addChildViewControllerWithClassname:[MJXConsultingViewController description] imagename:@"xiaoxi" title:@"最近咨询" withSelectImageName:@"xiaoxi"];
    [self addChildViewControllerWithClassname:[MJXFollowUpViewController description] imagename:@"sfgl" title:@"随访管理" withSelectImageName:@"sfgl-liang"];
    [self addChildViewControllerWithClassname:[MJXPersonalCenterViewController description] imagename:@"gray-ME" title:@"我" withSelectImageName:@"gray-ME-拷贝"];
    // Do any additional setup after loading the view.
}
-(void)getChatToken{
    _chatToken = [[MJXAppsettings sharedInstance] getChatToken];
    if (![_chatToken isEqualToString:@""]&&![_chatToken isKindOfClass:[NSNull class]]&&_chatToken!=nil) {
        [[RCIMClient sharedRCIMClient] connectWithToken:_chatToken success:^(NSString *userId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //  ChatViewController * vc = [[ChatViewController alloc] init];
                //self.window.rootViewController = vc;
            });
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];

    }else{
       // [[MJXAppsettings sharedInstance] setChatToken:@"hT/sTNseDcXzL3SEb/Fx9DIJgu8Hvo+EGooyjr76GG6O5QdP21k6MHPcFJTOpbkzfIwGc5wcUVctiv+sIRSH+yJVCPl2IyM1"];

        AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
        NSString *url = [NSString stringWithFormat:@"%@/user/getDoctorInformationToken",MJXBaseURL];
        [manger POST:url parameters:@{
                                      @"username": [[MJXAppsettings sharedInstance] getUserPhone]
                                      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                              NSDictionary * dict = [[NSDictionary alloc] init];
                                              dict = [responseObject objectForKey:@"result"];
                                              [[MJXAppsettings sharedInstance] setChatToken:[dict objectForKey:@"chatToken"]];
                                              [self getChatToken];
                                          }
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"0");
                                      }];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //[self sendImage];
    });
}
//方法保证在打开app的时候运行
//避免和图片的删除以及添加冲突
-(void)sendImage{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // sleep(40);
        //    if (!_db) { //不放开的话，数据搜索出问题
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
        //    }
        if ([_db open]) {
            FMResultSet * rs = [FMDBTool queryWithDB:_db withTableName:TABLE_NAME];
            if(rs.next) {
                int patientId = [rs intForColumn:@"patient"];
                int diseaseCoureId = [rs intForColumn:@"diseaseCourse"];
                int smallClass = [rs intForColumn:@"smallClass"];
                int imageCount = [rs intForColumn:@"imagecount"];
                
                NSString * smallClassId = [rs stringForColumn:@"smallClassId"];//成为全剧变量或者存数据库
                [_db close];
                
                //存储图片路径
                NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                
                NSString *docPath = [docPaths lastObject];
                //草稿的图片路径
                NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/patient%d/diseaseCourse%d/smallClassId%d/image/image%d",patientId,diseaseCoureId,smallClass,imageCount-1]];
                //判断文件夹是否存在，若存在从文件夹中获取图片
                if ([[NSFileManager defaultManager] fileExistsAtPath:draftPath]){
                    NSData *imageData = [NSData dataWithContentsOfFile:draftPath];
                    UIImage * image = [UIImage imageWithData:imageData];//没有则走下一个
                    //image = [MJXUIUtils scaleImage:image toScale:0.8];
                    NSData *_data = UIImageJPEGRepresentation(image, 1.0f);
                    
                    NSString *encodedImageStr = [_data base64Encoding];
                    
                    
                    [self getImageBase64:encodedImageStr withImageCount:imageCount withSmallClassId:smallClassId];
                }else{
                    //若是没有照片要在重新走（）
                    NSMutableArray * ary = [[NSMutableArray alloc] init];
                    ary = [self getImageDataFromeFile:[NSString stringWithFormat:@"%d",patientId] diseaseclassId:[NSString stringWithFormat:@"%d",diseaseCoureId] smallClass:[NSString stringWithFormat:@"%d",smallClass]];
                    if (ary.count>0&&ary!=nil) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                            [self saveImageWithArray:ary patientId:[NSString stringWithFormat:@"%d",patientId] diseaseCourse:[NSString stringWithFormat:@"%d",diseaseCoureId] smallClassId:[NSString stringWithFormat:@"%d",smallClass] startCount:(int)0];
                        });
                    }else{
                        [_db open];
                        BOOL result = [FMDBTool deleteWithDB:_db tableName:TABLE_NAME withSmallClassId:smallClassId];
                        if (result) {
                            
                        }
                        [self sendImage];
                    }
                }
                
            }
            else{
                return;//要是数据库没有记录跳出 逻辑待完善
            }
        }
        [_db close];
    });
}
-(void)getImageBase64:(NSString *)base64 withImageCount:(int)imageCount withSmallClassId:(NSString *)smallClassid{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/image",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"image" :base64
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          NSDictionary * dict = [responseObject objectForKey:@"result"];
                                          NSString * imageUrlL = [dict objectForKey:@"imagePath_l"];
                                          NSString * imageUrlS = [dict objectForKey:@"imagePath_s"];
                                          [_imageV sd_setImageWithURL:[NSURL URLWithString:imageUrlL] placeholderImage:[UIImage imageNamed:@""]];
                                          [_image sd_setImageWithURL:[NSURL URLWithString:imageUrlS] placeholderImage:[UIImage imageNamed:@""]];                                          NSLog(@"chenggong");            //[self sendImage];
                                          [self sendImageUrlWtithS:imageUrlS withL:imageUrlL withImageCount:imageCount withSmallClassId:smallClassid];
                                      }
                                      NSLog(@"---");
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                  }];
}
-(void)sendImageUrlWtithS:(NSString *)imageUrlS withL:(NSString *)imageUrlL withImageCount:(int)imageCount withSmallClassId:(NSString *)smallClassId{
    
    //创建并发队列 Concurrent Dispatch Queue不过创建多少都没有问题，因为Concurrent Dispatch Queue所使用的线程由系统的XNU内核高效管理，不会影响系统性能。
    dispatch_queue_t queue = dispatch_queue_create("sc", DISPATCH_QUEUE_CONCURRENT);
    double delayInSeconds = 10.0;
    
    //  __block UIViewController* bself = self;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, queue, ^(void){
        
        AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
        NSString *url = [NSString stringWithFormat:@"%@//patient/addImages",MJXBaseURL];
        NSArray * l = [NSArray arrayWithObjects:imageUrlL, nil];
        NSArray * s = [NSArray arrayWithObjects:imageUrlS, nil];
        [manger POST:url parameters:@{
                                      @"username" : [[MJXAppsettings sharedInstance] getUserPhone],
                                      @"medicaDocTypeId":smallClassId,
                                      @"images_L" : l,
                                      @"images_S" : s
                                      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                              [self deleteImageFromFileWithSmallClassId:smallClassId withCount:imageCount];
                                          }
                                          NSLog(@"1111");
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"0000");
                                      }];
    });
}
-(void)deleteImageFromFileWithSmallClassId:(NSString *)smallClassId withCount:(int)imageCount{
    if (!_db) {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
    if ([_db open]) {
        FMResultSet *rs = [FMDBTool queryWithDB:_db tableName:TABLE_NAME withSmallClassId:smallClassId];
        //如果数据库有数据，修改数据原本的图片数目
        if(rs.next) {
            int patientId = [rs intForColumn:@"patient"];
            int diseaseCoureId = [rs intForColumn:@"diseaseCourse"];
            int smallClass = [rs intForColumn:@"smallClass"];
            int imageCountAll = [rs intForColumn:@"imagecount"];
            // NSString * smallClassId1 = [rs stringForColumn:@"smallClassId"];//成为全剧变量或者存数据库
            if (imageCount<=imageCountAll) {
                [self delecateFileImageWithSmallClassID:[NSString stringWithFormat:@"%d",smallClass] withImageID:smallClassId withPatientsID:[NSString stringWithFormat:@"%d",patientId] withDiseaseCoureID:[NSString stringWithFormat:@"%d",diseaseCoureId] withImageCount:[NSString stringWithFormat:@"%d", imageCount]];
            }else{
                return;
            }
            
        }//如果没有，说明有其他的操作删除了
        else{
            return;
        }
    }
}
//删除本地图片文件文件
-(void)delecateFileImageWithSmallClassID:(NSString *)smallClassID withImageID:(NSString *)imageID withPatientsID:(NSString *)patientID withDiseaseCoureID:(NSString *)diseaseCoureID withImageCount:(NSString *)imageCount{
    //获取草稿文件夹路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //缓存的路径
    NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/patient%@/diseaseCourse%@/smallClassId%@",patientID,diseaseCoureID,smallClassID]];
    //草稿图片的路径
    NSString *draftImagePath = [draftPath stringByAppendingPathComponent:@"image"];
    
    NSMutableArray * ary = [[NSMutableArray alloc] init];
    ary = [self getImageDataFromeFile:patientID diseaseclassId:diseaseCoureID smallClass:smallClassID];
    if (ary.count>([imageCount intValue]-1)) {
        [ary removeObjectAtIndex:[imageCount intValue]-1];// 删除图片，重新存入
    }
    //删除草稿图片文件夹
    if ([[NSFileManager defaultManager] fileExistsAtPath:draftImagePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:draftImagePath error:nil];
    }//mjx
    [self createDB];//创建数据库
    [self createTable];//创建表
    //int imageCount=0;//记录照片数值
    if ([_db open])
    {
        FMResultSet *rs = [FMDBTool queryWithDB:_db tableName:TABLE_NAME withPatientId:patientID withDiseaseCourse:diseaseCoureID withSmallClass:smallClassID];
        if(rs.next)
        {
            if (ary.count==0) {
                BOOL result = [FMDBTool deleteWithDB:_db tableName:TABLE_NAME withSmallClassId:imageID];
                if (result) {
                    
                }
                [self sendImage];
            }else if(ary.count>0){
                BOOL result = [FMDBTool updateWithDB:_db tableName:TABLE_NAME withPatientId:patientID withDiseaseCourse:diseaseCoureID withSmallClass:smallClassID imageCount:[NSString stringWithFormat:@"%d",(int)[ary count]]];
                if (result) {
                }
            }
        }
        [_db close];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self saveImageWithArray:ary patientId:patientID diseaseCourse:diseaseCoureID smallClassId:smallClassID startCount:(int)0];
    });
}
-(void)saveImageWithArray:(NSArray *)array patientId:(NSString *)patientId diseaseCourse:(NSString *)diseaseCourseId smallClassId:(NSString *)smallClassId startCount:(int) N{
    
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
    //获取的最新图片转换成NSData
    for (int i=0; i<array.count; i++) {
        UIImage *image = array[i];
        NSData *imageData =  UIImagePNGRepresentation(image);//UIImageJPEGRepresentation(image, 1.0f);
        if (imageData) {
            [ary addObject:imageData];
        }
    }
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //缓存的路径
    NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/patient%@/diseaseCourse%@/smallClassId%@",patientId,diseaseCourseId,smallClassId]];
    
    //草稿图片的路径
    NSString *draftImagePath = [draftPath stringByAppendingPathComponent:@"image"];
    //判断文件夹是否存在，若不存在创建路径中的文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:draftImagePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:draftImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (int i = 0; i < ary.count; i++)
    {
        NSString *imagePath = [draftImagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d",i+N]];
        [ary[i] writeToFile:imagePath atomically:YES];
        if (i == ary.count-1) {
            [self sendImage];
        }
    }
}
//创建数据库
- (void)createDB
{
    if (!_db)
    {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
}
//创建表
- (void)createTable
{
    if ([_db open])
    {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:TABLE_NAME
                                       parameters:@{
                                                    @"patient" : @"integer",
                                                    @"imagecount" : @"integer",
                                                    @"diseaseCourse" : @"integer",
                                                    @"smallClass" : @"integer",
                                                    @"username" : @"text",
                                                    @"smallClassId" :@"text"
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
        [_db close];
    }
}

//页面数据后台取出完成
-(NSMutableArray *)getImageDataFromeFile:(NSString *)patientId diseaseclassId:(NSString *)dicId smallClass:(NSString *)sCId{
    if (!_db) {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
    if ([_db open]) {
        FMResultSet *rs = [FMDBTool queryWithDB:_db tableName:TABLE_NAME withPatientId:patientId withDiseaseCourse:dicId withSmallClass:sCId];
        int imageCount = 0;
        if (rs.next) {
            imageCount = [rs intForColumn:@"imagecount"];
        }
        
        //存储图片路径
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *docPath = [docPaths lastObject];
        //草稿的图片路径
        NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/patient%@/diseaseCourse%@/smallClassId%@/image",patientId,dicId,sCId]];
        //判断文件夹是否存在，若存在从文件夹中获取图片
        if ([[NSFileManager defaultManager] fileExistsAtPath:draftPath])
        {
            NSMutableArray *imageInfoArray = [[NSMutableArray alloc] initWithCapacity:10];
            
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
            return imageInfoArray;
        }
        
        
    }
    [_db close];
    return nil;
}
/**
 *  添加子控制器
 *
 *  @param classname 类名字
 *  @param imagename tabbar图片名字
 *  @param title     tabbar文字
 */
- (void)addChildViewControllerWithClassname:(NSString *)classname
                                  imagename:(NSString *)imagename
                                      title:(NSString *)title withSelectImageName:(NSString *)selectName{
    //通过名字获取到类方法
    UIViewController *vc = [[NSClassFromString(classname) alloc] init];
    //设置导航
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    //tabbar 显示文字
    nav.tabBarItem.title = title;
    //tabbar 普通状态下图片(图片保持原尺寸)
    nav.tabBarItem.image = [[UIImage imageNamed:imagename]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabbar 选择状态下图片
    nav.tabBarItem.selectedImage =[UIImage imageNamed:selectName];// [[UIImage imageNamed:[selectName stringByAppendingString:@"_press"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置字体颜色（选中类型）
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#01aeff"]} forState:UIControlStateSelected];
    //设置字体颜色（普通类型）
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark RCDelegate
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        _message = message;
        
        //添加 字典，将label的值通过key值设置传递
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_message,@"message", nil];
        
        //创建通知
        
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
        
        //通过通知中心发送通知
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self addLocalNotificationWith:_message];
    }
}

// 发送本地通知通知
- (void)addLocalNotificationWith:(RCMessage *)message {
    RCTextMessage *testMessage = (RCTextMessage *)message.content;
    // 1.创建一个本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    // 1.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    // 1.2.设置通知内容
    localNote.alertBody = testMessage.content;
    
    // 1.3.设置锁屏时,字体下方显示的一个文字
    localNote.alertAction = @"赶紧!!!!!";
    localNote.hasAction = YES;
    
    // 1.4.设置启动图片(通过通知打开的)
    //  localNote.alertLaunchImage = @"../Documents/IMG_0024.jpg";
    
    // 1.5.设置通过到来的声音
    // localNote.soundName = UILocalNotificationDefaultSoundName;
    
    // 1.6.设置应用图标左上角显示的数字
    // localNote.applicationIconBadgeNumber = 999;
    
    // 1.7.设置一些额外的信息
    // localNote.userInfo = @{@"qq" : @"704711253", @"msg" : @"success"};
    
    // 2.执行通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
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
