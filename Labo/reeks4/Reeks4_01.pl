use Win32::OLE::Const;

my $Locator=Win32::OLE->new("WbemScripting.SWbemLocator");

%wd = %{Win32::OLE::Const->Load($Locator)}; 

foreach (sort {$b cmp $a} keys %wd){
    printf ("%30s : %s\n",$_,$wd{$_});
}

use Win32::OLE::Const ".*WMI";      
print "\nwbemNoErr    : ",wbemNoErr;  




