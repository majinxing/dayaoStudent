//
//  PersonalUploadDataViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/31.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "PersonalUploadDataViewController.h"
#import "DataDownloadTableViewCell.h"
#import "DYHeader.h"
#import "TFFileUploadManager.h"
#import "FileModel.h"
#import "UploadFileViewController.h"
#import "MJRefresh.h"

@interface PersonalUploadDataViewController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate,DataDownloadTableViewCellDelegate,NSURLSessionDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property  (nonatomic,strong)NSMutableArray * fileAry;
@property (nonatomic,strong)FileModel * f;
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)UserModel * user;
@property (nonatomic,assign) int temp;
@property (nonatomic,strong)UIView * lineView;
@end

@implementation PersonalUploadDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _fileAry = [NSMutableArray arrayWithCapacity:1];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _temp = 0;
    
    [self setNavigationTitle];
    
    //    [self getData];
    [self addBtn];
    
    [self addTableView];
    
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)addBtn{
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#01aeff" alpha:1.0f];
    
    NSArray *title=[NSArray arrayWithObjects:@"全部问答",@"个人问答",nil];
    //添加点击按钮
    for (int i = 0; i<title.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //        button.backgroundColor = [UIColor greenColor];
        button.frame = CGRectMake(APPLICATION_WIDTH/title.count*i,64,APPLICATION_WIDTH/title.count,40);
        [button setTitle:title[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithHexString:@"#999999" alpha:1.0f]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#01aeff" alpha:1.0f]
                     forState:UIControlStateSelected];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i==0) {
            button.selected = YES;
        }
        //
        //文字大小
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = i+1;
        //设置点击事件
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    _lineView.frame = CGRectMake(0, 64+40, APPLICATION_WIDTH/2, 1);
    [self.view addSubview:_lineView];

}
-(void)titleClick:(UIButton *)btn{
    if (btn.tag == 1) {
        UIButton *button=(UIButton *)[self.view viewWithTag:2];
        button.selected=NO;
        btn.selected = YES;
        _temp = 0;
        [self getData];
        _lineView.frame = CGRectMake(0, 64+40, APPLICATION_WIDTH/2, 1);
    }else{
        UIButton *button=(UIButton *)[self.view viewWithTag:1];
        button.selected=NO;
        btn.selected = YES;
        _temp = 1;
        [self getData];
        _lineView.frame = CGRectMake(APPLICATION_WIDTH/2, 64+40, APPLICATION_WIDTH/2, 1);
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
-(void)getData{
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取主线程
        [self hideHud];
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    });
    
    if ([_type isEqualToString:@"classModel"]){
        
        NSDictionary * dict;// = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"relType",_classModel.sclassId,@"relId",@"3",@"function",nil];
        if ([_function isEqualToString:@"6"]) {
            dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"relType",_classModel.sclassId,@"relId",@"6",@"function",nil];;
        }else{
            dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"relType",_classModel.sclassId,@"relId",@"3",@"function",nil];;
            
        }
        [[NetworkRequest sharedInstance] GET:FileList dict:dict succeed:^(id data) {
            //            NSLog(@"%@",data);
            [_fileAry removeAllObjects];
            
            NSArray * ary = [data objectForKey:@"body"];
            if (_temp == 0) {
                for (int i = 0; i<ary.count; i++) {
                    FileModel * f = [[FileModel alloc] init];
                    [f setInfoWithDict:ary[i]];
                    [_fileAry addObject:f];
                }
            }else{
                for (int i = 0; i<ary.count; i++) {
                    FileModel * f = [[FileModel alloc] init];
                    [f setInfoWithDict:ary[i]];
                    NSArray *ary1 = [f.fileName componentsSeparatedByString:@"-"];
                    if (![UIUtils isBlankString:ary1[0]]) {
                        if ([_user.userName isEqualToString:ary1[0]]) {
                            [_fileAry addObject:f];
                        }
                    }
                }
            }
            
            [self checkTheLocalFile:_fileAry];
            
            if (_fileAry.count>0) {
                
            }else{
                [UIUtils showInfoMessage:@"暂无数据"];
            }
            
        } failure:^(NSError *error) {
            [self hideHud];
        }];
    }
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if ([UIUtils isBlankString:_function]) {
        self.title = @"文件";
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        
        if ([[NSString stringWithFormat:@"%@",_meeting.meetingHostId] isEqualToString:[NSString stringWithFormat:@"%@",user.peopleId]]) {
            
            UIBarButtonItem * createMeeting = [[UIBarButtonItem alloc] initWithTitle:@"上传资料" style:UIBarButtonItemStylePlain target:self action:@selector(uploadLocalFile)];
            
            self.navigationItem.rightBarButtonItem = createMeeting;
            
        }
        if ([[NSString stringWithFormat:@"%@",_classModel.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",user.studentId]]) {
            
            UIBarButtonItem * createMeeting = [[UIBarButtonItem alloc] initWithTitle:@"上传资料" style:UIBarButtonItemStylePlain target:self action:@selector(uploadLocalFile)];
            
            self.navigationItem.rightBarButtonItem = createMeeting;
        }
    }else{
        self.title = @"问答";
        UIBarButtonItem * createMeeting = [[UIBarButtonItem alloc] initWithTitle:@"上传解答" style:UIBarButtonItemStylePlain target:self action:@selector(selectImage)];
        
        self.navigationItem.rightBarButtonItem = createMeeting;
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
    NSDictionary * dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",str,@"description",@"6",@"function",[NSString stringWithFormat:@"%@",_classModel.sclassId],@"relId",@"1",@"relType",nil];
    
    [[NetworkRequest sharedInstance] POSTImage:FileUpload image:resultImage dict:dict1 succeed:^(id data) {
        NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([code isEqualToString:@"0000"]) {
            [UIUtils showInfoMessage:@"上传成功"];
            [self getData];
        }else{
            [UIUtils showInfoMessage:@"上传失败"];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"上传失败"];
    }];
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)uploadLocalFile{
    UploadFileViewController * upload = [[UploadFileViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    if ([_type isEqualToString:@"meeting"]) {
        upload.type = @"meeting";
        upload.meeting = _meeting;
    }else{
        upload.type = @"classModel";
        upload.classModel = _classModel;
    }
    [self.navigationController pushViewController:upload animated:YES];
    
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64+41, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-41) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    __weak PersonalUploadDataViewController * weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf getData];
    }];
    
    [self.tableView addFooterWithCallback:^{
        [weakSelf getData];
    }];
}
-(void)checkTheLocalFile:(NSMutableArray *)ary{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths lastObject];
    
    //    NSLog(@"app_home_doc: %@",documentsDirectory);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"File"]; //docPath为文件名
    
    //判断文件夹是否存在，若不存在创建路径中的文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path=filePath; // 要列出来的目录
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    
    NSDirectoryEnumerator *myDirectoryEnumerator;
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
    
    //列举目录内容，可以遍历子目录
