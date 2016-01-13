SELECT * FROM __InstanceCreationEvent WITHIN 5
WHERE TargetInstance.GroupComponent = "Win32_Directory.Name='c:\\temp'"
  And (TargetInstance ISA 'CIM_DirectoryContainsFile'
   or TargetInstance ISA 'Win32_SubDirectory')
GROUP BY TargetInstance.__CLASS WITHIN 60 



