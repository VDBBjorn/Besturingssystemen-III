use Win32::OLE qw(in);
use Win32::OLE::Const;

$conf=Win32::OLE->new("CDO.Configuration");
$wd  =Win32::OLE::Const->Load($conf);

$sendMethode = $wd->{cdoSendUsingMethod}; 
$sendPort    = $wd->{cdoSendUsingPort};
$smtpServer  = $wd->{cdoSMTPServer};
$conf->Fields($sendMethode)->{value} = $sendPort;
$conf->Fields($smtpServer)->{value}  = "smtp.hogent.be"; 

foreach (in $conf->{Fields}){
   print "\n\nName  : ",$_->{Name};
   print "\n\tValue : ",$_->{Value};
}


