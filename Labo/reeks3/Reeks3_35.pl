SELECT * FROM __InstanceModificationEvent Within 5
WHERE TargetInstance ISA 'Win32_Service'
  And PreviousInstance.Started = true
  And TargetInstance.Started   = false



