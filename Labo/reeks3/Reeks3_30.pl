Alle klassen geassocieerd aan dit object:

   ASSOCIATORS OF {Win32_Directory.Name='c:\perl\lib'}    WHERE ClassDefsOnly
OF 
   ASSOCIATORS OF {Win32_Directory.Name="c:\\perl\\lib"}  WHERE ClassDefsOnly

(a)  ASSOCIATORS OF {Win32_Directory.Name='c:\perl\lib'}  WHERE ResultClass = CIM_DataFile

(b) twee mogelijkheden:

    ASSOCIATORS OF {Win32_Directory.Name='c:\perl\lib'}  WHERE ResultClass = Win32_Directory
                                                         Role = GroupComponent

    ASSOCIATORS OF {Win32_Directory.Name='c:\perl\lib'}  WHERE ResultRole = PartComponent

(c) twee mogelijkheden:

    ASSOCIATORS OF {Win32_Directory.Name='c:\perl\lib'}
       WHERE ResultRole = GroupComponent

    ASSOCIATORS OF {Win32_Directory.Name='c:\perl\lib'}
       WHERE ResultClass = Win32_Directory
       Role = PartComponent



