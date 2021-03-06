//
//  CGRegisterIndexView.m
//  ChineseGirl
//
//  Created by wallen on 2017/8/31.
//  Copyright © 2017年 wanjiehuizhaofang. All rights reserved.
//

#import "CGRegisterIndexView.h"
#import "CGLoginIndexCustomTextField.h"
@interface CGRegisterIndexView(){
    CancelClickBlock cancelClickBlock;
    RegSingUpClickBlock regSingUpClickBlock;
    ChooseCityClickBlock chooseCityClickBlock;
}
@property(nonatomic,strong)UIImageView *bgImgView;
@property(nonatomic,strong)RkyExtendedHitButton *cancelBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)CGLoginIndexCustomTextField *userNameField;
@property(nonatomic,strong)CGLoginIndexCustomTextField *EmailField;
@property(nonatomic,strong)CGLoginIndexCustomTextField *passwordField;
@property(nonatomic,strong)CGLoginIndexCustomTextField *cityField;
@property(nonatomic,strong)RkyExtendedHitButton *cityBtn;
@property(nonatomic,strong)UILabel *AgreementLabel;
@property(nonatomic,strong)RkyExtendedHitButton *signUpBtn;
@end
@implementation CGRegisterIndexView


- (id)initWithFrame:(CGRect)frame onCancelClick:(CancelClickBlock)cancelBlock onSingUpClick:(RegSingUpClickBlock)singUpBlock onChooseCityBlock:(ChooseCityClickBlock)chooseCityBlock{
    self.backgroundColor=[UIColor clearColor];
    if (self=[super initWithFrame:frame]) {
        cancelClickBlock = cancelBlock;
        regSingUpClickBlock = singUpBlock;
        chooseCityClickBlock =chooseCityBlock;
        [self addSubViews];
    }
    
    return self;
    
}

-(void)addSubViews{
    [self addSubview:self.bgImgView];
    UIView *_view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.bgImgView addSubview:_view];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.userNameField];
    [self addSubview:self.EmailField];
    [self addSubview:self.passwordField];
    [self addSubview:self.cityField];
    [self addSubview:self.cityBtn];
    [self addSubview:self.AgreementLabel];
    [self addSubview:self.signUpBtn];
}

-(void)chooseCity{
    if (chooseCityClickBlock) {
       chooseCityClickBlock();
    }
}

-(void)updateCellContent:(NSString *)cellData{
    self.cityField.text=cellData;
}

-(void)singUpClick{
    if (self.userNameField.text.length>0) {
        if ([self isValidateEmail:self.EmailField.text]) {
            if (self.passwordField.text.length>=6) {
                
                if (self.cityField.text.length>0) {
                    [CGSingleCommitData sharedInstance].uid=self.EmailField.text;
                    [CGSingleCommitData sharedInstance].nickName=self.userNameField.text;
                    [CGSingleCommitData sharedInstance].email=self.EmailField.text;
                    [CGSingleCommitData sharedInstance].password=self.passwordField.text;
                    [CGSingleCommitData sharedInstance].cityName=self.cityField.text;
                    if (regSingUpClickBlock) {
                        regSingUpClickBlock(YES,NSLocalizedString(@"register_success", nil));
                    }
                }else{
                    if (regSingUpClickBlock) {
                        regSingUpClickBlock(NO,NSLocalizedString(@"city_can_not_be_empty", nil));
                    }
                }
                
            }else{
                
                if (regSingUpClickBlock) {
                    regSingUpClickBlock(NO,NSLocalizedString(@"password_no_less_than_6_characters", nil));
                }
            }
            
            
        }else{
            if (regSingUpClickBlock) {
                regSingUpClickBlock(NO,NSLocalizedString(@"the_mailbox_format_is_incorrect", nil));
            }
        }
    }else{
        if (regSingUpClickBlock) {
            regSingUpClickBlock(NO,NSLocalizedString(@"username_cannot_be_empty", nil));
        }
    }
    
    
    
}

-(void)cancelClick{
    if (cancelClickBlock) {
        cancelClickBlock();
    }
}


-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _bgImgView.image= [self imageByApplyingAlpha:0.9 image: [UIImage imageNamed:@"reg_Bitmap"]];
    }
    
    return _bgImgView;
}

