use Win32::OLE::Const;
@ARGV=("punten.xls");
$fso = Win32::OLE->new("Scripting.FileSystemObject");
$naam=$ARGV[0];

if ($fso->FileExists($naam))
{
    $absoluutPad = $fso->GetAbsolutePathName($naam); 
    $file = $fso->getFile($naam); #absoluut of relatief
    print $absoluutPad, " bestaat en heeft type " , $file->{Type};

}
#absoluut pad kan je ook aan het File-object vragen:    
$absoluutPad = $file->{path};


