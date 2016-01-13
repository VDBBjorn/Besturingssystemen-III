#Geef als argument bijvoorbeeld "Microsoft CDO for Windows 2000 Library"
use Win32::OLE::Const;

$bibnaam=$ARGV[0];

$wd = Win32::OLE::Const->Load($bibnaam);
while ( ( $key, $value ) = each %{$wd} ) {
    print "$key :$value\n";
}


