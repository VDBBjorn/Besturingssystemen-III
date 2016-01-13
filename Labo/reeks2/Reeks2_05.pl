#zie hiervoor om $book te initialiseren.

$nsheet=$book->{Worksheets}->Item(1);
$range=$nsheet->Range("A1:D10");
$mat = $range->{Value};
print "Inhoud van Range(A1:D10)\n";
print join("  \t",@{$_}),"\n" foreach @{$mat};
print "-----------------\n";
$range=$nsheet->Cells(4,1);
$waarde = $range->{Value};  #maar 1 getal
print "Inhoud van Cells(4,1)=",$waarde,"\n";
print "-----------------\n";
$range=$nsheet->Range($nsheet->Cells(1,1),$nsheet->Cells(4,3));
$mat = $range->{Value};
print "Inhoud van Range(Cells(1,1),Cells(4,3))\n";
print join("  \t",@{$_}),"\n" foreach @{$mat};


