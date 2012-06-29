#import <UIKit/UIKit.h>

@protocol CustomCityViewControllerDelegate

- (void)didSelectCustomCity:(NSString *)city;

@end

@interface CustomCityViewController : UITableViewController

@property (weak) id<CustomCityViewControllerDelegate> delegate;
@property (strong) NSString *city;

@end
