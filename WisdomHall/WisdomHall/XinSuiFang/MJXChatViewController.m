//
//  MJXChatViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/10/24.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXChatViewController.h"
#import "MJXChatTableViewCell.h"
#import <RongIMLib/RongIMLib.h>
#import "MJRefresh.h"
#import "MJXChat.h"
#import "MJXTheQuickReplyViewController.h"
#import "MJXTabBarController.h"

#import "FMDatabase.h"
#import "FMDBTool.h"

@interface MJXChatViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextViewDelegate,RCIMClientReceiveMessageDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,assign) CGPoint historyPoint;
@property (nonatomic,strong) UIView * tView;//承载输入框的
@property (nonatomic,strong) UITextView * textView;
@property (nonatomic,strong) UIButton * sendMessage;//信息发送按钮
@property (nonatomic,strong) NSMutableArray * chatArray;
@property (nonatomic,strong)MJXTabBarController * vc;
@property (nonatomic,strong)FMDatabase *db;//数据库

@property (nonatomic,assign) int paging;
@property (nonatomic,assign) int allPaging;
@property (nonatomic,assign) int keyHeight;
@end

@implementation MJXChatViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _keyHeight = 0;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [MJXUIUtils addNavigationWithView:self.view withTitle:_patients.patientsName];
    _chatArray = [NSMutableArray arrayWithCapacity: 10];
    
    //[[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    
    [self addBackButton];
    [self addTableView];
    [self listeningToTheKeyboard];
    [self getChatArray];
    [self addinputBoxView];
    [self addListeningToTheMessage];
    [self insetToSQlWithPatient:_patients];
    //注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    // Do any additional setup after loading the view.
}

