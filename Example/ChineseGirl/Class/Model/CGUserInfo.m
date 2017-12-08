//
//  CGUserInfo.m
//  ChineseGirl_Example
//
//  Created by Wallen on 2017/11/12.
//  Copyright © 2017年 wanjiehuizhaofang. All rights reserved.
//

#import "CGUserInfo.h"
#import "CGMessageModel.h"
@interface CGUserInfo()
@end
@implementation CGUserInfo
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    CGUserInfo *model = [[CGUserInfo alloc]init];
    model.ids = [self filterNullString:[dic stringForKey:@"id"]];
    model.nickname = [self filterNullString:[dic stringForKey:@"nickname"]];
    model.sex = [self filterNullString:[dic stringForKey:@"sex"]];
    model.birthday = [self filterNullString:[dic stringForKey:@"birthday"]];
    model.aboutus = [self filterNullString:[dic stringForKey:@"aboutus"]];
    model.avater = [NSString stringWithFormat:@"%@%@%@%@",@"https://raw.githubusercontent.com/Wallenone/service/master/imgData/",model.ids,@"/Enclosure/",[self filterNullString:[dic stringForKey:@"avater"]]];
    model.address = [NSString stringWithFormat:@"China,%@",[self filterNullString:[dic stringForKey:@"city"]]] ;
    model.bigAvater = [self getBigAvater:model.avater withIds:model.ids];
    model.pictures = [self getPictures:[self filterNullString:[dic stringForKey:@"pictures"]] withIds:model.ids];
    model.picturesBig = [self getBigPictures:[self filterNullString:[dic stringForKey:@"pictures"]] withIds:model.ids];
    model.messageids = [self getMessageIds:[self filterNullString:[dic stringForKey:@"messageid"]]];
    return model;
}

+(NSArray *)reloadTableRondomCount:(NSInteger)count{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"userInfo" ofType:@"plist"];
    NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    NSMutableArray *newData=[NSMutableArray new];
    
    NSArray *newarr1= [CGCommonToolsNode genertateRandomNumberStartNum:0 endNum:(int)(data1.count)-1 count:(int)data1.count];
    for (NSString *ids in newarr1) {
        CGUserInfo *userInfoModel=[self modelWithDic:[data1 objectAtIndex:[ids integerValue]]];
        [newData addObject:userInfoModel];
    }
    
    return newData;
}

+(void)getTableRondomNewsUser{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"userInfo" ofType:@"plist"];
    NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    int _userid=[CGCommonString getRandomNumber:0 to:(int)data1.count-1];
    
    if([[CGSingleCommitData sharedInstance].userListDataArr containsObject:[NSString stringWithFormat:@"%d",_userid]]){
        [self getTableRondomNewsUser];//todo 这个地方后期需要改善
    }else{
        [[CGSingleCommitData sharedInstance] addUserListDataArr:[NSString stringWithFormat:@"%d",_userid]];
        [[CGSingleCommitData sharedInstance] addNewlists:@{@"userid":@(_userid),@"item":@[@{@"type":@"0",@"message":@""}]}];
    }
}


+(void)updateReloadTable{
    [CGSingleCommitData sharedInstance].userListDataArr = [[self reloadTableRondomCount:999999] mutableCopy];
}

+(NSMutableArray *)reloadTableWithRangeFrom:(NSInteger)fromNum rangeTLenth:(NSInteger)lenth{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"userinfo" ofType:@"plist"];
//    NSMutableArray *data1 = [[[[NSMutableArray alloc] initWithContentsOfFile:filePath] subarrayWithRange:NSMakeRange(fromNum, lenth)] mutableCopy];
//
    NSMutableArray *newData=[NSMutableArray new];
    
    NSInteger currentNum=fromNum+lenth;
    if ([CGSingleCommitData sharedInstance].userListDataArr.count>currentNum) {
        NSMutableArray *data2 = [[[CGSingleCommitData sharedInstance].userListDataArr subarrayWithRange:NSMakeRange(fromNum, lenth)] mutableCopy];
        for (CGUserInfo *model in data2) {
            [newData addObject:model];
        }
    }else{
        NSInteger t_num=[CGSingleCommitData sharedInstance].userListDataArr.count-fromNum;
        if (t_num>0) {
            NSMutableArray *data2 = [[[CGSingleCommitData sharedInstance].userListDataArr subarrayWithRange:NSMakeRange(fromNum, [CGSingleCommitData sharedInstance].userListDataArr.count-fromNum)] mutableCopy];
            for (CGUserInfo *model in data2) {  
                [newData addObject:model];
            }
        }
        
    }
    
    return newData;
}

