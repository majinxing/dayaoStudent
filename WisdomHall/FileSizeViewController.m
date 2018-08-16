//
//  FileSizeViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/13.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "FileSizeViewController.h"

@interface FileSizeViewController ()<UIDocumentInteractionControllerDelegate,NSURLSessionDelegate>
@property (strong, nonatomic) IBOutlet UIButton *fileDownload;
@property (strong, nonatomic) IBOutlet UIImageView *fileImage;
@property (strong, nonatomic) IBOutlet UILabel *fileName;
@property (strong, nonatomic) IBOutlet UIButton *downLoadBtn;

@end

@implementation FileSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fileDownload.layer.masksToBounds = YES;
    _fileDownload.layer.cornerRadius = 20;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    
    NSArray * ary = [_fileModel.fileName componentsSeparatedByString:@"."];
    
    if (ary.count>0) {
        _fileName.text = ary[0];
    }else{
        _fileName.text = _fileModel.fileName;
    }
    
    _fileImage.image = [UIImage imageNamed:[UIUtils returnFileType:ary[1]]];
    
    double d = [_fileModel.fileSize doubleValue]/1024;
    
    [_downLoadBtn setTitle:[NSString stringWithFormat:@"下载（%0.2lfK）",d] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)fileDownLoadBtn:(id)sender {
    
    [self downloadFileWithURL:_urlStr];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/** 打开文件 @param filePath 文件路径 */
-(void)openDocxWithPath:(NSString *)filePath {
    
    UIDocumentInteractionController *doc= [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    doc.delegate = self;
    
    [doc presentPreviewAnimated:YES];
    
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
#pragma mark -- NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSError *saveError;
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *savePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"File/%@",_fileModel.fileName]]];
    
    NSURL *saveUrl = [NSURL fileURLWithPath:savePath];
    
    //把下载的内容从cache复制到document下
    
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
    
    if (!saveError) {
        
        NSLog(@"save success");
        
//        [self checkTheLocalFile:_fileAry];
        
//        [_tableView reloadData];
        
        [self openDocxWithPath:savePath];
        
    }else{
        
        [self openDocxWithPath:savePath];
        
        NSLog(@"save error:%@",saveError.localizedDescription);
        
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
///** * 当下载完成的时候调用 * * @param location 文件的临时存储路径 */
//-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
//
//    NSLog(@"%@",location);
//
//    //1 拼接文件全路径
//
//    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
//
//    //2 剪切文件
//    [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil]; NSLog(@"%@",fullPath);
//}

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
