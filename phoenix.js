'use strict';

/* modifier keys */
var cmd_ctrl = ['ctrl', 'cmd'];
var controlAltCommand = ['ctrl', 'alt', 'cmd'];
var controlAlt = ['ctrl', 'alt'];
var commandAlt = ['cmd', 'alt'];
var controlShift = [ 'ctrl', 'shift' ];
var controlAltShift = [ 'ctrl', 'alt', 'shift' ];
var margin = 5;
var increment = 0.01;

/* Preferences */

Phoenix.set({
  /* daemon: true, */
  openAtLogin: true
});

/* Position */

var Position = {
  central: function(frame, window) {
    return {
      x: frame.x + ((frame.width - window.width) / 2),
      y: frame.y + ((frame.height - window.height) / 2)
    };
  },

  top: function(frame, window) {
    return {
      x: window.x,
      y: frame.y
    };
  },

  bottom: function(frame, window) {
    return {
      x: window.x,
      y: (frame.y + frame.height) - window.height
    };
  },

  left: function(frame, window) {
    return {
      x: frame.x,
      y: window.y
    };
  },

  right: function(frame, window) {
    return {
      x: (frame.x + frame.width) - window.width,
      y: window.y
    };
  },

  topLeft: function(frame, window, margin) {
    return {
      x: Position.left(frame, window).x + margin,
      y: Position.top(frame, window).y + margin
    };
  },

  topRight: function(frame, window, margin) {
    return {
      x: Position.right(frame, window).x - margin,
      y: Position.top(frame, window).y + margin
    };
  },

  bottomLeft: function(frame, window, margin) {
    return {
      x: Position.left(frame, window).x + margin,
      y: Position.bottom(frame, window).y - margin
    };
  },

  bottomRight: function(frame, window, margin) {
    return {
      x: Position.right(frame, window).x - margin,
      y: Position.bottom(frame, window).y - margin
    };
  }
};

/* Grid */

var Frame = {
  width: 1,
  height: 1,
  half: {
    width: 0.5,
    height: 0.5
  }
};

/* Window Functions */

Window.prototype.to = function(position) {
  this.setTopLeft(position(this.screen().flippedVisibleFrame(), this.frame(), 0));
}

Window.prototype.grid = function(x, y, reverse) {

  var frame = this.screen().flippedVisibleFrame();

  var newWindowFrame = _(this.frame()).extend({
    width: (frame.width * x) - (2 * margin),
    height: (frame.height * y) - (2 * margin)
  });

  var position = reverse ? Position.topRight(frame, newWindowFrame, margin) :
                           Position.bottomLeft(frame, newWindowFrame, margin);

  this.setFrame(_(newWindowFrame).extend(position));
}

Window.prototype.reverseGrid = function(x, y) {
  this.grid(x, y, true);
}

Window.prototype.resize = function(multiplier) {
  var frame = this.screen().flippedVisibleFrame();
  var newSize = this.size();

  if (multiplier.x) {
    newSize.width += frame.width * multiplier.x;
  }

  if (multiplier.y) {
    newSize.height += frame.height * multiplier.y;
  }

  this.setSize(newSize);
}

Window.prototype.increaseWidth = function() {
  this.resize({ x: increment });
}

Window.prototype.decreaseWidth = function() {
  this.resize({ x: -increment });
}

Window.prototype.increaseHeight = function() {
  this.resize({ y: increment });
}

Window.prototype.decreaseHeight = function() {
  this.resize({ y: -increment });
}

Window.prototype.moveLeft = function() {
  if (this.screen() == this.screen().next())
    return;
  var oldWindow = this.frame();
  var oldScreen = this.screen().flippedVisibleFrame();
  var newScreen = this.screen().next().flippedVisibleFrame();

  this.setFrame({
    x:      newScreen.x + ((oldWindow.x - oldScreen.x) / oldScreen.width) * newScreen.width + oldScreen.width / 2,
    y:      newScreen.y + ((oldWindow.y - oldScreen.y) / oldScreen.height) * newScreen.height,
    width:  newScreen.width * (oldWindow.width / oldScreen.width),
    height: this.height * (oldWindow.height / oldScreen.height),
  });
}

Window.prototype.moveRight = function() {
  if (this.screen() == this.screen().previous())
    return;
  var oldWindow = this.frame();
  var oldScreen = this.screen().flippedVisibleFrame();
  var newScreen = this.screen().previous().flippedVisibleFrame();

  this.setFrame({
    x:      newScreen.x + ((oldWindow.x - oldScreen.x) / oldScreen.width) * newScreen.width - oldScreen.width / 2,
    y:      newScreen.y + ((oldWindow.y - oldScreen.y) / oldScreen.height) * newScreen.height,
    width:  newScreen.width * (oldWindow.width / oldScreen.width),
    height: this.height * (oldWindow.height / oldScreen.height),
  });
}

/* Position Bindings */

Key.on('f', controlAltCommand, function() {
  Window.focused() && Window.focused().maximize();
});

Key.on('l', controlAltCommand, function() {
  Window.focused() && Window.focused().moveRight();
});

Key.on('h', controlAltCommand, function() {
  Window.focused() && Window.focused().moveLeft();
});

Key.on('c', controlAltCommand, function() {
  Window.focused() && Window.focused().to(Position.central);
});

Key.on('q', controlShift, function() {
  Window.focused() && Window.focused().to(Position.topLeft);
});

Key.on('w', controlShift, function() {
  Window.focused() && Window.focused().to(Position.topRight);
});

Key.on('a', controlShift, function() {
  Window.focused() && Window.focused().to(Position.bottomLeft);
});

Key.on('s', controlShift, function() {
  Window.focused() && Window.focused().to(Position.bottomRight);
});

/* Grid Bindings */

// Key.on('o', controlShift, function() {
//   Window.focused() && Window.focused().grid(Frame.half.width, Frame.half.height);
// });

Key.on('j', controlShift, function() {
  Window.focused() && Window.focused().grid(Frame.width, Frame.half.height);
});

Key.on('h', controlShift, function() {
  Window.focused() && Window.focused().grid(Frame.half.width, Frame.height);
});

// Key.on('l', controlShift, function() {
//   Window.focused() && Window.focused().grid(Frame.width, Frame.height);
// });

/* Reverse Grid Bindings */

// Key.on('o', controlAltShift, function() {
//   Window.focused() && Window.focused().reverseGrid(Frame.half.width, Frame.half.height);
// });

Key.on('k', controlShift, function() {
  Window.focused() && Window.focused().reverseGrid(Frame.width, Frame.half.height);
});

Key.on('l', controlShift, function() {
  Window.focused() && Window.focused().reverseGrid(Frame.half.width, Frame.height);
});

// Key.on('l', controlAltShift, function() {
//   Window.focused() && Window.focused().reverseGrid(Frame.width, Frame.height);
// });

/* Resize Bindings */

Key.on('right', controlAlt, function() {
  Window.focused() && Window.focused().increaseWidth();
});

Key.on('down', controlAlt, function() {
  Window.focused() && Window.focused().increaseHeight();
});

Key.on('left', controlAlt, function() {
  Window.focused() && Window.focused().decreaseWidth();
});

Key.on('up', controlAlt, function() {
  Window.focused() && Window.focused().decreaseHeight();
});
