use Net::SMTP;

$smtp = Net::SMTP->new('smtp.hogent.be');   #stel thuis de correcte smtp-server in 
$smtp->mail('    @ugent.be');
$smtp->to('    @ugent.be');

$smtp->data();
$smtp->datasend("Subject: testje met smtp\n");
$smtp->datasend("test\n");
$smtp->dataend();
$smtp->quit;


