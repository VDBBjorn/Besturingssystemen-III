De WMI klasse "Win32_NetworkAdapter" stelt een netwerkverbinding voor.
    Het attribuut "NetConnectionStatus" bevat de "Status" van een netwerkverbinding. 
    Zoek in "Property Qualifiers" de betekenis op van de numerieke waarden.

Deze klasse is o.a. geassocieerd met de configuratie-klasse, met volgende informatie:
 
"Win32_NetworkAdapterConfiguration" (Index, IPAddress, DHCPEnabled, DNSServerSearchOrder, ...)
         \ Setting
          | "Win32_NetworkAdapterSetting"
         / Element
"Win32_NetworkAdapter" (DeviceID, NetConnectionID, NetConnectionStatus,AdapterType, MACAddress, ... )


De informatie uit het "Resources"-tabblad is iets gecompliceerder, omdat ze overgeerfd wordt van 
de klasse "CIM_LogicalDevice". 
Vraag eerst alle instanties van de klasse "Win32_NetworkAdapter", 
en zoek de instantie die de netverbinding ("eth0)" voorstelt.
Nu kan je voor die instantie alle geassocieerde klassen bekijken. 
Je vindt er meerdere koppelingen over de associatieklasse "Win32_AllocatedResource"
die de informatie bevat van het "Resources"-tabblad. 

Je kan ook nagaan dat de klasse "Win32_NetworkAdapter", als subklasse van "CIM_LogicalDevice",
gekoppeld is aan de klasse  "CIM_SystemResource" via de associatorklasse is "Win32_AllocatedResource".


"Win32_NetworkAdapter" (-> subklasse van "CIM_LogicalDevice")
         \ Dependent
          | "Win32_AllocatedResource"
         / Antecedent
Win32-subklassen van "CIM_SystemResource":
     "Win32_DeviceMemoryAddress" (StartingAddress, EndingAddress, Name, ....)
     "Win32_PortResource"        (StartingAddress, EndingAddress, Name, ....)
     "Win32_DMAChannel"          (DMAChannel attribuut)
     "Win32_IRQResource"         (IRQNumber attribuut)	



