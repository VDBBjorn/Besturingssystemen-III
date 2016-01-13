use Win32::OLE qw(in);
use Win32::OLE::Const;

$mail = Win32::OLE->new("CDO.Message");
$mail->{TextBody} = 'Hallo uit perlScript';
$mail->{Subject}  = 'COM' ;
$mail->{From}     = '...@ugent.be' ;
$mail->{To}       = '...@ugent.be';      #vul aan met je eigen mailadres
$conf=Win32::OLE->new("CDO.Configuration");
$wd  =Win32::OLE::Const->Load($conf);

#instellen van de SPTMserver
#volledige notatie
$conf->{Fields}->Item($wd->{cdoSMTPServer})->{value} ="smtp.hogent.be"     ; #thuis aanpassen

#instellen van de poort 
#Item is weggelaten
$conf->Fields($wd->{cdoSendUsingMethod})->{value} = $wd->{cdoSendUsingPort};

#instellen van timeout - niet noodzakelijk
#superkorte notatie 
#$conf->{$wd->{cdoSMTPConnectionTimeout}}=25;

#aanpassingen doorvoeren
$conf->{Fields}->Update();      #is noodzakelijk

$mail->{Configuration}=$conf;  #moet ingevuld worden
$mail->Send();


