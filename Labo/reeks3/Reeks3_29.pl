SELECT DeviceID,MACAddress FROM Win32_NetworkAdapter          
   WHERE NetConnectionID="eth0"                               //MAC-adres

ASSOCIATORS OF {Win32_NetworkAdapter.DeviceID="9"}
   WHERE ResultClass = Win32_NetworkAdapterConfiguration      //IP-adres

ASSOCIATORS OF {Win32_NetworkAdapter.DeviceID="9"}       
   WHERE ResultClass = Win32_IRQResource                      //interruptnumber 




