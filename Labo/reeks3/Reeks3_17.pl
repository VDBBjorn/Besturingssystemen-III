Win32_LogicalDisk.DeviceID="C:"
         \ GroupComponent
          | Win32_LogicalDiskRootDirectory
         / PartComponent
Win32_Directory.Name="c:\\"
         \ GroupComponent
          | Win32_SubDirectory (recursief !)
         / PartComponent
Win32_Directory.Name="c:\\perl"
         \ GroupComponent
          | Win32_SubDirectory (recursief !)
         / PartComponent
Win32_Directory.Name="c:\\perl\\bin"
         \ GroupComponent
          | CIM_DirectoryContainsFile
         / PartComponent
CIM_DataFile.Name="c:\\perl\\bin\\perl.exe"
         \ Element
          | Win32_SecuritySettingOfLogicalFile
         / Setting
Win32_LogicalFileSecuritySetting.Path="c:\\perl\\bin\\perl.exe"
         \ SecuritySetting
          | Win32_LogicalFileOwner 
         / Owner
Win32_SID.SID="S-1-5-32-544"
         \ Setting
          | Win32_AccountSID 
         / Element
Win32_Group.Domain="computernaam",Name="Administrators"



