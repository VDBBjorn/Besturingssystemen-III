use Win32::OLE;



my $ADOconnection = Win32::OLE->CreateObject("ADODB.Connection");

   $ADOconnection->{Provider} = "ADsDSOObject";

   $ADOconnection->{Properties}->{"User ID"}          = ". . ."; # vul in of zet in commentaar op school

   $ADOconnection->{Properties}->{"Password"}         = ". . ."; # vul in of zet in commentaar op school

   $ADOconnection->{Properties}->{"Encrypt Password"} = True;

   $ADOconnection->Open();                                       # mag je niet vergeten

my $ADOcommand = Win32::OLE->CreateObject("ADODB.Command");

   $ADOcommand->{ActiveConnection}      = $ADOconnection;        # verwijst naar het voorgaand object

   $ADOcommand->{Properties}->{"Page Size"} = 20;



Win32::OLE->LastError()&& die (Win32::OLE->LastError());



#In powerShell

   $ADOconnection = New-Object -ComObject "ADODB.Connection";

   $ADOconnection.Provider = "ADsDSOObject";

#Onderstaande items vind je terug met als je de inhoud vraagt van    $ADOconnection.Provider (enkel Encrypt Password ontbreekt, maar is toch bruikbaar...)

   $ADOconnection.Properties.Item("User ID").Value="...";  # vul in of zet in commentaar op school

   $ADOconnection.Properties.Item("PassWord").Value="..."; # vul in of zet in commentaar op school

   $ADOconnection.Properties.Item("Encrypt Password").Value=1;

   $ADOconnection.Open();                                   # mag je niet vergeten



   $ADOcommand = New-Object -ComObject "ADODB.Command"

   $ADOcommand.ActiveConnection      = $ADOconnection;         

   $ADOcommand.Properties.Item("Page Size").value = 20;