-(RkyExtendedHitButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn=[[RkyExtendedHitButton alloc] initWithFrame:CGRectMake(16*SCREEN_RADIO, 33*SCREEN_RADIO, 10*SCREEN_RADIO, 19*SCREEN_RADIO)];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"Arrowleft"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-25, -25, -25, -25);
    }
    
    return _cancelBtn;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 94.6*SCREEN_RADIO, screen_width, 26*SCREEN_RADIO)];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.textColor=[UIColor getColor:@"ffffff"];
        _titleLabel.font=[UIFont boldSystemFontOfSize:24*SCREEN_RADIO];
        _titleLabel.text=NSLocalizedString(@"chuangjiannideid", nil);
    }
    
    return _titleLabel;
}


-(CGLoginIndexCustomTextField *)userNameField{
    if (!_userNameField) {
        _userNameField=[[CGLoginIndexCustomTextField alloc] initWithFrame:CGRectMake(62.5*SCREEN_RADIO, CGRectGetMaxY(self.titleLabel.frame)+45.8*SCREEN_RADIO, screen_width-125*SCREEN_RADIO, 45*SCREEN_RADIO)];
        _userNameField.layer.cornerRadius=45/2*SCREEN_RADIO;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // 设置富文本对象的颜色
        attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
        // 设置UITextField的占位文字
        _userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Username", nil) attributes:attributes];
        _userNameField.textColor=[UIColor whiteColor];
        _userNameField.backgroundColor=[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.2];
        UIImageView *imageViewuserName=[[UIImageView alloc]initWithFrame:CGRectMake(44*SCREEN_RADIO, 13*SCREEN_RADIO, 23*SCREEN_RADIO, 19*SCREEN_RADIO)];
        imageViewuserName.image=[UIImage imageNamed:@"reg_Avatar"];
        _userNameField.rightView=imageViewuserName;
        _userNameField.rightViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        _userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
        _userNameField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    }
    
    return _userNameField;
}

-(CGLoginIndexCustomTextField *)EmailField{
    if (!_EmailField) {
        _EmailField=[[CGLoginIndexCustomTextField alloc] initWithFrame:CGRectMake(62.5*SCREEN_RADIO, CGRectGetMaxY(self.userNameField.frame)+15*SCREEN_RADIO, screen_width-125*SCREEN_RADIO, 45*SCREEN_RADIO)];
        _EmailField.layer.cornerRadius=45/2*SCREEN_RADIO;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // 设置富文本对象的颜色
        attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
        // 设置UITextField的占位文字
        _EmailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Email", nil) attributes:attributes];
        _EmailField.textColor=[UIColor whiteColor];
        _EmailField.backgroundColor=[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.2];
        UIImageView *imageViewuserName=[[UIImageView alloc]initWithFrame:CGRectMake(44*SCREEN_RADIO, 13*SCREEN_RADIO, 23*SCREEN_RADIO, 19*SCREEN_RADIO)];
        imageViewuserName.image=[UIImage imageNamed:@"login_Mail"];
        _EmailField.rightView=imageViewuserName;
        _EmailField.rightViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        _EmailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _EmailField.autocorrectionType = UITextAutocorrectionTypeNo;
        _EmailField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    }
    
    return _EmailField;
}

-(CGLoginIndexCustomTextField *)passwordField{
    if (!_passwordField) {
        _passwordField=[[CGLoginIndexCustomTextField alloc] initWithFrame:CGRectMake(62.5*SCREEN_RADIO, CGRectGetMaxY(self.EmailField.frame)+15*SCREEN_RADIO, screen_width-125*SCREEN_RADIO, 45*SCREEN_RADIO)];
        _passwordField.layer.cornerRadius=45/2*SCREEN_RADIO;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // 设置富文本对象的颜色
        attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
        // 设置UITextField的占位文字
        _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", nil) attributes:attributes];
        _passwordField.textColor=[UIColor whiteColor];
        _passwordField.backgroundColor=[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.2];
        UIImageView *imageViewPassword=[[UIImageView alloc]initWithFrame:CGRectMake(44*SCREEN_RADIO, 13*SCREEN_RADIO, 23*SCREEN_RADIO, 19*SCREEN_RADIO)];
        imageViewPassword.image=[UIImage imageNamed:@"login_Password"];
        _passwordField.rightView=imageViewPassword;
        _passwordField.rightViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    }
    
    return _passwordField;
}

