//
//  AccountSettingViewController.h
//  szeca
//
//  Created by MC374 on 12-4-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myImageView.h"
#import "IconDownLoader.h"

@interface AccountSettingViewController : UITableViewController <IconDownloaderDelegate ,myImageViewDelegate>{
	NSMutableArray *weiboAccountArray;
	NSString *weiBoName;
	NSString *headImageUrl;
	NSString *weiboType;
	IconDownLoader *iconDownLoad;
}

@property(nonatomic,retain) NSMutableArray *weiboAccountArray;
@property(nonatomic,retain) NSString *weiBoName;
@property(nonatomic,retain) NSString *headImageUrl;
@property(nonatomic,retain) IconDownLoader *iconDownLoad;
@property(nonatomic,retain) NSString *weiboType;

-(void)loadHeadImage;

@end