+(CGUserInfo *)getitemWithID:(NSString *)ids{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"userInfo" ofType:@"plist"];
    NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    NSDictionary *dict= [data1 objectAtIndex:[ids intValue]-1];
    
    CGUserInfo *model1= [self modelWithDic:dict];
    if ([model1.ids isEqualToString:ids]) {
        BOOL _isLike=NO;
        for (NSString *content in [CGSingleCommitData sharedInstance].follows) {
            if (content.length>0) {
                if ([content isEqualToString:model1.ids]) {
                    _isLike = YES;
                }
            }
        }
        model1.followed=_isLike;
    }
    
    return model1;
}

+(NSString *)getBigAvater:(NSString *)icon withIds:(NSString *)ids{
    NSArray *array = [icon componentsSeparatedByString:@"/"];
    NSString *iconTstr=[array objectAtIndex:array.count-1];
    NSArray *array1 = [iconTstr componentsSeparatedByString:@"."];
    NSString *bstr=[[array1 objectAtIndex:0] stringByReplacingOccurrencesOfString:@"S" withString:@"B"];
    NSString *newIcon= [NSString stringWithFormat:@"%@%@%@%@%@%@",@"https://raw.githubusercontent.com/Wallenone/service/master/imgData/",ids,@"/Enclosure/",bstr,@".",[array1 objectAtIndex:1]];
    
    return newIcon;
}

+(NSMutableArray *)getPictures:(NSString *)icon withIds:(NSString *)ids{
    NSArray *array = [icon componentsSeparatedByString:@"/"];
    NSMutableArray *newArr=[NSMutableArray new];
    for (NSString *img in array) {
        NSString *newIcon= [NSString stringWithFormat:@"%@%@%@%@",@"https://raw.githubusercontent.com/Wallenone/service/master/imgData/",ids,@"/Enclosure/",img];
        [newArr addObject:newIcon];
    }
    
    return newArr;
}

+(NSMutableArray *)getBigPictures:(NSString *)icon withIds:(NSString *)ids{
    NSArray *array = [icon componentsSeparatedByString:@"/"];
    NSMutableArray *newArr=[NSMutableArray new];
    for (NSString *img in array) {
        NSArray *array1 = [img componentsSeparatedByString:@"."];
        NSString *bstr=[[array1 objectAtIndex:0] stringByReplacingOccurrencesOfString:@"S" withString:@"B"];
        NSString *newIcon= [NSString stringWithFormat:@"%@%@%@%@%@%@",@"https://raw.githubusercontent.com/Wallenone/service/master/imgData/",ids,@"/Enclosure/",bstr,@".",[array1 objectAtIndex:1]];
        [newArr addObject:newIcon];
    }
    
    return newArr;
}

+(NSMutableArray *)getMessageIds:(NSString *)messageids{
    NSArray *array = [messageids componentsSeparatedByString:@"/"];
    NSMutableArray *newArr=[NSMutableArray new];
    for (NSString *messageid in array) {
        CGMessageModel *model=[CGMessageModel reloadReloadRondomIds:messageid];
        [newArr addObject:model];
    }
    
    return newArr;
}

+(NSString *)filterNullString:(NSString *)str{
    NSString *filterStr=str;
    BOOL filterState= [CGCommonString isBlankString:str];
    if (filterState) {
        filterStr=@"";
    }
    return filterStr;
}
@end
