//
//  ViewController.m
//  ShareSDK社会化分享
//
//  Created by dongzb on 16/1/10.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
#import "WeiboSDK.h"
#import <MOBFoundation/MOBFoundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.array = @[@"QQ空间",@"QQ 好友",@"微信好友",@"朋友圈",@"新浪微博"];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SSDKPlatformType type = 0;
    switch (indexPath.row) {
        case 0:
            type = SSDKPlatformSubTypeQZone;
            break;
        case 1:
            type = SSDKPlatformSubTypeQQFriend;
            break;
        case 2:
            type = SSDKPlatformSubTypeWechatSession;
            
            break;
        case 3:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;
            
        case 4:
            type = SSDKPlatformTypeSinaWeibo;
            break;
        default:
            break;
    }
    
    //1、创建分享参数
    NSArray* imageArray = @[@"http://mob.com/Assets/images/logo.png?v=20150320"];
//    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
  
        UIImage *image = [UIImage imageNamed:@"shareimage.jpg"];
        
        if (indexPath.row == self.array.count-1)
        {
            [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@\n%@",@"分享新鲜事",@"http://www.baidu.com"] title:@"剧能玩" image:image url:[NSURL URLWithString:@"http://www.baidu.com"] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
        }else
        {
            [shareParams SSDKSetupShareParamsByText:@"这是一条分享"
                                             images:imageArray
                                                url:[NSURL URLWithString:@"http://www.baidu.com"]
                                              title:@"自定义分享内容"
                                               type:SSDKContentTypeAuto];
        }
        
        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                    
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                    
                 case SSDKResponseStateCancel:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户取消"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                }
                    break;
                default:
                    break;
            }

         
        }];
        
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                               ];}
    }
}

@end
