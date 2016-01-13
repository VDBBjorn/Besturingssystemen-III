    ASSOCIATORS OF {Win32_Directory.Name="c:\\"}   #het relatief objectpad dat je in CIM Studio terugvindt

Let op, je MOET "" gebruiken dus onderstaande WQL-query resulteert in een foutmelding:
    ASSOCIATORS OF {Win32_Directory.Name='c:\\'}

Lukt wel:
    ASSOCIATORS OF {Win32_Directory.Name='c:\'}



