//
//  ScanLoginViewController.m
//  ESCloudsManager
//
//  Created by Yinghe Sun on 17/1/18.
//  Copyright © 2017年 ESClouds. All rights reserved.
//

#import "ScanLoginViewController.h"
#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ScanLoginViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    NSTimer *_timer;
    BOOL  _flag;
    BOOL  _isOn;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
    AVCaptureSession *_captureSession;
}
@property (strong, nonatomic) UIButton *cancelButton;
@property (nonatomic,strong) UIImageView *redLabel;


@end

@implementation ScanLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    BOOL cameraIsAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (cameraIsAvailable && authStatus != AVAuthorizationStatusRestricted && authStatus != AVAuthorizationStatusDenied) {
        [self initCapture]; // 启动摄像头
    } else {
        [self alertWithTitle:@"温馨提示" msg:@"请在设置中打开摄像头权限" btnTitle:@"确定"];
    }
    [self SetUpMainView];
    
}

-(void)SetUpMainView{
    UIColor *color = kRGBColor(0, 0, 0);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,(kScreenHeight - kScreenWidth * 0.6) / 2 )];
    view.backgroundColor = color;
    view.alpha = 0.5;
    [self.view addSubview:view];
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,(kScreenHeight - kScreenWidth * 0.6) / 2 + kScreenWidth * 0.6, kScreenWidth, (kScreenHeight - kScreenWidth * 0.6) / 2 )];
    viewBottom.backgroundColor = color;
    viewBottom.alpha = 0.5;
    [self.view addSubview:viewBottom];
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0,(kScreenHeight - kScreenWidth * 0.6) / 2, kScreenWidth * 0.2 , kScreenWidth * 0.6)];
    viewLeft.backgroundColor = color;
    viewLeft.alpha = 0.5;
    [self.view addSubview:viewLeft];
    UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.8,(kScreenHeight - kScreenWidth * 0.6) / 2 , kScreenWidth * 0.2 , kScreenWidth * 0.6)];
    viewRight.backgroundColor = color;
    viewRight.alpha = 0.5;
    [self.view addSubview:viewRight];
    UIView *shortLine1 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.2, (kScreenHeight - kScreenWidth * 0.6) / 2, kScreenWidth * 0.045, kScreenWidth * 0.013)];
    shortLine1.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine1];
    UIView *shortLine2 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.2, (kScreenHeight - kScreenWidth * 0.6) / 2, kScreenWidth * 0.013, kScreenWidth * 0.045)];
    shortLine2.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine2];
    UIView *shortLine3 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.8 - kScreenWidth * 0.013, (kScreenHeight - kScreenWidth * 0.6) / 2, kScreenWidth * 0.013, kScreenWidth * 0.045)];
    shortLine3.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine3];
    UIView *shortLine4 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.8 - kScreenWidth * 0.045, (kScreenHeight - kScreenWidth * 0.6) / 2, kScreenWidth * 0.045, kScreenWidth * 0.013)];
    shortLine4.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine4];
    UIView *shortLine5 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.2, (kScreenHeight - kScreenWidth * 0.6) / 2 + kScreenWidth * 0.6 - kScreenWidth * 0.013, kScreenWidth * 0.045, kScreenWidth * 0.013)];
    shortLine5.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine5];
    UIView *shortLine6 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.2, (kScreenHeight - kScreenWidth * 0.6) / 2 + kScreenWidth * 0.6 - kScreenWidth * 0.045, kScreenWidth * 0.013, kScreenWidth * 0.045)];
    shortLine6.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine6];
    UIView *shortLine7 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.8 - kScreenWidth * 0.013, (kScreenHeight - kScreenWidth * 0.6) / 2 + kScreenWidth * 0.6 - kScreenWidth * 0.045, kScreenWidth * 0.013, kScreenWidth * 0.045)];
    shortLine7.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine7];
    UIView *shortLine8 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.8 - kScreenWidth * 0.045,(kScreenHeight - kScreenWidth * 0.6) / 2 + kScreenWidth * 0.6 - kScreenWidth * 0.013, kScreenWidth * 0.045, kScreenWidth * 0.013)];
    shortLine8.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine8];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"将二维码放入框内,即可自动打卡";
    label.frame = CGRectMake(0, 10, kScreenWidth, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    [viewBottom addSubview:label];
    //返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10,30, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"JS0301"] forState:0];
    button.alpha = 1 ;
    [view addSubview:button];
    
    UIButton *upButton = [[UIButton alloc] init];
    upButton.frame = CGRectMake(10, 20, 40, 40);
    upButton.backgroundColor = [UIColor clearColor];
    [upButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:1<<6];
    [view addSubview:upButton];
    [button addTarget:self action:@selector(leftButtonClicked) forControlEvents:1<<6];
    //闪光灯打开按钮
    //    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightButton.frame = CGRectMake(kScreenWidth - 40,30, 40, 22);
    //    rightButton.alpha = 0.5 ;
    //    [rightButton setBackgroundImage:[UIImage imageNamed:@"JS0302"] forState:0];
    //    [view addSubview:rightButton];
    //    _isOn = NO;
    //    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:1<<6];
    //    [self rightButtonClicked];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    static dispatch_once_t onceTaken;
    _flag = NO;
    dispatch_once(&onceTaken,^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(viewMove) userInfo:nil repeats:YES];
    });
    _redLabel = [[UIImageView alloc] init];
    _redLabel.image = [UIImage imageNamed:@"JS0303"];
    _redLabel.frame = CGRectMake(kScreenWidth * 0.2 + kScreenWidth * 0.013, (kScreenHeight - kScreenWidth * 0.6) / 2 + kScreenWidth * 0.013,kScreenWidth  * 0.6 - kScreenWidth * 0.026, kScreenWidth * 0.0106);
    [self.view addSubview:_redLabel];
}

