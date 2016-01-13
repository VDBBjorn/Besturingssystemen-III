use Win32::OLE qw(in);

my $mail = Win32::OLE->new('CDO.Message');
my $conf = Win32::OLE->new('CDO.Configuration');

#configuratie aanpassen
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver")->{Value}     = "smtp.hogent.be"; #thuis aanpassen
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport")->{Value} = 25;                  #niet noodzakelijk
$conf->Fields("http://schemas.microsoft.com/cdo/configuration/sendusing")->{Value}      = 2;

$conf->{Fields}->Update();

#bericht aanpassen
$mail->{Configuration} = $conf;
$mail->{To}            = ".....\@ugent.be";
$mail->{From}          = "....\@ugent.be";
$mail->{Subject}       = 'Test mail met attachment uit COM';
$mail->{TextBody}      = 'Zet hier een tekst naar keuze';
$mail->AddAttachment('padnaam'); #geef hier een juiste padnaam in

$mail->Send();


