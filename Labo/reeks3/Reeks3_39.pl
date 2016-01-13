Gebruik het  "__IntervalTimerInstruction" object van oefening 30, met TimerId='test'.

1) Oorzaak event koppelen aan voorgaand object : "__EventFilter" object

    Name          -> test
    QueryLanguage -> WQL
    Query         -> SELECT * FROM __TimerEvent WHERE TimerID = 'test'

2) Reacties : creeer een "CommandLineEventConsumer" object

    Name                -> test
    CommandLineTemplate -> C:\WINDOWS\system32\net.exe start snmp

3) Koppeling : creeer een "__FilterToConsumerBinding" object

    Filter   -> //./root/cimv2:__EventFilter.Name="test"
    Consumer -> //./root/cimv2:CommandLineEventConsumer.Name="test"