-(void)viewMove{
    if (_flag == YES) {
        [UIView animateWithDuration:2.9 animations:^{
            _redLabel.frame = CGRectMake(kScreenWidth * 0.2 + kScreenWidth * 0.013, (kScreenHeight - kScreenWidth * 0.6) / 2 + kScreenWidth * 0.013,kScreenWidth  * 0.6 - kScreenWidth * 0.026, kScreenWidth * 0.0106);
        }];
        
    }else{
        [UIView animateWithDuration:2.9 animations:^{
            _redLabel.frame = CGRectMake(kScreenWidth * 0.2 + kScreenWidth * 0.013, (kScreenHeight - kScreenWidth * 0.6) / 2 + kScreenWidth * 0.6 - kScreenWidth * 0.013,kScreenWidth  * 0.6 - kScreenWidth * 0.026, kScreenWidth * 0.0106);
        }];
    }
    _flag = !_flag;
}

-(void)leftButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initCapture {
    // capture session 数据的捕获,操作,输出
    _captureSession = [[AVCaptureSession alloc] init];
    // 捕获设备,这里是摄像头
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //    AVCaptureDevice *inputDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    // 捕获设备的输入
    NSError *error = nil;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if (!error) {
        // 正常捕获数据
        [_captureSession addInput:captureInput]; // 将输入添加到session上
    } else {
        // 捕获数据失败
        [self alertWithTitle:@"警告" msg:@"手机摄像头捕获图像出现故障,请检查权限设置!" btnTitle:@"确定"];
    }
    if (IOS7) {
        // 捕获到的数据的输出
        AVCaptureMetadataOutput *captureOutput = [[AVCaptureMetadataOutput alloc] init];
        [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        CGSize size = self.view.bounds.size;
        CGRect cropRect = CGRectMake(87, 100, 240, 240);
        CGFloat p1 = size.height/size.width;
        CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
        if (p1 < p2) {
            CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            captureOutput.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight, cropRect.origin.x/size.width, cropRect.size.height/fixHeight, cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
            CGFloat fixPadding = (fixWidth - size.width)/2;
            captureOutput.rectOfInterest = CGRectMake(cropRect.origin.y/size.height, (cropRect.origin.x + fixPadding)/fixWidth, cropRect.size.height/size.height, cropRect.size.width/fixWidth);
        }
        
        
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        [_captureSession addOutput:captureOutput];
        captureOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        if (!_captureVideoPreviewLayer) {
            _captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
        }
        _captureVideoPreviewLayer.frame = self.view.bounds;
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:_captureVideoPreviewLayer];
        [_captureSession startRunning];
    }
}

- (void)alertWithTitle:(NSString *)titleStr msg:(NSString *)msgStr btnTitle:(NSString *)btnTitle {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:titleStr message:msgStr delegate:self cancelButtonTitle:btnTitle otherButtonTitles:nil, nil];
    av.tag = 1000;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSLog(@"扫描页面里的扫描结果输出:%@", metadataObject.stringValue);
        [self requestForLogin:metadataObject.stringValue];
    }
    
    [_captureSession stopRunning];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestForLogin:(NSString *)scanStr{
    NSLog(@"扫描页面里的扫描结果输出:%@",scanStr);
    
    if ([scanStr rangeOfString:@"userid"].location !=NSNotFound && [scanStr rangeOfString:@"postid"].location !=NSNotFound) {
        NSString *str1 = [scanStr substringFromIndex:31];
        NSLog(@"处理1:%@",str1);
        NSArray *array = [[NSArray alloc]init];
        NSArray *array1 = [[NSArray alloc]init];
        array = [str1 componentsSeparatedByString:@"&postid="];
        NSLog(@"处理2:%@",array);
        array1 = [array[1] componentsSeparatedByString:@"&compid="];
        NSLog(@"处理3:%@",array1);
        NSDictionary *dic = @{@"userId"  : array[0],
                              @"postId" : array1[0],
                              @"compId" : array1[1],
                              @"uuid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                              };
        [XSHttpTool GET:@"DiviceAdd.ScanAddDivice" param:dic success:^(id responseObject) {
            NSDictionary *jsonDic = [[NSDictionary alloc]init];
            jsonDic = responseObject;
            NSLog(@"登录返回json：%@",jsonDic);
            if ([jsonDic[@"ret"] intValue] == 200) {
//                MainViewController *mainVC = [[MainViewController alloc] init];
//                [self.navigationController pushViewController:mainVC animated:true];
                kPSuccess(@"设备绑定成功");
            }else{
                kPError(jsonDic[@"msg"]);
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            kPError(@"登录失败");
        }];
    }else{
        kPError(@"不是登录需要的二维码");
    }
    
}

@end
