    use Win32::OLE;            #inladen module zonder "in" en "with" functie volstaat
    $cdo = Win32::OLE->new("CDO.Message"); #functie new correct gebruiken
    print ref $cdo;                        #controleren of het gelukt is



