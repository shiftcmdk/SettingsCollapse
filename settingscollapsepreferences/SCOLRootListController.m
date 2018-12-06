#include "SCOLRootListController.h"
#import "CustomColorCell.h"

@implementation SCOLRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
    [self clearCache];
    [self reload];  
    
	[super viewWillAppear:animated];
}

-(void)defaultTextColor {
	UITableView *tableView = [self valueForKey:@"_table"];

	NSString *path = @"/var/mobile/Library/Preferences/com.shiftcmdk.settingscollapsepreferences.plist";

	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByExpandingTildeInPath]];

	[dict setObject:@"" forKey:@"textColor"];

	[dict writeToFile:path atomically:YES];

	NSUserDefaults *defaults = [[[NSUserDefaults alloc] initWithSuiteName:@"com.shiftcmdk.settingscollapsepreferences"] autorelease];

	[defaults setObject:@"" forKey:@"textColor"];

	for (UITableViewCell *cell in tableView.visibleCells) {
		if ([cell isKindOfClass:[PFLiteColorCell class]]) {
			[(PFLiteColorCell *)cell updateCellDisplay];
		}
	}
}

-(void)defaultBackgroundColor {
	UITableView *tableView = [self valueForKey:@"_table"];

	NSString *path = @"/var/mobile/Library/Preferences/com.shiftcmdk.settingscollapsepreferences.plist";

	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByExpandingTildeInPath]];

	[dict setObject:@"" forKey:@"backgroundColor"];

	[dict writeToFile:path atomically:YES];

	NSUserDefaults *defaults = [[[NSUserDefaults alloc] initWithSuiteName:@"com.shiftcmdk.settingscollapsepreferences"] autorelease];

	[defaults setObject:@"" forKey:@"backgroundColor"];

	for (UITableViewCell *cell in tableView.visibleCells) {
		if ([cell isKindOfClass:[PFLiteColorCell class]]) {
			[(PFLiteColorCell *)cell updateCellDisplay];
		}
	}
}

@end
