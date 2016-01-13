use Win32::OLE;
$Win32::OLE::Warn = 3;
# of
# Win32::OLE->Option(Warn => 3);

$foutobject = Win32::OLE->new("CDO.Mesage");



