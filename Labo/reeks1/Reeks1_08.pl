use Win32::OLE::Const "^Microsoft CDO for Windows 2000 Library";
#use Win32::OLE::Const ".*CDO"; #volstaat om de bibliotheek te vinden
print "\ncdoSendUsingPort : ",cdoSendUsingPort; #toont de waarde

use Win32::OLE::Const "^Microsoft Excel";      
#use Win32::OLE::Const ".*Excel"; #volstaat om de bibliotheek te vinden
print "\nxlHorizontaal    : ",xlHorizontal;
print "\nniet bestaand    : ",xlHorizontaal;   #geeft de naam zelf terug


