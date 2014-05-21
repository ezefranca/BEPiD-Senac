//
//  ViewController.m
//  WebView
//
//  Created by Özcan Akbulut on 01.11.13.
//  Copyright (c) 2013 Özcan Akbulut. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize webView, blockLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [webView loadRequest: [NSURLRequest requestWithURL:
                           [NSURL URLWithString:@"http://bepid-senac.github.io"]]];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"bepid-senac.github.io"];
    UIImageView *RbackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-reachability"]];
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            blockLabel.textColor = [UIColor greenColor];
            blockLabel.text = @"Online";
            [RbackgroundView removeFromSuperview];
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            blockLabel.textColor = [UIColor redColor];
            blockLabel.text = @"OFFline";
            
            [self.webView addSubview:RbackgroundView];
            [self.webView bringSubviewToFront:RbackgroundView];
            [self popUp];
        });
    };
    
    [reach startNotifier];
    
}


- (void) webViewDidStartLoad:(UIWebView *)webView {
    [self.loadingSign startAnimating];
    self.loadingSign.hidden = NO;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self.loadingSign stopAnimating];
    self.loadingSign.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest
 navigationType:(UIWebViewNavigationType)inType
{
    if ( inType == UIWebViewNavigationTypeLinkClicked )
    {
        NSString* url = inRequest.URL.absoluteString;
        //NSLog(@"%@", url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

    }
    
    return YES;
}

-(void)popUp{
   self.alertView = [[FUIAlertView alloc] initWithTitle:@"Sem Conexão com a Internet" message:@"Verifique sua conexão com a Internet e tente novamente" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //    alertView.alertViewStyle = FUIAlertViewStylePlainTextInput;
    //    [@[[alertView textFieldAtIndex:0], [alertView textFieldAtIndex:1]] enumerateObjectsUsingBlock:^(FUITextField *textField, NSUInteger idx, BOOL *stop) {
    //        [textField setTextFieldColor:[UIColor cloudsColor]];
    //        [textField setBorderColor:[UIColor asbestosColor]];
    //        [textField setCornerRadius:4];
    //        [textField setFont:[UIFont flatFontOfSize:14]];
    //        [textField setTextColor:[UIColor midnightBlueColor]];
    //    }];
    //    [[alertView textFieldAtIndex:0] setPlaceholder:@"Text here!"];
    
    self.alertView.delegate = self;
    self.alertView.titleLabel.textColor = [UIColor cloudsColor];
    self.alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    self.alertView.messageLabel.textColor = [UIColor cloudsColor];
    self.alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    self.alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    self.alertView.alertContainer.backgroundColor = RGB(51, 99, 172);
    self.alertView.defaultButtonColor = [UIColor cloudsColor];
    self.alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    self.alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    self.alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [self.alertView show];
}

@end
