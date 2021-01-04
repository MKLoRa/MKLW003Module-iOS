
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
    
    
    mk_lb_taskConfigPasswordOperation,          //设置密码
    
};
