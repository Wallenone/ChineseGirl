//
//  NewsContentTableViewCell.m
//  ChineseGirl
//
//  Created by wallen on 2017/9/6.
//  Copyright © 2017年 wanjiehuizhaofang. All rights reserved.
//

#import "NewsContentTableViewCell.h"
#import "NewsContentCustomLabel.h"
#import "ShapedImageView.h"
#import "UIImage+Color.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "CGVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface NewsContentTableViewCell()<AVAudioPlayerDelegate>{
    FrontModel _front; //方向
}
@property(nonatomic,strong)NSDictionary *messageModel;
@property(nonatomic,strong)UIImageView *iconImgView;
@property(nonatomic,strong)NewsContentCustomLabel *textCentent;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *itemImgView;
@property(nonatomic,strong)UIImageView *itemVideoView;
@property(nonatomic,strong)UIView *radioView;
@property(nonatomic,strong)AVPlayer *audioPlayer;
@end
@implementation NewsContentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithModel:(NSDictionary *)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor clearColor];
        self.messageModel=model;
        if ([[self.messageModel stringForKey:@"turnFront"] isEqualToString:@"FrontLeft"]) {
            _front=FrontLeft;
        }else if ([[self.messageModel stringForKey:@"turnFront"] isEqualToString:@"FrontRight"]){
            _front=FrontRight;
        }
        
        [self creatSubView];
    }
    
    return self;
}

-(void)creatSubView{
    [self addSubview:self.timeLabel];
    [self addSubview:self.iconImgView];
    if ([[self.messageModel stringForKey:@"type"] integerValue]==1) {
        [self addSubview:self.textCentent];
    }else if ([[self.messageModel stringForKey:@"type"] integerValue]==2){
        [self addSubview:self.radioView];
    }else if ([[self.messageModel stringForKey:@"type"] integerValue]==3){
        [self addSubview:self.itemImgView];
    }else if ([[self.messageModel stringForKey:@"type"] integerValue]==4){
        [self addSubview:self.itemVideoView];
    }
    
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    // 替换为中等尺寸图片
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:[self.messageModel stringForKey:@"bigPicture"]]; // 图片路径
    photo.srcImageView = self.itemImgView; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

-(void)tapVideoImage:(UITapGestureRecognizer *)tap{
    CGVideoViewController *videoVC=[[CGVideoViewController alloc] init];
    videoVC.videoStr=[self.messageModel stringForKey:@"videoUrl"];
    [[self getCurrentVC].navigationController presentViewController:videoVC animated:NO completion:nil];
}

-(void)tapRadio:(UITapGestureRecognizer *)tap{
    // 5.开始播放
    // 3.打印歌曲信息
    //NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n 音频文件持续时间:%g",self.audioPlayer.numberOfChannels,self.audioPlayer.duration];
    [self.audioPlayer play];
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 15*SCREEN_RADIO, SCREEN_WIDTH, 13*SCREEN_RADIO)];
        _timeLabel.text=[CGCommonToolsNode getLongTime: (long)[[NSDate date] timeIntervalSince1970]];
        _timeLabel.textColor=[UIColor getColor:@"2A2A2A"];
        _timeLabel.font=[UIFont systemFontOfSize:11*SCREEN_RADIO];
        _timeLabel.textAlignment=NSTextAlignmentCenter;
        _timeLabel.backgroundColor=[UIColor clearColor];
    }
    
    return _timeLabel;
}

-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        CGFloat _textX;
        if (_front==FrontLeft) {
            _textX=15*SCREEN_RADIO;
        }else {
            _textX=screen_width-53*SCREEN_RADIO;
        }
        
        _iconImgView=[[UIImageView alloc] initWithFrame:CGRectMake(_textX,CGRectGetMaxY(self.timeLabel.frame)+15*SCREEN_RADIO, 38*SCREEN_RADIO, 38*SCREEN_RADIO)];
        _iconImgView.layer.cornerRadius=19*SCREEN_RADIO;
        if (_front==FrontLeft) {
            [_iconImgView sd_setImageWithURL:[NSURL URLWithString:[self.messageModel stringForKey:@"avater"]]];
        }else{
            _iconImgView.image=[CGSingleCommitData sharedInstance].avatar;
        }
    }
    
    return _iconImgView;
}