//    NSLog(@"用enumeratorAtPath:显示目录%@的内容：",path);
    
    while((path=[myDirectoryEnumerator nextObject])!=nil)
    {
        for (int i = 0;i<ary.count; i++) {
            FileModel * f = ary[i];
            if ([f.fileName isEqualToString:path]) {
                f.isLocal = YES;
            }
        }
        
//        NSLog(@"%@",path);
        
    }
    [self hideHud];
    
    [_tableView reloadData];
    
}

/** 打开文件 @param filePath 文件路径 */
-(void)openDocxWithPath:(NSString *)filePath {
    UIDocumentInteractionController *doc= [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    doc.delegate = self;
    [doc presentPreviewAnimated:YES];
    
}
//方法二：可以知道下载进度
//
//加载代理方法<NSURLSessionDownloadDelegate>
//
//把url传给这个方法

- (void)downloadFileWithURL:(NSString *)urlStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取主线程
        [self hideHud];
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    });
    //默认配置
    
    NSURLSessionConfiguration *configuration= [NSURLSessionConfiguration defaultSessionConfiguration];
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    configuration.HTTPAdditionalHeaders = @{@"token":[NSString stringWithFormat:@"Bearer %@",user.token]};
    //得到session对象
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // url
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //创建任务
    
    NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url];
    
    //开始任务
    
    [downloadTask resume];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIDocumentInteractionControllerDelegate
