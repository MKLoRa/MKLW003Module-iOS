# LW003 iOS Software Development Kit Guide

* This SDK only support devices based on LW003.

# Design instructions

* We divide the communications between SDK and devices into two stages: Scanning stage, Connection stage.For ease of understanding, let’s take a look at the related classes and the relationships between them.

`MKLBCentralManager`：global manager, check system’s bluetooth status, listen status changes, the most important is scan and connect to devices;

`MKLBInterface`: When the device is successfully connected, the device data can be read through the interface in`MKLBInterface`;

`MKLBInterface+MKLBConfig`: When the device is successfully connected, you can configure the device data through the interface in`MKLBInterface+MKLBConfig.h`;


## Scanning Stage

in this stage, `MKLBCentralManager ` will scan and analyze the advertisement data of LW003 devices.


## Connection Stage

Developer needs to enter the connection password and call `connectPeripheral:password:sucBlock:failedBlock:`to connect.


# Get Started

### Development environment:

* Xcode9+， due to the DFU and Zip Framework based on Swift4.0, so please use Xcode9 or high version to develop;
* iOS12, we limit the minimum iOS system version to 12.0；

### Import to Project

CocoaPods

SDK-LB is available through CocoaPods.To install it, simply add the following line to your Podfile, and then import <MKLoRaWAN-B/MKLBSDK.h>:

**pod 'MKLoRaWAN-B/SDK'**


* <font color=#FF0000 face="黑体">!!!on iOS 10 and above, Apple add authority control of bluetooth, you need add the string to “info.plist” file of your project: Privacy - Bluetooth Peripheral Usage Description - “your description”. as the screenshot below.</font>

* <font color=#FF0000 face="黑体">!!! In iOS13 and above, Apple added permission restrictions on Bluetooth APi. You need to add a string to the project’s info.plist file: Privacy-Bluetooth Always Usage Description-“Your usage description”.</font>


## Start Developing

### Get sharedInstance of Manager

First of all, the developer should get the sharedInstance of Manager:

```
MKLBCentralManager *manager = [MKLBCentralManager shared];
```

#### 1.Start scanning task to find devices around you,please follow the steps below:

* 1.Set the scan delegate and complete the related delegate methods.

```
manager.delegate = self;
```

* 2.you can start the scanning task in this way:

```
[manager startScan];
```

* 3.at the sometime, you can stop the scanning task in this way:

```
[manager stopScan];
```

#### 2.Connect to device

The `MKLBCentralManager ` contains the method of connecting the device.

```
/// Connect device function
/// @param trackerModel Model
/// @param password Device connection password,8 characters long ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
```

#### 3.Get State

Through the manager, you can get the current Bluetooth status of the mobile phone, and the connection status of the device. If you want to monitor the changes of these two states, you can register the following notifications to achieve:

* When the Bluetooth status of the mobile phone changes，<font color=#FF0000 face="黑体">`mk_lb_centralManagerStateChangedNotification`</font> will be posted.You can get status in this way:

```
[[MKLBCentralManager shared] centralStatus];
```

* When the device connection status changes， <font color=#FF0000 face="黑体"> `mk_lb_peripheralConnectStateChangedNotification` </font> will be posted.You can get the status in this way:

```
[MKLBCentralManager shared].connectState;
```


#### 4.Monitor the scan data of the device.

When the device is connected, the developer can monitor the scan data of the device through the following steps:

*  1.Open data monitoring by the following method:

```
[[MKLBCentralManager shared] notifyStorageDataData:YES];
```


*  2.Set the delegate and complete the related delegate methods.

```

[MKLBCentralManager shared].dataDelegate = self;

```


```
#pragma mark - mk_lb_storageDataDelegate
- (void)mk_lb_receiveStorageData:(NSString *)content {
    NSInteger number = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(8, 2)];
    if (number == 0) {
        //The last piece of data, you can get the total number of pieces of data stored.
        NSString  *sum = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 4)];
        return;
    }
    /*
    The maximum length of content is 182 bytes.
    */
    //Content can call the following method "parseScannerTrackedData:" for parsing
}
```

```

+ (NSArray *)parseScannerTrackedData:(NSString *)content {
        
    content = [content substringFromIndex:10];
    
    NSInteger index = 0;
    NSMutableArray *dataList = [NSMutableArray array];
    for (NSInteger i = 0; i < content.length; i ++) {
        if (index >= content.length) {
            break;
        }
        NSInteger subLen = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(index, 2)];
        index += 2;
        NSString *subContent = [content substringWithRange:NSMakeRange(index, subLen * 2)];
        NSDictionary *dateDic = [self parseDateString:[subContent substringWithRange:NSMakeRange(0, 14)]];
        NSString *tempMac = [[subContent substringWithRange:NSMakeRange(14, 12)] uppercaseString];
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
                                [tempMac substringWithRange:NSMakeRange(10, 2)],
                                [tempMac substringWithRange:NSMakeRange(8, 2)],
                                [tempMac substringWithRange:NSMakeRange(6, 2)],
                                [tempMac substringWithRange:NSMakeRange(4, 2)],
                                [tempMac substringWithRange:NSMakeRange(2, 2)],
                                [tempMac substringWithRange:NSMakeRange(0, 2)]];
        NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:[subContent substringWithRange:NSMakeRange(26, 2)]];
        NSString *rawData = [subContent substringFromIndex:28];
        index += subLen * 2;
        NSDictionary *dic = @{
            @"dateDic":dateDic,
            @"macAddress":macAddress,
            @"rssi":rssi,
            @"rawData":rawData,
        };
        [dataList addObject:dic];
    }
    return dataList;
}

+ (NSDictionary *)parseDateString:(NSString *)date {
    NSString *year = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(0, 4)];
    NSString *month = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(4, 2)];
    if (month.length == 1) {
        month = [@"0" stringByAppendingString:month];
    }
    NSString *day = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(6, 2)];
    if (day.length == 1) {
        day = [@"0" stringByAppendingString:day];
    }
    NSString *hour = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(8, 2)];
    if (hour.length == 1) {
        hour = [@"0" stringByAppendingString:hour];
    }
    NSString *min = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(10, 2)];
    if (min.length == 1) {
        min = [@"0" stringByAppendingString:min];
    }
    NSString *second = [MKBLEBaseSDKAdopter getDecimalStringWithHex:date range:NSMakeRange(12, 2)];
    if (second.length == 1) {
        second = [@"0" stringByAppendingString:second];
    }
    return @{
        @"year":year,
        @"month":month,
        @"day":day,
        @"hour":hour,
        @"minute":min,
        @"second":second,
    };
}

```


#### 5.Monitoring device disconnect reason.

Register for <font color=#FF0000 face="黑体"> `mk_lb_deviceDisconnectTypeNotification` </font> notifications to monitor data.


```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:@"mk_lb_deviceDisconnectTypeNotification"
                                               object:nil];

```

```
- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    /*
    After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x02, the device has no data communication for two consecutive minutes, it returns 0x03, and the shutdown protocol is sent to make the device shut down and return 0x04.
    */
}
```


# Change log

* 20210316 fix parser method;

* 20210316 first version;
