use Win32::OLE qw (in);
$fso = Win32::OLE->new("Scripting.FileSystemObject");
$folder = $fso->getFolder(".");
print $folder->{path};
for $file (in $folder->Files)
{
     printf "\n%s",$file->{name} if ($file->{Type} =~/Excel/);
}


