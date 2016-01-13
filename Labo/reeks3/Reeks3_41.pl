1) Oorzaak beschrijven :

creeer een "__EventFilter" object

    Name          -> test
    QueryLanguage -> WQL
    Query         -> SELECT * FROM __InstanceCreationEvent 
                     WITHIN 10 
                     WHERE TargetInstance ISA 'Win32_Process' 
                     AND (TargetInstance.Name = 'notepad.exe'
                     OR  TargetInstance.Name = 'calc.exe')

2) Twee reacties :
creeer een "CommandLineEventConsumer" object

    Name                -> test
    CommandLineTemplate -> C:\WINDOWS\system32\taskkill.exe /f /pid %TargetInstance.ProcessId%


creeer een "SMTPEventConsumer" object

    Name       -> test
    FromLine   -> ...@student.ugent.be
    ToLine     -> marleen.denert@ugent.be;joris.moreau@ugent.be
    Subject    -> %TargetInstance.Caption% started on %__SERVER%
    SMTPServer -> mail-out.hogent.be

3) Twee koppelingen :
creeer een "__FilterToConsumerBinding" object

    Filter   -> \\.\root\cimv2:__EventFilter.Name="test"
    Consumer -> \\.\root\cimv2:SMTPEventConsumer.Name="test"


creeer een tweede "__FilterToConsumerBinding" object

    Filter   -> \\.\root\cimv2:__EventFilter.Name="test"
    Consumer -> \\.\root\cimv2:CommandLineEventConsumer.Name="test"


MOGELIJK ALTERNATIEF met zonder interne polling (met een ExcentricEvent)

1) Oorzaak beschrijven :

creeer een "__EventFilter" object
    Name          -> test
    QueryLanguage -> WQL
    Query         -> SELECT * FROM Win32_ProcessStartTrace  
                     WHERE (processName = 'calc.exe'   OR  processName = 'Notepad.exe')
             

2) Twee reacties :
creeer een "CommandLineEventConsumer" object

    Name                -> test
    CommandLineTemplate -> C:\WINDOWS\system32\taskkill.exe /f /pid %ProcessId%


creeer een "SMTPEventConsumer" object

    Name       -> test
    FromLine   -> ...@student.ugent.be
    ToLine     -> marleen.denert@ugent.be;joris.moreau@ugent.be
    Subject    -> %ProcessName% started on %__SERVER%    #de informatie over de __SERVER zal <null> opleveren omdat dit attribuut niet wordt ingesteld in het Event_object
    SMTPServer -> mail-out.hogent.be

3) identiek
 

