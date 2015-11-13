//
//  AccountSettingViewController.m
//  szeca
//
//  Created by MC374 on 12-4-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "Common.h"
#import "alertView.h"
#import "LoginViewController.h"
#import "DBOperate.h"
#import "FileManager.h"

@implementation AccountSettingViewController

@synthesize weiboAccountArray;
@synthesize weiBoName;
@synthesize headImageUrl;
@synthesize iconDownLoad;
@synthesize weiboType;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"账号设置";
    self.tableView.backgroundView = nil;
    
	self.weiboAccountArray = (NSMutableArray *)[DBOperate queryData:T_WEIBO_USERINFO theColumn:nil theColumnValue:nil  withAll:YES];

	if (weiboAccountArray != nil && [weiboAccountArray count] > 0) {
		NSArray *one = [weiboAccountArray objectAtIndex:0];
		if (one != nil) {
			weiBoName = [one objectAtIndex:weibo_user_name];
			headImageUrl = [one objectAtIndex:weibo_profile_image];
			weiboType = [one objectAtIndex:weibo_type];
		}
	}
//	NSLog(headImageUrl);
//	[self startIconDownload:headImageUrl forIndex:[NSIndexPath indexPathWithIndex:0]];

//	UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"背景" ofType:@"png"]];
//	backView.image = img;
//	[img release];
//	[self.view addSubview:backView];
//	[backView release];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
	weiboAccountArray = nil;
	weiBoName = nil;
	headImageUrl = nil;
	iconDownLoad.delegate = nil;
	iconDownLoad = nil;
	self.weiboType = nil;
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.weiboAccountArray = nil;
	self.weiBoName = nil;
	self.headImageUrl = nil;
	iconDownLoad.delegate = nil;
	self.iconDownLoad = nil;
	self.weiboType = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	return 1; 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath row] == 1) {
		return 45.0f;
	}else if ([indexPath row] == 0) {
		return 110;
	}
	else {
		return 80.0f;
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"Cell"];
	if (!cell) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		 cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if([indexPath row] > 1){
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.editingAccessoryType = UITableViewCellAccessoryNone;
		}
	}
	if ([indexPath row] == 0) {
		myImageView *imageview = [[myImageView alloc]initWithFrame:CGRectMake(8, 10, 80, 80) withImageId:0];
		imageview.tag = 1001;
//		imageview.mydelegate = self;
		UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"微博默认头像" ofType:@"png"]];
		imageview.image = img;		
		[cell.contentView addSubview:imageview];
		
		UIImage *photo = [FileManager getPhoto:weiboType];
		if (photo != nil) {
			imageview.image = photo;
		}else {
			[self startIconDownload:headImageUrl forIndex:[NSIndexPath indexPathWithIndex:0]];
		}

		[img release];
		[imageview release];
		
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 45 , 100, 30)];
		if (weiBoName != nil) {
			nameLabel.text = weiBoName;
		}else{
			nameLabel.text =  @"微博昵称";
		}
		nameLabel.tag = 102;
		[cell.contentView addSubview:nameLabel];
		[nameLabel release];
		
		UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
		[but setBackgroundImage:[UIImage imageNamed:@"注销按钮.png"] forState:UIControlStateNormal];
		[but setFrame:CGRectMake(200, 35, 100, 40)];
		[but setAlpha:0.8];
		[but addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:but];
		
	}else if ([indexPath row] == 1) {
		cell.textLabel.text = @"使用以下方式重新登陆:";
		cell.textLabel.font = [UIFont systemFontOfSize:12];
	}else if ([indexPath row] == 2){
		UIImage *image =  [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新浪" ofType:@"png"]];
		cell.imageView.image = image;
		[image release];
		cell.textLabel.text = @"新浪微博";
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(230,25, 120, 30)];
		if([weiboType isEqualToString:@"sina"]){
			lable.text = @"登录中";
		}else {
			lable.text = @"未登录";
		}
		lable.tag = 100;
		[cell.contentView addSubview:lable];
		[lable release];
 	}else if ([indexPath row] == 3){
		UIImage *image =  [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"腾讯" ofType:@"png"]];
		cell.imageView.image = image;
		[image release];
		cell.textLabel.text = @"腾讯微博";
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(230, 25, 80, 30)];
		if ([weiboType isEqualToString:@"tencent"]) {
			lable.text = @"登录中";
		}else{
			lable.text = @"未登录";	
		}
		lable.tag = 101;
		[cell.contentView addSubview:lable];
		[lable release];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([indexPath row] == 2 ) {
		if ([weiboType isEqualToString:@"sina"]) {
			[alertView showAlert:@"已经使用该账号登陆"];
		}else {
			LoginViewController *login = [[LoginViewController alloc] init];
			[self.navigationController pushViewController:login animated:YES];
			[login release];
		}
	}
	if ([indexPath row] == 3){
		if ([weiboType isEqualToString:@"tencent"]) {
			[alertView showAlert:@"已经使用该账号登陆"];
		}else {
			LoginViewController *login = [[LoginViewController alloc] init];
			[self.navigationController pushViewController:login animated:YES];
			[login release];
		}
	}
	[self.tableView reloadData];
}

-(void)handleButtonPress:(id)sender{
	[DBOperate deleteALLData:T_WEIBO_USERINFO];
//	weiBoAccount = @"";
//	[self.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}



- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{

    if (iconDownLoad == nil && imageURL != nil && imageURL.length > 1) 
    {
        IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
        iconDownloader.downloadURL = imageURL;
        iconDownloader.indexPathInTableView = index;
		iconDownloader.imageType = CUSTOMER_PHOTO;
		self.iconDownLoad = iconDownloader;
		 iconDownLoad.delegate = self;
        [iconDownLoad startDownload];
        [iconDownloader release];   
    }
}
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
	[FileManager savePhoto:weiboType withImage:iconDownLoad.cardIcon];
	
	NSArray *visible = [self.tableView indexPathsForVisibleRows];
	NSIndexPath *indexpath = (NSIndexPath*)[visible objectAtIndex:0];
	
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
	UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1001];
	imageView.image = iconDownLoad.cardIcon;
	//[self.tableView reloadData];
}

@end
