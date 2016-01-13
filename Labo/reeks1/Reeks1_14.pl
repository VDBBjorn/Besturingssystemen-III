use Win32::OLE;
$mail = Win32::OLE->new("CDO.Message");
$mail->{TextBody} = 'Hallo';
$mail->{Subject}  = 'COM' ;
$mail->{From}     = '...@ugent.be';   #vul correct aan
$mail->{To}       = '...@ugent.be';   #vul correct aan