-(void)tongzhi:(NSNotification *)dict{
    RCMessage * message = dict.userInfo[@"message"];
    if ([message.content isMemberOfClass:[RCTextMessage class]]){
        if ([message.targetId isEqualToString:_patients.targetId]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                RCTextMessage *testMessage = (RCTextMessage *)message.content;
                [_chatArray insertObject:message atIndex:0];
                [self refreshTableView];
            });
        }
    }
    NSLog(@"%@",dict);
}
//添加监听
-(void)addListeningToTheMessage{
    _vc = [MJXTabBarController sharedInstance];
    [_vc addObserver:self forKeyPath: @"message" options: NSKeyValueObservingOptionNew context: nil];
}
-(void)addinputBoxView{
    _tView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT-50, APPLICATION_WIDTH, 50)];
    _tView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [self.view addSubview:_tView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, APPLICATION_WIDTH-80, 30)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:13];
    _textView.delegate = self;
    [_tView addSubview:_textView];
    
    UIView * lineW = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textView.frame)+1, APPLICATION_WIDTH-80, 1)];
    lineW.backgroundColor = [UIColor colorWithHexString:@"#666666"];
    
    [_tView addSubview:lineW];
    
    _sendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendMessage.frame = CGRectMake(CGRectGetMaxX(_textView.frame)+10, 5, 41, 41);
    
    [_sendMessage setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    
    [_sendMessage addTarget:self action:@selector(sendMessageBtn) forControlEvents:UIControlEventTouchUpInside];
    [_tView addSubview:_sendMessage];
    
    
    UIView * s = [[UIView alloc] initWithFrame:CGRectMake(0, 50, APPLICATION_WIDTH, 50)];
    s.backgroundColor = [UIColor whiteColor];
    
    [_tView addSubview:s];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [s addSubview:line];
    NSArray * textAry = [NSArray arrayWithObjects:@"相册",@"相机",@"快速回复", nil];
    NSArray * imageNameAry = [NSArray arrayWithObjects:@"xiangce",@"xiangji",@"bianji", nil];
    for (int i = 0; i<3; i++) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(90*i+34, 10, 23, 19)];
        image.image = [UIImage imageNamed:imageNameAry[i]];
        [s addSubview:image];
        
        if (i==2) {
            image.frame = CGRectMake(90*i+35, 10, 19, 18);
        }
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(90*i, CGRectGetMaxY(image.frame)+10, 90, 20)];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = textAry[i];
        [s addSubview:label];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(90*i, 0, 90, 60);
        btn.tag = i+1;
        [btn addTarget:self action:@selector(selectTheMultimedia:) forControlEvents:UIControlEventTouchUpInside];
        [s addSubview:btn];
    }
}
-(void)selectTheMultimedia:(UIButton *)btn{
    //   NSLog(@"%s",__func__);
    if (btn.tag == 3) {
        MJXTheQuickReplyViewController * vc = [[MJXTheQuickReplyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)sendMessageBtn{
    //[self.view endEditing:YES];
    if (_textView.text.length>0&&![_textView.text isEqualToString:@""]){
       // [self patientsWhetherOnline];
        
        // 构建消息的内容，这里以文本消息为例。
        RCTextMessage *testMessage = [RCTextMessage messageWithContent:[NSString stringWithFormat:@"%@",_textView.text]];
        // 调用RCIMClient的sendMessage方法进行发送，结果会通过回调进行反馈。
        RCMessage * aa = [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                                           targetId:_patients.targetId
                                                            content:testMessage
                                                        pushContent:nil
                                                           pushData:nil
                                                            success:^(long messageId) {
                                                                NSLog(@"发送成功。当前消息ID：%ld", messageId);
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    _textView.text = @"";
                                                                });
                                                                
                                                            } error:^(RCErrorCode nErrorCode, long messageId) {
                                                                NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
                                                            }];
        if (aa!=nil) {
            [_chatArray insertObject:aa atIndex:0];
            [self refreshTableView];
        }
        
        if (_keyHeight>0) {
            
        }else{
            _sendMessage.frame = CGRectMake(CGRectGetMaxX(_textView.frame)+10, 5, 41, 41);
            [_sendMessage setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
            [_sendMessage setTitle:@"" forState:UIControlStateNormal];
            _sendMessage.backgroundColor = [UIColor clearColor];
        }
    }else if(_keyHeight==0){
        if (_tView.frame.size.height>50) {
            _tableView.frame = CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-60);
            _tView.frame = CGRectMake(0, APPLICATION_HEIGHT-50, APPLICATION_WIDTH, 50);
        }else{
            _tableView.frame = CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-60-60);
            _tView.frame = CGRectMake(0, APPLICATION_HEIGHT-110, APPLICATION_WIDTH, 110);
        }
        
    }
}
//判断患者在不在线
-(void)patientsWhetherOnline{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/user/isOnline",MJXBaseURL];
    
    [manger POST:url parameters:@{
                                   @"userId" : _patients.targetId
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          if ([[responseObject objectForKey:@"result"] isEqualToString:@"NO"]) {
                                              [self sendAReminder];
                                          }
                                      }
                                      NSLog(@"1");
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"2");
                                  }];

}
-(void)sendAReminder{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"http://xsfserver.tunnel.2bdata.com/xsfServer/LT/mesTX.do"];
    [manger POST:url parameters:@{
                                  @"userId" : _patients.targetId,
                                  @"docId":@"",
                                  @"docName":[[MJXAppsettings sharedInstance] getUserPhone]
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                 }];
}
-(void)getChatArray{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * a = [[NSArray alloc] init];
        a = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:_patients.targetId count:9999];
        _allPaging = (int)a.count;
        NSArray * ary = [[NSArray alloc] init];
        ary = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:_patients.targetId count:20];
        _paging = (int)ary.count;
        [_chatArray addObjectsFromArray:ary];
        //        for (int i = 0; i<ary.count; i++) {
        //            RCMessage * mensage = [[RCMessage alloc] init];
        //            mensage = ary[i];
        //            RCTextMessage *testMessage = (RCTextMessage *)mensage.content;
        //            NSLog(@"---%lu",(unsigned long)mensage.messageDirection);
        //            MJXChat * chat = [[MJXChat alloc] init];
        //            chat.chatStr = testMessage.content;
        //            if ((unsigned long)mensage.messageDirection == 1) {
        //                chat.userOrPatients = YES;
        //            }else{
        //                chat.userOrPatients = NO;
        //            }
        //            [_chatArray addObject:chat];
        //        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_chatArray.count>0&&_chatArray!=nil) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.chatArray.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            [self.view addSubview:_tableView];
        });
    });
    //        NSLog(@"%s",__func__);
}



