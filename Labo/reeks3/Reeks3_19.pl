#alle partities
  SELECT * FROM Win32_LogicalDisk

#alle opslagelementen, geen partities - let op de ''-tekens
   SELECT * FROM CIM_StorageExtent  WHERE  __CLASS != 'Win32_LogicalDisk'