-(NewsContentCustomLabel *)textCentent{
    if (!_textCentent) {
        
        CGFloat _textWidth;
        CGFloat maxWidth =screen_width-144*SCREEN_RADIO;
        
        CGSize constraint = CGSizeMake(maxWidth, 99999.0f);
        CGSize size = [[self.messageModel stringForKey:@"message"] sizeWithFont:[UIFont systemFontOfSize:16*SCREEN_RADIO] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        if (size.width<maxWidth) {
            _textWidth = size.width +24*SCREEN_RADIO;
        }else{
            _textWidth = maxWidth;
        }
        
        CGFloat _textX;
        UIColor *_backGroundcolor;
        UIColor *_textColor;
        if (_front==FrontLeft) {
            _textX=60*SCREEN_RADIO;
            _backGroundcolor=[UIColor getColor:@"F3F3F3"];
            _textColor=[UIColor getColor:@"6F6F6F"];
        }else {
            _textX=(60*SCREEN_RADIO+(maxWidth-size.width))*SCREEN_RADIO;
            _backGroundcolor=[UIColor getColor:@"157CF8"];
            _textColor=[UIColor getColor:@"FFFFFF"];
        }
        
        _textCentent=[[NewsContentCustomLabel alloc] initWithFrame:CGRectMake(_textX, CGRectGetMaxY(self.timeLabel.frame)+15*SCREEN_RADIO, ceil(_textWidth), ceil(size.height+24*SCREEN_RADIO))];
        _textCentent.layer.cornerRadius=ceil(size.height+24*SCREEN_RADIO)*0.1;
        _textCentent.clipsToBounds = YES;
        _textCentent.font=[UIFont systemFontOfSize:16*SCREEN_RADIO];
        _textCentent.textColor = _textColor;
        _textCentent.backgroundColor=_backGroundcolor;
        _textCentent.userInteractionEnabled=NO;
        _textCentent.text=[self.messageModel stringForKey:@"message"];
        _textCentent.numberOfLines=0;
        //[_textCentent sizeToFit];
    }
    
    return _textCentent;
}

-(UIImageView *)itemImgView{
    if (!_itemImgView) {
        CGFloat _textX;
        if (_front==FrontLeft) {
            _textX=60*SCREEN_RADIO;
        }else {
            _textX=screen_width-53*SCREEN_RADIO;
        }
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
        _itemImgView=[[UIImageView alloc] initWithFrame:CGRectMake(_textX, CGRectGetMaxY(self.timeLabel.frame)+15*SCREEN_RADIO, 220*SCREEN_RADIO, 135*SCREEN_RADIO)];
        [_itemImgView sd_setImageWithURL:[NSURL URLWithString:[self.messageModel stringForKey:@"message"]] placeholderImage:placeholder];
        _itemImgView.layer.cornerRadius=20*SCREEN_RADIO;
        _itemImgView.clipsToBounds=YES;
        _itemImgView.contentMode =  UIViewContentModeScaleAspectFill;
        _itemImgView.userInteractionEnabled = YES;
        [_itemImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    }
    
    return _itemImgView;
}

-(UIImageView *)itemVideoView{
    if (!_itemVideoView) {
        CGFloat _textX;
        if (_front==FrontLeft) {
            _textX=60*SCREEN_RADIO;
        }else {
            _textX=screen_width-53*SCREEN_RADIO;
        }
        UIImage *placeholder = [UIImage imageNamed:@"timeline_image_loading.png"];
        _itemVideoView=[[UIImageView alloc] initWithFrame:CGRectMake(_textX, CGRectGetMaxY(self.timeLabel.frame)+15*SCREEN_RADIO, 220*SCREEN_RADIO, 135*SCREEN_RADIO)];
        [_itemVideoView sd_setImageWithURL:[NSURL URLWithString:[self.messageModel stringForKey:@"videoIcon"]] placeholderImage:placeholder];
        _itemVideoView.layer.cornerRadius=20*SCREEN_RADIO;
        _itemVideoView.clipsToBounds=YES;
        _itemVideoView.contentMode =  UIViewContentModeScaleAspectFill;
        _itemVideoView.userInteractionEnabled = YES;
        [_itemVideoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideoImage:)]];
        UIImageView *playView=[[UIImageView alloc] initWithFrame:CGRectMake(110*SCREEN_RADIO-19*SCREEN_RADIO, 67.5*SCREEN_RADIO-19*SCREEN_RADIO, 38*SCREEN_RADIO, 38*SCREEN_RADIO)];
        playView.image=[UIImage imageNamed:@"smallPlayVideo"];
        [_itemVideoView addSubview:playView];
    }
    
    return _itemVideoView;
}

-(UIView *)radioView{
    if (!_radioView) {
        CGFloat _textX;
        if (_front==FrontLeft) {
            _textX=60*SCREEN_RADIO;
        }else {
            _textX=screen_width-53*SCREEN_RADIO;
        }
        _radioView=[[UIView alloc] initWithFrame:CGRectMake(_textX, CGRectGetMaxY(self.timeLabel.frame)+15*SCREEN_RADIO, 100*SCREEN_RADIO, 38*SCREEN_RADIO)];
        _radioView.backgroundColor=[UIColor getColor:@"F3F3F3"];
        [_radioView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRadio:)]];
        _radioView.layer.cornerRadius=13*SCREEN_RADIO;
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(110*SCREEN_RADIO, 12*SCREEN_RADIO, 0, 14*SCREEN_RADIO)];
        label.font=[UIFont systemFontOfSize:14*SCREEN_RADIO];
        label.text=[NSString stringWithFormat:@"%@''",[self.messageModel stringForKey:@"radiosecond"]];
        label.textColor=[UIColor getColor:@"6F6F6F"];
        label.tag=100;
        [label sizeToFit];
        [_radioView addSubview:label];
    }
    
    return _radioView;
}

-(AVPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSURL * url  = [NSURL URLWithString:[self.messageModel stringForKey:@"radiourl"]];
        AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
        _audioPlayer = [[AVPlayer alloc]initWithPlayerItem:songItem];
    }
    
    return _audioPlayer;
}

//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}
@end

