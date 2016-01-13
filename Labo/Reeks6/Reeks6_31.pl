$Win32::OLE::Warn = 1; #toevoegen omdat de fout het script niet zou stopen
#Wijzig de volgende methode:

sub isset{
   my ($user,$property)=@_;
   $user->GetInfoEx([$property],0);# vraag expliciet om prop in de cache te plaatsen
   return $user->GetEx($property);# array referentie, undef indien niet ingevuld 
}

#regel (1) en (2) wijzigen:
$values=isset($user,$property);  #regel(1)

toon($user,$values);      #regel(2)

#de methode toon verandert ook

sub toon {
    my ($prop,$values)=@_;
    $prefix=$prop;
    printlijn( \$prefix, $_ ) foreach @{$values};
}





