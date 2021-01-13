
typedef NS_ENUM(NSInteger, mk_lb_taskOperationID) {
    mk_lb_defaultTaskOperationID,
    
#pragma mark - Read
    mk_lb_taskReadBatteryPowerOperation,       //电池电量
    mk_lb_taskReadDeviceModelOperation,        //读取产品型号
    mk_lb_taskReadFirmwareOperation,           //读取固件版本
    mk_lb_taskReadHardwareOperation,           //读取硬件类型
    mk_lb_taskReadSoftwareOperation,           //读取软件版本
    mk_lb_taskReadManufacturerOperation,       //读取厂商信息
    mk_lb_taskReadDeviceTypeOperation,         //读取产品类型
    
#pragma mark - 密码特征
    mk_lb_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 设备系统应用信息读取
    
    mk_lb_taskReadMacAddressOperation,          //读取设备mac地址
    
#pragma mark - 设备LoRa参数读取
    mk_lb_taskReadLorawanRegionOperation,       //读取LoRaWAN频段
    mk_lb_taskReadLorawanModemOperation,        //读取LoRaWAN入网类型
    mk_lb_taskReadLorawanClassTypeOperation,    //读取LoRaWAN Class类型
    mk_lb_taskReadLorawanNetworkStatusOperation,    //读取LoRaWAN网络状态
    mk_lb_taskReadLorawanDEVEUIOperation,           //读取LoRaWAN DEVEUI
    mk_lb_taskReadLorawanAPPEUIOperation,           //读取LoRaWAN APPEUI
    mk_lb_taskReadLorawanAPPKEYOperation,           //读取LoRaWAN APPKEY
    mk_lb_taskReadLorawanDEVADDROperation,          //读取LoRaWAN DEVADDR
    mk_lb_taskReadLorawanAPPSKEYOperation,          //读取LoRaWAN APPSKEY
    mk_lb_taskReadLorawanNWKSKEYOperation,          //读取LoRaWAN NWKSKEY
    mk_lb_taskReadLorawanMessageTypeOperation,      //读取上行数据类型
    mk_lb_taskReadLorawanCHOperation,               //读取LoRaWAN CH
    mk_lb_taskReadLorawanDROperation,               //读取LoRaWAN DR
    mk_lb_taskReadLorawanADROperation,              //读取LoRaWAN ADR
    mk_lb_taskReadLorawanMulticastStatusOperation,  //读取LoRaWAN组播开关
    mk_lb_taskReadLorawanMulticastAddressOperation, //读取LoRaWAN组播地址
    mk_lb_taskReadLorawanMulticastAPPSKEYOperation, //读取LoRaWAN组播APPSKEY
    mk_lb_taskReadLorawanMulticastNWKSKEYOperation, //读取LoRaWAN组播NWKSKEY
    mk_lb_taskReadLorawanLinkcheckIntervalOperation,    //读取linkcheck检测间隔
    mk_lb_taskReadLorawanUplinkdwelltimeOperation,      //读取Uplinkdwelltime
    mk_lb_taskReadLorawanDutyCycleStatusOperation,      //读取dutycyle
    mk_lb_taskReadLorawanDevTimeSyncIntervalOperation,  //读取devtime指令同步间隔
    
    mk_lb_taskConfigPasswordOperation,          //设置密码
    
};