-(CGLoginIndexCustomTextField *)cityField{
    if (!_cityField) {
        _cityField=[[CGLoginIndexCustomTextField alloc] initWithFrame:CGRectMake(62.5*SCREEN_RADIO, CGRectGetMaxY(self.passwordField.frame)+15*SCREEN_RADIO, screen_width-125*SCREEN_RADIO, 45*SCREEN_RADIO)];
        _cityField.layer.cornerRadius=45/2*SCREEN_RADIO;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // 设置富文本对象的颜色
        attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
        // 设置UITextField的占位文字
        _cityField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Your_City", nil) attributes:attributes];
        _cityField.textColor=[UIColor whiteColor];
        _cityField.backgroundColor=[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.2];
        UIImageView *imageViewPassword=[[UIImageView alloc]initWithFrame:CGRectMake(44*SCREEN_RADIO, 13*SCREEN_RADIO, 23*SCREEN_RADIO, 19*SCREEN_RADIO)];
        imageViewPassword.image=[UIImage imageNamed:@"location"];
        _cityField.rightView=imageViewPassword;
        _cityField.rightViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        _cityField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _cityField.autocorrectionType = UITextAutocorrectionTypeNo;
        _cityField.autocapitalizationType=UITextAutocapitalizationTypeNone;
        _cityField.userInteractionEnabled=NO;
    }
    
    return _cityField;
}

-(RkyExtendedHitButton *)cityBtn{
    if (!_cityBtn) {
        _cityBtn=[[RkyExtendedHitButton alloc] initWithFrame:CGRectMake(62.5*SCREEN_RADIO, CGRectGetMaxY(self.passwordField.frame)+15*SCREEN_RADIO, screen_width-125*SCREEN_RADIO, 45*SCREEN_RADIO)];
        [_cityBtn addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
        _cityBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-25, -25, -25, -25);
    }
    
    return _cityBtn;
}


-(UILabel *)AgreementLabel{
    if (!_AgreementLabel) {
        _AgreementLabel=[[UILabel alloc] initWithFrame:CGRectMake(57*SCREEN_RADIO, CGRectGetMaxY(self.cityField.frame)+25*SCREEN_RADIO, screen_width-113.5*SCREEN_RADIO, 0)];
        _AgreementLabel.font=[UIFont systemFontOfSize:14*SCREEN_RADIO];
        _AgreementLabel.textColor=[UIColor getColor:@"99A3A9"];
        _AgreementLabel.text=NSLocalizedString(@"agreenTips", nil);
        _AgreementLabel.textAlignment=NSTextAlignmentCenter;
        _AgreementLabel.numberOfLines=2;
        [_AgreementLabel sizeToFit];
    }
    
    return _AgreementLabel;
}



-(RkyExtendedHitButton *)signUpBtn{
    if (!_signUpBtn) {
        _signUpBtn=[[RkyExtendedHitButton alloc] initWithFrame:CGRectMake(87.5*SCREEN_RADIO, CGRectGetMaxY(self.AgreementLabel.frame)+24*SCREEN_RADIO, screen_width-87.5*2*SCREEN_RADIO, 52*SCREEN_RADIO)];
        [_signUpBtn setTitle:NSLocalizedString(@"signup", nil) forState:UIControlStateNormal];
        [_signUpBtn addTarget:self action:@selector(singUpClick) forControlEvents:UIControlEventTouchUpInside];
        _signUpBtn.titleLabel.font=[UIFont systemFontOfSize:22*SCREEN_RADIO];
        [_signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signUpBtn.layer.cornerRadius=52/2*SCREEN_RADIO;
        _signUpBtn.layer.borderWidth=2;
        _signUpBtn.layer.borderColor=[UIColor whiteColor].CGColor;
        _signUpBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-25, -25, -25, -25);
    }
    
    return _signUpBtn;
}


/**
 *  设置图片透明度
 * @param alpha 透明度
 * @param image 图片
 */
-(UIImage *)imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);

    CGContextSetAlpha(ctx, alpha);

    CGContextDrawImage(ctx, area, image.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
    
}

- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
