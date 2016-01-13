#Met interne polling - zonder extrinsic event:

SELECT * FROM __InstanceOperationEvent Within 10
WHERE TargetInstance ISA 'Win32_Process'
  And TargetInstance.Name = 'notepad.exe'
  And (__CLASS = '__InstanceCreationEvent'
   Or __CLASS = '__InstanceDeletionEvent')



