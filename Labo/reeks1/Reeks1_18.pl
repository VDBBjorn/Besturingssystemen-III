use Win32::OLE::Const;
$conf =  Win32::OLE->new("CDO.Configuration");

%wd = %{Win32::OLE::Const->Load($conf)}; #als hash opslaan

foreach (sort {$b cmp $a} keys %wd){
    printf ("%30s : %s\n",$_,$wd{$_}) if ($_=~/SendUsing/ ||$_=~/SMTPServer/);;
} 



