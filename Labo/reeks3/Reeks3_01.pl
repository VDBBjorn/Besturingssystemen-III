1. WMI CIM Studio opstarten via snelkoppeling of Start / Programs /...

2. WMI CIM Studio opstarten (mag in eigen gebruikerscontext). 
     * In het "Connect to namespace" venster de "Browse For Namespace" knop indrukken, 
       machinenaam of ip-adres intikken VAN EEN ANDERE COMPUTER na dubbele backslashes, 
       en vervolgens de "Connect" knop indrukken. 
     * De optie "Login as current user" uitvinken, en als usernaam ingeven
          "computernaam\administrator" en het juiste paswoord intikken, en dan pas op OK drukken.

3. Op je eigen toestel kan je enkel connecteren met je eigen credentials. 
   Start dus eerst een "Command Prompt" op in de gebruikerscontext van de lokale administrator: 
               
         runas /user:computernaam\administrator cmd.exe

   alle programma's en scripts die je vanuit een dergelijke command prompt opstart, 
   worden uitgevoerd in de gebruikerscontext van de lokale administrator.

   om WMI CIM Studio op te starten geef je als opdracht (inclusief aanhalingstekens): 
              "\Program Files\WMI Tools\studio.htm"