-(void)refreshTableView{
    //将新的消息插入到最后
    if (self.chatArray.count>=1) {
        
    }else{
        return;
    }
    NSIndexPath *index = [NSIndexPath indexPathForRow:(self.chatArray.count-1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
    // [_tableView reloadData];
    //让tableView滚动到最低部
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.chatArray.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
-(void)addBackButton{
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-60) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.userInteractionEnabled = YES;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    //加载更多数据
    __weak  typeof(self)vc = self;
    [_tableView addHeaderWithCallback:^{
        [vc headerRereshing];
    }];
    
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom)];
    recognizer.numberOfTouchesRequired = 1; //手指数
    recognizer.numberOfTouchesRequired = 1; //tap次数
    recognizer.delegate= self;
    [_tableView addGestureRecognizer:recognizer];
}
-(void)headerRereshing{
    if ((_paging+20)<=_allPaging) {
        RCMessage * mensage = _chatArray[_chatArray.count-1];
        NSMutableArray * ary = [NSMutableArray arrayWithCapacity:10];
        ary = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE targetId:@"18810517780" oldestMessageId:mensage.messageId count:20 ];
        for (int i = 0; i<ary.count; i++) {
            [_chatArray addObject:ary[i]];
        }
        //让tableView滚动到最低部
        //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:20 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    [_tableView headerEndRefreshing];
    [_tableView reloadData];
    
}

//没有走 手势方法
-(void)handleSwipeFrom{
    [self.view endEditing:YES];
}
//然后根据具体的业务场景去写逻辑就可以了,比如
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        [self.view endEditing:YES];
        return YES;
    }else if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableView"]) {
        //返回为NO则屏蔽手势事件
        [self.view endEditing:YES];
        return YES;
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark FMDB
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
        BOOL result = [FMDBTool createTableWithDB:_db tableName:TABLE_NAME_RECENT_CONSULTING
                                       parameters:@{
                                                    @"address" : @"text",
                                                    @"birthday" : @"text",
                                                    @"heading" : @"text",
                                                    @"groupName" : @"text",
                                                    @"patientsId" : @"text",
                                                    @"idCode" : @"text",
                                                    @"marriageInfo" :@"text",
                                                    @"medicalRecordNum" :@"text",
                                                    @"name" : @"text",
                                                    @"nation" : @"text",
                                                    @"occupation": @"text",
                                                    @"phone" : @"text",
                                                    @"sex" : @"text",
                                                    @"zyzz" : @"text",
                                                    @"consultingTime" : @"text",
                                                    @"userId":@"text",
                                                    @"targetId" : @"text"
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
-(void)insetToSQlWithPatient:(MJXPatients *)patients{
    [self createDB];
    [self createTable];
    //[FMDBTool deleteTable:TABLE_NAME_RECENT_CONSULTING withDB:_db];
    if ([_db open]) {
        FMResultSet * rs = [FMDBTool queryRecentConsultingTableWithDB:_db withTableName:TABLE_NAME_RECENT_CONSULTING withPatientId:_patients.targetId];
        if (!rs.next) {
            BOOL result = [FMDBTool insertToRecentConsultingWithDB:_db tableName:TABLE_NAME_RECENT_CONSULTING withPatient:_patients];
            if (result) {
                
            }
        }else{
            BOOL result = [FMDBTool updateConsultingWithDB:_db tableName:TABLE_NAME_RECENT_CONSULTING withPatient:_patients];
            if (result) {
                
            }
        }
    }
    [_db close];
}
#pragma mark 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"监听到%@对象的%@属性发生了改变， %@", object, keyPath, change);
}
#pragma  mark 融云
/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param nLeft       还剩余的未接收的消息数，left>=0
 @param object      消息监听设置的key值
 
 @discussion 如果您设置了IMlib消息监听之后，SDK在接收到消息时候会执行此方法。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 object为您在设置消息接收监听时的key值。
 */
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            RCTextMessage *testMessage = (RCTextMessage *)message.content;
            [_chatArray insertObject:message atIndex:0];
            [self refreshTableView];
            //            MJXChat * chat = [[MJXChat alloc] init];
            //            chat.chatStr = testMessage.content;
            //            chat.userOrPatients = NO;
            //            RCMessage
            //            if (!([chat.chatStr isKindOfClass:[NSNull class]]>0)&&chat.chatStr!=nil&&![chat.chatStr isEqualToString:@""]) {
            //                [_chatArray addObject:chat];
            //                [self refreshTableView];
            //            }
            NSLog(@"消息内容：%@", testMessage.content);
        });
    }
    
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}

