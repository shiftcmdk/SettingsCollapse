#import <Preferences/PSListController.h>

@interface PSListController ()

-(void)clearCache;
-(void)reload;

@end

@interface SCOLRootListController : PSListController

-(void)defaultTextColor;
-(void)defaultBackgroundColor;

@end
