 %module "system"
 %{
 /* Includes the header in the wrapper code */
 #include <SFML/System.h>
 %}

 /* Parse the header file to generate wrappers */

%define __APPLE__ %enddef

%include <SFML/Config.h>
%include <SFML/System/Export.h>

%include <SFML/System/Buffer.h>
%include <SFML/System/Clock.h>
%include <SFML/System/InputStream.h>
%include <SFML/System/Mutex.h>
%include <SFML/System/Sleep.h>
%include <SFML/System/Thread.h>
%include <SFML/System/Time.h>
%include <SFML/System/Types.h>
%include <SFML/System/Vector2.h>
%include <SFML/System/Vector3.h>

%include <SFML/System/Alloc.h>

