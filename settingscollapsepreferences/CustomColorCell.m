#import "CustomColorCell.h"

@implementation CustomColorCell

- (void)updateCellDisplay {
    [super updateCellDisplay];
    
    NSUserDefaults *defaults = [[[NSUserDefaults alloc] initWithSuiteName:@"com.shiftcmdk.settingscollapsepreferences"] autorelease];

    NSString *key = [[[self.specifier properties] objectForKey:@"libcolorpicker"] objectForKey:@"key"];
    NSString *preview = [UIColor hexFromColor:[self previewColor]];
    NSString *value = [NSString stringWithFormat:@"%@:1.000000", preview];
    
    [defaults setObject:value forKey:key];
}

@end