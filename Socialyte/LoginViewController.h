//
//  LoginViewController.h
//  Socialyte
//
//  Created by Brandon Smith on 6/23/13.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)loginButtonTouchHandler:(id)sender;

@end
