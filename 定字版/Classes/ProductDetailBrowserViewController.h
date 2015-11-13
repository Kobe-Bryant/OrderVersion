//
//  ProductDetailBrowserViewController.h
//  szeca
//
//  Created by MC374 on 12-4-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductDetailBrowserViewController : UIViewController <UIWebViewDelegate>{
	UIWebView *webView;
}

@property(nonatomic,retain)IBOutlet UIWebView *webView;

- (void) loadHtmlString:(NSString*)htmlString;
@end
