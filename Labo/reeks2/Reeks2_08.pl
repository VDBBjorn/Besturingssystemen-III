use Win32::OLE::Const ".*Excel";
use Win32::OLE qw(in);

my $excelAppl = Win32::OLE->GetActiveObject('Excel.Application')
    || Win32::OLE->new('Excel.Application', 'Quit');

$excelAppl->{DisplayAlerts}=0;

my $fso = Win32::OLE->new("Scripting.FileSystemObject");
$padnaam1=$fso->GetAbsolutePathName("punten.xls");
$padnaam2=$fso->GetAbsolutePathName("punten2.xls");

$book=$excelAppl->{Workbooks}->Open($padnaam1);

ref $book or die "bestand $padnaam kan niet geopend worden met excel\n";

$sheet=$book->WorkSheets("punten");
$k1Mat=$sheet->{UsedRange}->{value};
$ns=$sheet->{UsedRange}->{Rows}->{Count};
$range=$sheet->Range("A1:D".$ns);
$mat=$range->{value};
for ($i=0;$i<=$ns;$i++){
     $naam=$k1Mat->[$i][0];
     $lijst{$naam}=$i;
}

$book2=$excelAppl->{Workbooks}->Open($padnaam2);
$sheet2=$book2->WorkSheets("punten");
$k2Mat=$sheet2->{UsedRange}->{value};
$book2->Close();
for ($i=0;$i<=$ns;$i++){
     $naam=$k2Mat->[$i][0];
     $rij=$lijst{$naam};
     $mat->[$rij][2]=$k2Mat->[$i][1];
     $mat->[$rij][3]=int(0.5+($mat->[$rij][1]+$mat->[$rij][2])/2);
}

$range->{Value}=$mat;
$range->{Columns}->Autofit();

$nsheet=$book->{WorkSheets}->Add();
$nsheet->{Name}="ad valvas";


$cr=1;
$nk=5;
advalvas ("A",12 ,20  );
advalvas ("B",10 , 11.5);
advalvas ("C",7.5, 9.5);
advalvas ("D",0 , 7  );
$nsheet->{Columns}->Autofit();

$book->Save();
$book->Close();

sub advalvas {
   my ($header,$min,$max)=@_;
# array met alle studenten in de opgegeven range
   my @studenten = map {$_->[0]} grep {$_->[3]>=$min && $_->[3]<=$max} @{$mat};

   $nr=int($#studenten/$nk)+1;
   $range=$nsheet->Range($nsheet->Cells($cr,1),$nsheet->Cells($cr+$nr,$nk));
   $cr=$cr+$nr+2;                                      #voor volgende range
   $res=$range->{Value};
   $res->[0][2]=$header;
   $i=1;$j=0;
   foreach (@studenten){
        $res->[$i][$j]=$_;
        $i++;
        if ($i>$nr-($j>$#studenten%$nk)){$i=1;$j++}   # enkel lege cellen in laatste rij
#       if ($i>$nr)                     {$i=1;$j++}   # enkel lege cellen in laatste kolom
   }

   $range->{Value}=$res;
   $range->rows(1)->{Font}->{bold}=1;
   $range->cells(1,3)->{HorizontalAlignment}=xlHAlignCenter;

   $range->Borders(xlEdgeTop)->{LineStyle} = xlContinuous;
   $range->Borders(xlEdgeBottom)->{LineStyle} = xlContinuous;
   $range->Borders(xlEdgeRight)->{LineStyle} = xlContinuous;
   $range->Borders(xlEdgeLeft)->{LineStyle} = xlContinuous;
}
#Alternatieve oplossing voor de functie
sub advalvas {
   my ($header,$min,$max)=@_;

   $nb=0;
   for my $rij (@{$mat}) {
        $punt=$rij->[3];
        $nb++ if $punt>=$min && $punt<$max;
   }

   $nr=int (($nb-1) /$nk)+1;
   $rangezone="A".$cr.":".chr(65-1+$nk).($cr+$nr);
   $cr=$cr+$nr+2; #voor volgende range
   $range=$nsheet->Range($rangezone);
   $res=$range->{Value};
   $res->[0][2]=$header;
   $i=1;$j=0;
   for my $rij (@{$mat}) {
        $punt=$rij->[3];
        if ($punt>=$min && $punt<$max){
           $res->[$i][$j]=$rij->[0]; # naam staat in kolom 0
           $j++;
           if ($j==$nk){$j=0;$i++;}
        }
   }

   $range->{Value}=$res;
   $range->rows(1)->{Font}->{bold}=1;
   $range->cells(1,3)->{HorizontalAlignment}=xlHAlignCenter;

   $range->Borders(xlEdgeTop)->{LineStyle} = xlContinuous;
   $range->Borders(xlEdgeBottom)->{LineStyle} = xlContinuous;
   $range->Borders(xlEdgeRight)->{LineStyle} = xlContinuous;
   $range->Borders(xlEdgeLeft)->{LineStyle} = xlContinuous;
}


