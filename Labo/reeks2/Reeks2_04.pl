#de foreach-lus uit vorige oefening wordt aangepast:

foreach $nsheet (in $book->{Worksheets}){
    print "\n$nsheet->{name}\n";
    $range=$nsheet->{UsedRange};
    $mat = $range->{Value};
    if (ref $mat) {   #controleren op het aantal rijen en kolommen is niet juist voor een leeg werkblad.
       print "matrix met $range->{rows}->{Count} rijen en $range->{columns}->{Count} kolommen\n";
       print join("  \t",@{$_}),"\n" foreach @{$mat};
    }
    else {
       ($mat ? print "1 inhoud : $mat\n": print "leeg werkblad\n");
    }
    print "\n-----------------------------------------\n";
}


