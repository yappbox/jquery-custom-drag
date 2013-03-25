# jQuery custom-drag

Touch- and mouse-aware jQuery special events for dragging.

If touch is supported, this library translates a `mousedown` -> `mousemove` (more than 4px) -> `mouseup|mouseleave` into `customdragstart` -> `customdragmove` -> `customdragend` events.

Otherwise, the library translates a `touchstart` -> `touchmove` (more than 4px) -> `touchend|touchcancel` into `customdragstart` -> `customdragmove` -> `customdragend` events.

## Usage

In order to indicate that you want to begin a dragging operation, you need to handle the `customdragstart` event by setting a `dragTarget` on the event.

````coffeescript
$(el).on('customdragstart', (evt)->
  evt.dragTarget = this
)
````

## Using with Ember.js

This library was written to get good drag support in an Ember.js project. (Note: I'm referring to a dragging UI interaction, not actual drag/drop or files or DOM elements.)

Here's how to use it with Ember:

````coffeescript
# load this library
require 'custom_drag'

# connect the jQuery special events to Ember EventDispatcher events
window.App = Ember.Application.create
  customEvents:
    customdragstart: 'customDragStart'
    customdragmove: 'customDragMove'
    customdragend: 'customDragEnd'

# add methods to views that will get called by the EventDispatcher
App.SliderView = Ember.View.extend
  value: 0.50
  customDragStart: (evt)->
    evt.dragTarget = @get('element')

  customDragMove: (evt)->
    # Use evt.pageX or evt.pageY here with some math
    # to act on the view properties

  customDragEnd: (evt)->
    # Do something when the drag is over
````

## Author

Written by Kris Selden (@kselden) at Yapp (http://yapp.us), 2013.

## License

This script is licensed under the MIT license.
