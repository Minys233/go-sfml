 %module "window"
 %{
 /* Includes the header in the wrapper code */
 #include <SFML/Window.h>
 %}

 /* Parse the header file to generate wrappers */

%define __APPLE__ %enddef

%rename type evType;

%include <SFML/Config.h>
%include <SFML/Window/Export.h>

%include <SFML/Window/Clipboard.h>
%include <SFML/Window/Context.h>
%include <SFML/Window/Cursor.h>
%include <SFML/Window/Event.h>
%include <SFML/Window/Joystick.h>
%include <SFML/Window/JoystickIdentification.h>
%include <SFML/Window/Keyboard.h>
%include <SFML/Window/Mouse.h>
%include <SFML/Window/Sensor.h>
%include <SFML/Window/Touch.h>
%include <SFML/Window/Types.h>
%include <SFML/Window/VideoMode.h>
%include <SFML/Window/Vulkan.h>
%include <SFML/Window/Window.h>
%include <SFML/Window/WindowBase.h>
%include <SFML/Window/WindowHandle.h>
