use Win32::OLE;

$cdo = Win32::OLE->new("CDO.Message");
printf "CDO.Message: %s  -- %s\n", ref($cdo),join(" / ",Win32::OLE->QueryObjectType($cdo));

$fso = Win32::OLE->new("Scripting.FileSystemObject");
printf "Scripting.FileSystemObject:  %s  -- %s\n", ref($fso),join(" / ",Win32::OLE->QueryObjectType($fso));

$excel = Win32::OLE->new("Excel.Sheet");
printf "Excel.Sheet:  %s  -- %s\n", ref($excel),join(" / ",Win32::OLE->QueryObjectType($excel));


