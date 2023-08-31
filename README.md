# vis-backspace

A plugin to delete to the last tabstop when pressing backspace in vis.

#### Features

  - Uses `vis.options.tabwidth` for versions of vis >= 0.9. Up until
    that version no plugin could integrate with it, and required you to
    set the amount of spaces to delete by hand.
  - Automatically aligns code to the tabstops. So a line of code indented
    with 7 spaces will be left with 4 after pressing backspace.
  - Aligns even the cursor. This might not be important to you, but the
    cursor is also aligned to the first tabstop it encounters to its left.
  - When `vis.options` is available, automatically disables itself when
    `expandtab` is false.

#### Installation

Clone this repository to where you install your plugins. (If this is your
first plugin, running `git clone https://github.com/milhnl/vis-backspace`
in `~/.config/vis/` will probably work).

Then, add `require('vis-backspace')` to your `visrc`.

#### Usage

Press backspace. Loading the library with the `require` call above will
automatically bind to backspace in insert mode. If you want to use your
own logic for setting the tab width: `require('vis-backspace')` returns
a function with one argument, the number of spaces to delete. You can
bind calling this function to backspace yourself.
