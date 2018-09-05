//
//  LoginViewController.m
//  ESCloudsManager
//
//  Created by 孙滢贺 on 16/7/14.
//  Copyright © 2016年 ESClouds. All rights reserved.
//

#import "LoginViewController.h"
#import "Reachability.h"
#import "MainViewController.h"
#import "ScanLoginViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *passWordTextField;
@end

@implementation LoginViewController
@synthesize phoneTextField = _phoneTextField;
@synthesize passWordTextField = _passWordTextField;


- (void)viewDidLoad {

    [super viewDidLoad];
    //点击空白处，键盘退下
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    BOOL ret = [reachability isReachable];
    if (ret) {
        [self judgeIslogin];
    }else{
        [self mainView];
    }
    
        

}

- (void)judgeIslogin{
    
    NSDictionary *dic = @{
                          @"uuid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                          };
    [XSHttpTool GET:@"ESLogin.ESQuickLogin" param:dic success:^(id responseObject) {
        NSDictionary *jsonDic = [[NSDictionary alloc]init];
        jsonDic = responseObject;
        NSLog(@"登录返回json：%@",jsonDic);
        if ([jsonDic[@"ret"] intValue] == 200) {
            ksaveLocal(@"compid", jsonDic[@"data"][@"compid"]);
            ksaveLocal(@"postid", jsonDic[@"data"][@"post_id"]);
            ksaveLocal(@"userid", jsonDic[@"data"][@"user_id"]);
            MainViewController *mainVC = [[MainViewController alloc] init];
            [self.navigationController pushViewController:mainVC animated:true];
        }else{
//            kPError(jsonDic[@"msg"]);
            [self mainView];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        kPError(@"登录失败");
        [self mainView];
    }];
}

- (void)mainView{
    UIImageView *topImage = [[UIImageView alloc]init];
    [self.view addSubview:topImage];
    //topImage.backgroundColor = [UIColor greenColor];
    topImage.image = [UIImage imageNamed:@"JS0106.jpg"];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).with.offset(0);
//        make.right.equalTo(self.view).with.offset(0);
//        make.top.equalTo(self.view).with.offset(24);
//        make.height.mas_equalTo(self.view.bounds.size.width * 10 /16);
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    /*UIImageView *phoneLeftV = [[UIImageView alloc]init];
    [self.view addSubview:phoneLeftV];
    //phoneLeftV.backgroundColor = [UIColor greenColor];
    phoneLeftV.image = [UIImage imageNamed:@"JS0102"];
    [phoneLeftV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(25);
        make.top.equalTo(topImage).with.offset(self.view.bounds.size.width * 10 /16 + 50);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    UIView *line1 = [[UIView alloc]init];
    [self.view addSubview:line1];
    line1.backgroundColor = kSepareLineColor;
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(25);
        make.top.equalTo(phoneLeftV).with.offset(33);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(self.view.bounds.size.width - 50);
    }];
    
    UIImageView *passLeftV = [[UIImageView alloc]init];
    [self.view addSubview:passLeftV];
    //passLeftV.backgroundColor = [UIColor greenColor];
    passLeftV.image = [UIImage imageNamed:@"JS0103"];
    [passLeftV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(25);
        make.top.equalTo(phoneLeftV).with.offset(50);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    UIView *line2 = [[UIView alloc]init];
    [self.view addSubview:line2];
    line2.backgroundColor = kSepareLineColor;
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(25);
        make.top.equalTo(passLeftV).with.offset(33);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(self.view.bounds.size.width - 50);
    }];
    
    _phoneTextField = [[UITextField alloc]init];
    [self.view addSubview:_phoneTextField];
    _phoneTextField.placeholder = @"请输入手机号"; //默认显示的字
    //_phoneTextField.secureTextEntry = YES; //密码
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //_phoneTextField.backgroundColor = [UIColor redColor];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLeftV).with.offset(30);
        make.right.equalTo(self.view).with.offset(-25);
        make.centerY.equalTo(phoneLeftV);
        make.height.mas_equalTo(30);
    }];
    
    _passWordTextField = [[UITextField alloc]init];
    [self.view addSubview:_passWordTextField];
    _passWordTextField.placeholder = @"请输入密码"; //默认显示的字
    _passWordTextField.secureTextEntry = YES; //密码
    _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //_passWordTextField.backgroundColor = [UIColor redColor];
    [_passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLeftV).with.offset(30);
        make.right.equalTo(self.view).with.offset(-25);
        make.centerY.equalTo(passLeftV);
        make.height.mas_equalTo(30);
    }];
    
    UIView *middleShortLine = [[UIView alloc]init];
    middleShortLine.backgroundColor = kSepareLineColor;
    [self.view addSubview:middleShortLine];
    [middleShortLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2).with.offset(30);
        make.centerX.equalTo(line2);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(1);
    }];
     
    UIButton *loginButton = [[UIButton alloc]init];
    [self.view addSubview:loginButton];
    //loginButton.backgroundColor = [UIColor blueColor];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(30);
        make.right.equalTo(middleShortLine).with.offset(-5);
        make.centerY.equalTo(middleShortLine);
        make.height.mas_equalTo(30);
    }];

    UIButton *regButton = [[UIButton alloc]init];
    [self.view addSubview:regButton];
    //regButton.backgroundColor = [UIColor blueColor];
    [regButton setTitle:@"注册" forState:UIControlStateNormal];
    [regButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [regButton addTarget:self action:@selector(regButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [regButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleShortLine).with.offset(5);
        make.right.equalTo(self.view).with.offset(-30);
        make.centerY.equalTo(middleShortLine);
        make.height.mas_equalTo(30);
    }];*/
    
    UIButton *scaninButton = [[UIButton alloc]init];
    [self.view addSubview:scaninButton];
    //loginButton.backgroundColor = [UIColor blueColor];
    [scaninButton setTitle:@"扫码绑定" forState:UIControlStateNormal];
    [scaninButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scaninButton setBackgroundImage:[UIImage imageNamed:@"JS0105"] forState:UIControlStateNormal];
    [scaninButton.layer setCornerRadius:5.0f];
    [scaninButton setClipsToBounds:YES];
    [scaninButton addTarget:self action:@selector(scaninButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scaninButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *loginButton = [[UIButton alloc]init];
    [self.view addSubview:loginButton];
    //loginButton.backgroundColor = [UIColor blueColor];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"JS0105"] forState:UIControlStateNormal];
    [loginButton.layer setCornerRadius:5.0f];
    [loginButton setClipsToBounds:YES];
    [loginButton addTarget:self action:@selector(logginnginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scaninButton);
        make.centerX.equalTo(self.view);
        make.top.equalTo(scaninButton.mas_bottom).with.offset(10);
        make.height.mas_equalTo(50);
    }];

}

-(void)logginnginButtonClicked{
    NSDictionary *dic = @{
                          @"uuid":[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                          };
    [XSHttpTool GET:@"ESLogin.ESQuickLogin" param:dic success:^(id responseObject) {
        NSDictionary *jsonDic = [[NSDictionary alloc]init];
        jsonDic = responseObject;
        NSLog(@"登录返回json：%@",jsonDic);
        if ([jsonDic[@"ret"] intValue] == 200) {
                ksaveLocal(@"compid", jsonDic[@"data"][@"compid"]);
                ksaveLocal(@"postid", jsonDic[@"data"][@"post_id"]);
                ksaveLocal(@"userid", jsonDic[@"data"][@"user_id"]);
                MainViewController *mainVC = [[MainViewController alloc] init];
                [self.navigationController pushViewController:mainVC animated:true];
            
        }else{
            kPError(jsonDic[@"msg"]);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        kPError(@"登录失败");
    }];

    
}

-(void)scaninButtonClicked{
    ScanLoginViewController *sLoginVC = [[ScanLoginViewController alloc] init];
    [self.navigationController pushViewController:sLoginVC animated:true];
//    MainViewController *mainVC = [[MainViewController alloc] init];
//    [self.navigationController pushViewController:mainVC animated:true];
}

//点击空白处，键盘退下
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_phoneTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile:(NSString *)mobile{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    MyLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

//点击return按钮时回调的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    将键盘退下去
    [self.phoneTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    return YES;
}

-(void)loginButtonClicked{
    BOOL isPhone = [self isValidateMobile:_phoneTextField.text];
    if (!isPhone) {
        kPError(@"请输入正确的手机号");
    }
    else if(_passWordTextField.text.length < 6 || _passWordTextField.text.length > 16){
        kPError(@"密码为6-16个字符");
    }else{
    NSDictionary *dic = @{@"phonenum"  : _phoneTextField.text,
                          @"password" : _passWordTextField.text
                          };
    [XSHttpTool GET:@"User.Userlogin" param:dic success:^(id responseObject) {
        NSDictionary *jsonDic = [[NSDictionary alloc]init];
        jsonDic = responseObject;
        NSLog(@"登录返回json：%@",jsonDic);
        if ([jsonDic[@"ret"] intValue] == 200) {
            NSLog(@"登录成功");
            ksaveLocal(kUserName, jsonDic[@"data"][@"user_name"]);
            ksaveLocal(kUserId, jsonDic[@"data"][@"id"]);
            ksaveLocal(KPassword, _passWordTextField.text);
            ksaveLocal(kPhoneNumber, _phoneTextField.text);
            NSString *nameStr = kgetLocalData(kUserName);
            NSString *welcomeStr = [[NSString alloc]initWithFormat:@"%@,欢迎登录",nameStr];
            kPSuccess(welcomeStr);
            MainViewController *mainVC = [[MainViewController alloc] init];
            [self.navigationController pushViewController:mainVC animated:true];
        }else{
            kPError(@"登录失败");
        }

    } failure:^(NSError *error) {
        kPError(@"登录失败");
    }];
    }
}

-(void)regButtonClicked{

}

@end