//必须实现的代理方法 预览窗口以模式窗口的形式显示，因此需要在该方法中返回一个view controller ，作为预览窗口的父窗口。如果你不实现该方法，或者在该方法中返回 nil，或者你返回的 view controller 无法呈现模式窗口，则该预览窗口不会显示。

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    
    return self;
    
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    
    return self.view;
    
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    
    return CGRectMake(0, 30, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    
}
#pragma mark DataDownloadTableViewCellDelegate
-(void)downloadFileDelegate:(UIButton *)btn{
    FileModel * f =_fileAry[btn.tag-1];
    _f = _fileAry[btn.tag - 1];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths lastObject];
    
//    NSLog(@"app_home_doc: %@",documentsDirectory);
    
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"File"]; //docPath为文件名
    
    [self showHudInView:self.view hint:NSLocalizedString(@"正在下载数据", @"Load data...")];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?",BaseURL,FileDownload];
    
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"resourceId=%@",f.fileId]];
    
    [self downloadFileWithURL:urlString];
}




#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_fileAry.count>0) {
        return _fileAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataDownloadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DataDownloadTableViewCellFirst"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DataDownloadTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.delegate = self;
    FileModel * f =_fileAry[indexPath.row];
    [cell addContentView:f withIndex:(int)indexPath.row+1];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    FileModel * f = _fileAry[indexPath.row];
    
    _f = _fileAry[indexPath.row];
    
    NSString *documentsDirectory = [paths lastObject];
    
    //    NSLog(@"app_home_doc: %@",documentsDirectory);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"File/%@",f.fileName]]; //docPath为文件名
    
    if (![fileManager fileExistsAtPath:filePath]) {
        if (![UIUtils isBlankString:f.fileName]) {
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@?",BaseURL,FileDownload];
            
            urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"resourceId=%@",f.fileId]];
            
            [self downloadFileWithURL:urlString];
            
        }else{
            [UIUtils showInfoMessage:@"请先确定文件的准确性"];
        }
        
    }else{
        
        [self openDocxWithPath:filePath];
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    // 从列表中删除
    FileModel * f = _fileAry[indexPath.row];
    NSArray *ary1 = [f.fileName componentsSeparatedByString:@"-"];
    
    if ([[NSString stringWithFormat:@"%@",_meeting.meetingHostId] isEqualToString:[NSString stringWithFormat:@"%@",user.peopleId]]) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",f.fileId],@"id", nil];
        
        [[NetworkRequest sharedInstance] POST:FileDelegate dict:dict succeed:^(id data) {
            
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"删除失败，请检查网络"];
        }];
    }
    if ([[NSString stringWithFormat:@"%@",_classModel.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",user.studentId]]) {
        
    }else if (![UIUtils isBlankString:ary1[0]]) {
        if ([_user.userName isEqualToString:ary1[0]]) {
            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",f.fileId],@"id", nil];
            
            [[NetworkRequest sharedInstance] POST:FileDelegate dict:dict succeed:^(id data) {
                
            } failure:^(NSError *error) {
                [UIUtils showInfoMessage:@"删除失败，请检查网络"];
            }];
        }
    }
    
    [_fileAry removeObjectAtIndex:indexPath.row];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths lastObject];
    
    //    NSLog(@"app_home_doc: %@",documentsDirectory);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"File/%@",f.fileName]]; //docPath为文件名
    
    //判断文件夹是否存在，若不存在创建路径中的文件夹
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    [_tableView reloadData];
}



#pragma mark -- NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSError *saveError;
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *savePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"File/%@",_f.fileName]]];
    
    NSURL *saveUrl = [NSURL fileURLWithPath:savePath];
    
    //把下载的内容从cache复制到document下
    
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
    
    if (!saveError) {
        
        //        NSLog(@"save success");
        
        [self checkTheLocalFile:_fileAry];
        
        [_tableView reloadData];
        
        [self openDocxWithPath:savePath];
        
    }else{
        
        //        NSLog(@"save error:%@",saveError.localizedDescription);
        
    }
    [self hideHud];
    
}

/** * 写数据 * * @param session 会话对象 * @param downloadTask 下载任务 * @param bytesWritten 本次写入的数据大小 * @param totalBytesWritten 下载的数据总大小 * @param totalBytesExpectedToWrite 文件的总大小 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //获得文件的下载进度
    //    NSLog(@"%f",1.0 * totalBytesWritten/totalBytesExpectedToWrite);
    
}

/** * 当恢复下载的时候调用该方法 * * @param fileOffset 从什么地方下载 * @param expectedTotalBytes 文件的总大小 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

/** * 请求结束 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
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
