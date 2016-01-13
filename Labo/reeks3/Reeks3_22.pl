Zoek de WMI-klasse met "Search for Class" waarbij je zoekt naar een klasse of attribuut dat "ping" bevat.

Merk op dat je in WMI CIM Studio geen instanties kan vragen van deze klasse. 

WQL-query:
     SELECT ResponseTime,StatusCode FROM Win32_PingStatus WHERE Address='google.com'


