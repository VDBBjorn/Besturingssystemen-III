#voeg toe in vorige oplossin

foreach $nsheet (in $book->{Worksheets}){
    $range=$nsheet->{UsedRange};
    printf "\n\t%-30s heeft %3d kolommen en %3d rijen\n",$nsheet->{name},$range->{columns}->{count},$range->{rows}->{count} ;
}

