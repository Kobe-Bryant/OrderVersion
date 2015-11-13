//
//  CommandOperation.m
//  AppStrom
//
//  Created by 掌商 on 11-9-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommandOperation.h"
#import "CommandParser.h"
#import "Common.h"

#import "AppStromAppDelegate.h"
#import "NetPopupWindow.h"

@implementation CommandOperation
@synthesize reqStr;
@synthesize delegate;
@synthesize requestParam;

- (id)initWithReqStr:(NSString*)rstr command:(int)cmd delegate:(id <commandOperationDelegate>)theDelegate params:(NSDictionary*)param{

	self = [super init];
	if (self != nil)
	{
		self.reqStr = rstr;
		self.delegate = theDelegate;
		command = cmd;
		self.requestParam = param;
	}
    return self;
}
-(NSMutableArray*)parseJsonandGetVersion:(int*)ver{
	//[self AccessService];
	NSString *resultStr = [[NSString alloc]initWithData:[self AccessService] encoding: NSUTF8StringEncoding];
//	NSLog(@"data from server result %@",resultStr);
	
	NSMutableArray *resultArray = nil;
	
    if ([resultStr isEqualToString:@"{}"] || [resultStr isEqualToString:@"{\"Error\":\"4001\"}"] || [resultStr isEqualToString:@"{\"Error\":\"4002\"}"] || [resultStr isEqualToString:@"{\"Error\":\"4003\"}"])
    {
        *ver = NO_UPDATE;
        NSLog(@"------数据为空或请求发生错误 结果: %@",resultStr);
    }
    else
    {
        switch (command) {
		case HOT_RECOMMENDED:
		{
			resultArray = [CommandParser parseHotRecommended:resultStr getVersion:ver];
			break;
		}
		case PROMOTIONS:
		{
			resultArray = [CommandParser parsePromotions:resultStr getVersion:ver];
			break;
		}
		case COMPANY_NEWS:
		{
			resultArray = [CommandParser parseCompanyNews:resultStr getVersion:ver];
			break;
		}
		case SERVICE:
		{
			resultArray = [CommandParser parseService:resultStr getVersion:ver];
			break;
		}
		case COMMUNITY:
		{
			resultArray = [CommandParser parseSNS:resultStr getVersion:ver];
			break;
		}
		case ABOUTUS:
		{
			resultArray = [CommandParser parseAboutus:resultStr getVersion:ver];
			break;
		}
		case PRODUCT:
		{
			NSLog(@"commandoperation parser product!");
			resultArray = [CommandParser parseProducts:resultStr getVersion:ver];
			break;
		}
		case WALLPAPER:
		{
			resultArray = [CommandParser parseWallPaper:resultStr getVersion:ver];
			break;
		}
		case APNS:
		{
			resultArray = [CommandParser parseApns:resultStr getVersion:ver];
			break;
		}
		case SINAWEIAPI:
		{
			NSNumber *userid = [requestParam objectForKey:@"weibo_user_id"];
			resultArray = [CommandParser parseSinaUserInfo:resultStr weiboUserID:userid];
			break;
		}
		case COMMENTLIST:
		{
			NSNumber *module_type_id = [requestParam objectForKey:@"module_type_id"];
			NSNumber *module_id = [requestParam objectForKey:@"module_id"];
			resultArray = [CommandParser parseCommentList:resultStr getVersion:ver moduleTypeId:module_type_id moduleId:module_id];
			break;
		}
		case COMMENTLIST_MORE:
		{
			resultArray = [CommandParser parseCommentListMore:resultStr getVersion:ver];
			break;
		}
		case PUBLISH_COMMENT:
		{
			resultArray = [CommandParser parsePublishComment:resultStr];
			break;
		}	
		case COMMENT_REPLY_LIST:
		{
			resultArray = [CommandParser parseCommentReplyList:resultStr getVersion:ver];
			break;
		}
		case FANSWALL_COMMENTLIST:
		{
			resultArray = [CommandParser parseFansWallCommentList:resultStr getVersion:ver];
			break;
		}
		case FANSWALL_RECENTLY_COMMENTLIST:
		{
			resultArray = [CommandParser parseFansWallRecentlyCommentList:resultStr getVersion:ver];
			break;
		}
		case MORE_FANSWALL_COMMENTLIST:
		{
			resultArray = [CommandParser parseMoreFansWallCommentList:resultStr getVersion:ver];
			break;
		}
		default:
			break;
	}
    }
    
	[resultStr release];
	return resultArray;
}
-(NSData*)AccessService{

	NSURL *url;
	url = [NSURL URLWithString:reqStr];
	NSLog(@"url:%@",url);
	//NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                          timeoutInterval:15];
    
	NSURLResponse *response; 
	NSError *error = nil;
	NSData* dataReply = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
	if(error != nil)
	{
		NSException *exception =[NSException exceptionWithName:@"网络异常"
								 
														reason:[error  localizedDescription]
								 
													  userInfo:[error userInfo]];
		
		@throw exception;
		NSLog(@"NSURLConnection error %@",[error  localizedDescription]);
	}
	return dataReply;
}

- (void)show
{
    AppStromAppDelegate *app = (AppStromAppDelegate *)[UIApplication sharedApplication].delegate;
    [[NetPopupWindow defaultExample] showCustemAlertViewIninView:app.window];
}

- (void)main
{
    if ([netWorkQueueArray indexOfObject:self.reqStr] != NSNotFound)
    {
        return;
    }
    
    [netWorkQueueArray addObject:self.reqStr];
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray* result;
	int ver;
	NSLog(@"star thread");
	@try {
		result =[self parseJsonandGetVersion:&ver];
	}
	@catch (NSException *exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
		if (![self isCancelled]&& delegate != nil)
		{
		[delegate didFinishCommand:result withVersion:ver];
		}
        [netWorkQueueArray removeObject:self.reqStr];
		self.reqStr = nil;
		[pool release];
        
        //if(![Common connectedToNetwork])
        {
            [self performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
        
		return;
	}
    if (![self isCancelled]&& delegate != nil)
	{
		//NSLog(@"deleget result  %@",result);
		[delegate didFinishCommand:result withVersion:ver];
	}
    [netWorkQueueArray removeObject:self.reqStr];
	self.reqStr = nil;
	[pool release];
}

-(void)dealloc{
	delegate = nil;
	self.reqStr = nil;
	self.requestParam = nil;
	[super dealloc];
}
@end
