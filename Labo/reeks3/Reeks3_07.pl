Singleton-klassen:
    Win32_WMISetting      -> __RELPATH: Win32_WMISetting=@
    Win32_LocalTime       -> __RELPATH: Win32_LocalTime=@
    Win32_OperatingSystem -> __RELPATH: Win32_OperatingSystem=@

    Win32_CurrentTime is eigenlijk een abstacte klasse zonder sleutelattribuut, bovendien zijn alle afgeleide klassen singleton-klassen.
In de volgende oefening zullen we zien dat ook deze abstracte klasse al een singleton klasse is. 

Geen singleton-klassen
  CIM_LogicalDevice is abstracte klasse zonder sleutelattribuut, maar ze bevat afgeleide klassen die wel een sleutel hebben. 
  Het kan dus zelf geen singleton klasse zijn (zie volgende oefening) 

  Win32_ComputerSystem heeft maar 1 instantie, maar is geen singletonklasse. Ze heeft het sleutelattribuut "Name".
  Het __RELPATH van de uniek instantie bevat dan ook de waarde voor dit sleutelattribuut.