#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _sendMessage.frame = CGRectMake(CGRectGetMaxX(_textView.frame)+10, 10,50,30);
    [_sendMessage setTitle:@"发送" forState:UIControlStateNormal];
    [_sendMessage setBackgroundImage:nil forState:UIControlStateNormal];
    _sendMessage.titleLabel.font = [UIFont systemFontOfSize:15];
    _sendMessage.layer.cornerRadius = 5;
    _sendMessage.layer.masksToBounds = YES;
    _sendMessage.backgroundColor = [UIColor colorWithHexString:@"#01aeff"];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length>0) {
        
    }else{
        _sendMessage.frame = CGRectMake(CGRectGetMaxX(_textView.frame)+10, 5, 41, 41);
        [_sendMessage setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
        [_sendMessage setTitle:@"" forState:UIControlStateNormal];
        _sendMessage.backgroundColor = [UIColor clearColor];
    }
}
#pragma mark key
-(void)listeningToTheKeyboard{
    //添加键盘监听
    // 键盘将要显示时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // 键盘将要隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//插入一条消息
- (void)insertMessage
{
    
}
- (void)keyboardWillShow:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    double keyBoardHeight = keyboardRect.size.height;
    //记录当前的位置,在键盘消失之后恢复当前的位置
    self.historyPoint = self.tableView.contentOffset;
    
    //self.tableView.frame = CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-keyBoardHeight-130);
    self.tableView.height = APPLICATION_HEIGHT - keyBoardHeight -130;
    _keyHeight = keyBoardHeight;
    
    if (_chatArray.count>0&&_chatArray!=nil) {
        //让tableView滚动到最低部
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.chatArray.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }else{
        
    }
    
    _tView.frame = CGRectMake(0, APPLICATION_HEIGHT-keyBoardHeight-50, APPLICATION_WIDTH, 50);
    //    0, APPLICATION_HEIGHT-50, APPLICATION_WIDTH, 50
    
    //[_tableView reloadData];
}
- (void)keyboardWillHide:(NSNotification*)notification{
    _keyHeight = 0;
    if (self.chatArray.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    //键盘消失,恢复原来的位置
    self.tableView.frame = CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-60);
    _tView.frame = CGRectMake(0, APPLICATION_HEIGHT-50, APPLICATION_WIDTH, 50);
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_chatArray.count>0&&_chatArray!=nil) {
        return _chatArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXChatTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//不能被选中
    
    RCMessage * mensage = _chatArray[_chatArray.count - indexPath.row - 1];
    RCTextMessage *testMessage = (RCTextMessage *)mensage.content;
    BOOL NN = NO;
    if ((unsigned long)mensage.messageDirection == 1) {
        NN = YES;
    }else{
        NN = NO;
    }
    [cell addChatViewWithChatStr:testMessage.content withPatients:nil withUser:nil withDirection:NN];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXChatTableViewCell *cell = (MJXChatTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height+10;
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
