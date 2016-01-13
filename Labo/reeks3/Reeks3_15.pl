Zoek op "partition" en je vindt de WMI klasse "Win32_DiskPartition". 
In het tabblad "Associations" vind je de figuur:

Hierin vind je alle antwoorden op de vraag:
"Win32_LogicalDisk"    (DeviceID, FileSystem, Size, FreeSpace, MediaType, Compressed,... )
         \ Dependent
          |  "Win32_LogicalDiskToPartition"
         / Antecedent
"Win32_DiskPartition"  (DeviceID, PrimaryPartition, StartingOffset, ... )
         \ Dependent
          | "Win32_DiskDriveToDiskPartition"
         / Antecedent
"Win32_DiskDrive"    (DeviceID, Model, InterfaceType, TotalCylinders, TracksPerCylinder, SectorsPerTrack, ... )



