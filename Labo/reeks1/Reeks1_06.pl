use Win32::OLE;

$foutobject = Win32::OLE->new("CDO.Mesage");
print "\nlast error= ",Win32::OLE->LastError() ;


