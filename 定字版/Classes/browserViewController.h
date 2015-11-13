//
//  browserViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-9-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class manageActionSheet;
@class UpdateAppAlert;
@interface browserViewController : UIViewController <MBProgressHUDDelegate>{

	UIWebView *webView;
	MBProgressHUD *progressHUD;
	manageActionSheet *actionsheet;
	UIToolbar *testtb;
	NSString *linkurl;
	NSString *linktitle;
	UIBarButtonItem * ButtonItem;//  
	BOOL isHideToolbar;
	BOOL isFirstLoad;
	BOOL isShowCommentButton;
	NSNumber *newsID;
	NSNumber *moduleType;

	int commentCount;
	NSString *newsTitle;
	manageActionSheet *weChatActionsheet;
	NSString *newsDesc;
	UIImage *newsImage;
	UpdateAppAlert *weChatAlert;
    
    CGFloat viewHeight;

}
@property(nonatomic,retain)IBOutlet UIWebView *webView;
@property(nonatomic,retain)IBOutlet UIToolbar *testtb;
@property(nonatomic,retain)NSString *linkurl;
@property(nonatomic,retain)NSString *linktitle;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic,retain)manageActionSheet *actionsheet;
@property(nonatomic,retain)UIBarButtonItem *ButtonItem;
@property(nonatomic,retain)NSNumber *newsID;
@property(nonatomic,retain)NSNumber *moduleType;
@property(nonatomic,retain)NSString *newsDesc;
@property(nonatomic,retain)NSString *newsTitle;
@property(nonatomic,retain)manageActionSheet *weChatActionsheet;
@property(nonatomic,retain)UIImage *newsImage;
@property(nonatomic,retain)UpdateAppAlert *weChatAlert;
@property(nonatomic)BOOL isHideToolbar;
@property(nonatomic)BOOL isFirstLoad;
@property(nonatomic)BOOL isShowCommentButton;
@property(nonatomic,assign)int commentCount;
-(void)loadURL:(NSString*)str_URL;
-(IBAction)reload:(id)sender;
-(IBAction)search:(id)sender;
-(IBAction)share:(id)sender;
-(IBAction)comment:(id)sender;
@end
