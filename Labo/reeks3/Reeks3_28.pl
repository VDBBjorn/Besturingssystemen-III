We vertrekken van het WMI-object Win32_Directory.Name="c:\\"

ASSOCIATORS OF {Win32_Directory.Name="c:\\"} 
   WHERE ResultClass=Win32_LogicalDisk
   
    -> WMI-object: Win32_LogicalDisk.DeviceID="C:"

ASSOCIATORS OF {Win32_LogicalDisk.DeviceID="C:"}
   WHERE ResultClass = Win32_DiskPartition

    -> WMI-object: Win32_DiskPartition.DeviceID="Disk #0, Partition #1"

ASSOCIATORS OF {Win32_DiskPartition.DeviceID="Disk #0, Partition #1"}
   WHERE ResultClass = Win32_DiskDrive

->bevat het attribute TotalSectors


