Twee oplossingen:

  SELECT * FROM __InstanceCreationEvent Within 10
  WHERE TargetInstance ISA 'CIM_DirectoryContainsFile'
      And TargetInstance.GroupComponent = "Win32_Directory.Name='c:\\temp'" #let op het gebruik van "" en '' 

Alternatief: een bestand staat in een bepaalde map als de drive en het pad overeenkomen met de directory:

  SELECT * FROM __InstanceCreationEvent Within 10
  WHERE TargetInstance ISA 'CIM_DataFile'
      And TargetInstance.Drive = 'c:'
      And TargetInstance.Path = '\\temp'

Lukt ook met:
  SELECT * FROM __InstanceCreationEvent Within 10
  WHERE TargetInstance ISA 'CIM_DataFile'
      And TargetInstance.Drive = "c:"
      And TargetInstance.Path = "\\temp"



