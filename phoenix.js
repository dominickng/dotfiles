/* fixed size stack for undo/redo methods
 * code inspired by http://www.bennadel.com/blog/2308-creating-a-fixed-length-queue-in-javascript-using-arrays.htm
 *  */
function FixedSizeStack(size, init) {
  init = (init || []);
  var stack = Array.apply(null, init);
  stack.maxsize = size;
  stack.push = FixedSizeStack.push;
  stack.splice = FixedSizeStack.splice;
  stack.unshift = FixedSizeStack.unshift;

  FixedSizeStack.trimTail.call(stack);
  return stack;
}

/* cut the stack to the right size by removing
 * elements from the start */
FixedSizeStack.trimHead = function() {
  var diff = this.length - this.maxsize;
  if (diff > 0) {
    Array.prototype.splice.call(this, 0, diff);
  }
}

/* cut the stack to the right size by removing
 * elements from the end */
FixedSizeStack.trimTail = function() {
  var diff = this.length - this.maxsize;
  if (diff > 0) {
    Array.prototype.splice.call(this, this.maxsize, diff);
  }
}

/* wrap the methods growing the stack with the trim methods */
FixedSizeStack.wrapMethod = function(methodName, trimMethod) {
  var wrapper = function() {
    var method = Array.prototype[methodName];
    var result = method.apply(this, arguments);
    trimMethod.call(this);
    return result;
  }
  return wrapper;
}

FixedSizeStack.push = FixedSizeStack.wrapMethod("push", FixedSizeStack.trimHead);
FixedSizeStack.splice = FixedSizeStack.wrapMethod("splice", FixedSizeStack.trimTail);
FixedSizeStack.unshift = FixedSizeStack.wrapMethod("unshift", FixedSizeStack.trimTail);

/* modifier keys */
var cmd_ctrl = ["ctrl", "cmd"];
var cmd_alt_ctrl = ["ctrl", "alt", "cmd"];
var cmd_alt = ["cmd", "alt"];
var border = 2;
var undoPositions = FixedSizeStack(15);
var redoPositions = FixedSizeStack(15);

/* remember the current position of the current window,
 * storing it on the specified stack */
function remember(win, stack) {
  var wframe = win.frame();
  stack.push({
    win: win,
    x: wframe.x,
    y: wframe.y,
    width: wframe.width,
    height: wframe.height
  });
}

/* set a new position for a window, remembering its current position
 * for undo later on */
function setFrameAndRemember(win, dimensions) {
  remember(win, undoPositions);
  win.setFrame({
    x: dimensions.x,
    y: dimensions.y,
    width: dimensions.width,
    height: dimensions.height
  });
}

/* undo a previous change, if it exists */
function undo() {
  if (undoPositions.length > 0) {
    var pos = undoPositions.pop();
    var win = pos.win;
    remember(win, redoPositions);
    win.setFrame({
      x: pos.x,
      y: pos.y,
      width: pos.width,
      height: pos.height
    });
  }
}

/* redo a previously undone change, if it exists */
function redo() {
  if (redoPositions.length > 0) {
    var pos = redoPositions.pop();
    var win = pos.win;
    remember(win, undoPositions);
    win.setFrame({
      x: pos.x,
      y: pos.y,
      width: pos.width,
      height: pos.height
    });
  }
}

function fullScreen() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  setFrameAndRemember(win, {
    x: sframe.x,
    y: sframe.y,
    width: sframe.width,
    height: sframe.height
  });
}

function center() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  var wframe = win.frame();
  var originX = sframe.x + ((sframe.width - wframe.width) / 2);
  var originY = sframe.y + ((sframe.height - wframe.height) / 2);
  setFrameAndRemember(win, {
    x: originX,
    y: originY,
    width: wframe.width,
    height: wframe.height
  });
}

function mostlyFullScreen() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  setFrameAndRemember(win, {
    x: sframe.x + 40,
    y: sframe.y + 40,
    width: sframe.width - 80,
    height: sframe.height - 80
  });
}

function moderatelySized() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  setFrameAndRemember(win, {
    x: sframe.x + 150,
    y: sframe.y + 50,
    width: sframe.width - 300,
    height: sframe.height - 100
  });
}

function halfSize() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  var wframe = win.frame();
  var originY = sframe.y + (sframe.height - (wframe.height / 2)) / 2;
  setFrameAndRemember(win, {
    x: wframe.x,
    y: originY,
    width: wframe.width / 2,
    height: wframe.height / 2
  });
}

function leftHalf() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  var width =
  setFrameAndRemember(win, {
    x: sframe.x,
    y: sframe.y,
    width: sframe.width / 2 - border,
    height: sframe.height
  });
}

function rightHalf() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  setFrameAndRemember(win, {
    x: sframe.width / 2 + border,
    y: sframe.y,
    width: sframe.width / 2,
    height: sframe.height
  });
}

function topHalf() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  setFrameAndRemember(win, {
    x: sframe.x,
    y: sframe.y,
    width: sframe.width,
    // 18 seems to correct issues with the height because of the given frame?
    height: sframe.height / 2 - 18
  });
}

function bottomHalf() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  setFrameAndRemember(win, {
    x: sframe.x,
    y: sframe.height / 2,
    width: sframe.width,
    height: sframe.height / 2 - border
  });
}

function topLeft() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  setFrameAndRemember(win, {
    x: sframe.x,
    y: sframe.y,
    width: sframe.width / 2 - border,
    height: sframe.height / 2 - border
  });
}

function leftEdge() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  var wframe = win.frame();
  setFrameAndRemember(win, {
    x: sframe.x + 10,
    y: sframe.y + ((sframe.height - wframe.height) / 2),
    width: wframe.width,
    height: wframe.height,
  });
}

function rightEdge() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  var wframe = win.frame();
  setFrameAndRemember(win, {
    x: sframe.x + sframe.width - wframe.width - 10,
    y: sframe.y + ((sframe.height - wframe.height) / 2),
    width: wframe.width,
    height: wframe.height,
  });
}

function bottomLeft() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  setFrameAndRemember(win, {
    x: sframe.x,
    y: sframe.y + sframe.height / 2 + border,
    width: sframe.width / 2 - border,
    height: sframe.height / 2 - border
  });
}

function topRight() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  setFrameAndRemember(win, {
    x: sframe.x + sframe.width / 2 + border,
    y: sframe.y,
    width: sframe.width / 2 - border,
    height: sframe.height / 2 - border
  });
}

function bottomRight() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  setFrameAndRemember(win, {
    x: sframe.x + sframe.width / 2 + border,
    y: sframe.y + sframe.height / 2,
    width: sframe.width / 2 - border,
    height: sframe.height / 2 - border
  });
}

function resize(w, h) {
  var win = Window.focusedWindow();
  var wframe = win.frame();
  var wPercent = wframe.width * (w / 100);
  var hPercent = wframe.height * (h / 100);
  setFrameAndRemember(win, {
    x: wframe.x,
    y: wframe.y,
    width: wframe.width + wPercent,
    height: wframe.height + hPercent
  });
}

function nudge(x, y) {
  var win = Window.focusedWindow();
  var wframe = win.frame();
  var xPercent = wframe.width * (x / 100);
  var yPercent = wframe.height * (y / 100);
  setFrameAndRemember(win, {
    x: wframe.x + xPercent,
    y: wframe.y + yPercent,
    width: wframe.width,
    height: wframe.height
  });
}

function moveToScreenKeepingRatio(win, screen) {
  if (!screen) {
    return;
  }

  var frame = win.frame();
  var oldScreenRect = win.screen().frameWithoutDockOrMenu();
  var newScreenRect = screen.frameWithoutDockOrMenu();

  var xRatio = newScreenRect.width / oldScreenRect.width;
  var yRatio = newScreenRect.height / oldScreenRect.height;

  setFrameAndRemember(win, {
    x: (Math.round(frame.x - oldScreenRect.x) * xRatio) + newScreenRect.x,
    y: (Math.round(frame.y - oldScreenRect.y) * yRatio) + newScreenRect.y,
    width: Math.round(frame.width * xRatio),
    height: Math.round(frame.height * yRatio)
  });
}

function moveToScreenKeepingSize(win, screen) {
  if (!screen) {
    return;
  }

  var frame = win.frame();
  var oldScreenRect = win.screen().frameWithoutDockOrMenu();
  var newScreenRect = screen.frameWithoutDockOrMenu();

  var xRatio = newScreenRect.width / oldScreenRect.width;
  var yRatio = newScreenRect.height / oldScreenRect.height;

  var width = Math.min(frame.width, newScreenRect.width - 10);
  var height = Math.min(frame.height, newScreenRect.height - 10);

  var xBase = (Math.round(frame.x - oldScreenRect.x) * xRatio);
  var yBase = (Math.round(frame.y - oldScreenRect.y) * yRatio);

  if ((xBase + width) > newScreenRect.width) {
    xBase = Math.max(0, (newScreenRect.width - width - 20));
  }

  if ((yBase + height) > newScreenRect.height) {
    yBase = Math.max(0, (newScreenRect.height - height - 20));
  }

  setFrameAndRemember(win, {
    x: xBase + newScreenRect.x,
    y: yBase + newScreenRect.y,
    width: width,
    height: height,
  });
}

function circularLookup(array, index) {
  if (index < 0)
    return array[array.length + (index % array.length)];
  return array[index % array.length];
}

function rotateMonitors(offset) {
  var win = Window.focusedWindow();
  var currentScreen = win.screen();
  var screens = [currentScreen];
  for (var x = currentScreen.previousScreen(); x != win.screen(); x = x.previousScreen()) {
    screens.push(x);
  }

  screens = _(screens).sortBy(function(s) { return s.frameWithoutDockOrMenu().x; });
  var currentIndex = _(screens).indexOf(currentScreen);
  moveToScreenKeepingSize(win, circularLookup(screens, currentIndex + offset));
  win.focusWindow();
}

function leftOneMonitor() {
  rotateMonitors(-1);
}

function rightOneMonitor() {
  rotateMonitors(1);
}

function atLeft() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  var wframe = win.frame();
  return wframe.x <= (sframe.x + 10);
}

function atRight() {
  var win = Window.focusedWindow();
  var sframe = win.screen().frameWithoutDockOrMenu();
  var wframe = win.frame();
  return (wframe.x + wframe.width) >= (sframe.x + sframe.width - 10);
}

// resizing modifiers
api.bind('z', cmd_alt, function() { undo() });
api.bind('y', cmd_alt, function() { redo() });
api.bind('c', cmd_alt, function() { center() });
api.bind('f', cmd_alt_ctrl, function() { fullScreen() });
api.bind('m', cmd_alt, function() { moderatelySized() });
api.bind('t', cmd_alt, function() { halfSize() });
api.bind('s', cmd_alt, function() { mostlyFullScreen() });
api.bind('UP', cmd_alt, function() { resize(0, -5) });
api.bind('DOWN', cmd_alt, function() { resize(0, 5) });
api.bind('LEFT', cmd_alt, function() { resize(-5, 0) });
api.bind('RIGHT', cmd_alt, function() { resize(5, 0) });
api.bind('h', cmd_alt_ctrl, function() { leftHalf() });
api.bind('l', cmd_alt_ctrl, function() { rightHalf() });

// movement modifiers
api.bind('UP', cmd_alt_ctrl, function() { nudge(0,-5) });
api.bind('DOWN', cmd_alt_ctrl, function() { nudge(0,5) });
api.bind('LEFT', cmd_alt_ctrl, function() { nudge(-5,0) });
api.bind('RIGHT', cmd_alt_ctrl, function() { nudge(5,0) });

api.bind('h', cmd_alt, function() {
  if (atLeft()) {
    leftOneMonitor();
  }
  else {
    leftEdge();
  }
});
api.bind('l', cmd_alt, function() {
  if (atRight()) {
    rightOneMonitor();
  }
  else {
    rightEdge();
  }
});


// launcher
api.bind('t', cmd_alt_ctrl, function() { api.launch('iterm'); });
api.bind('g', cmd_alt_ctrl, function() { api.launch('google chrome'); });
api.bind('i', cmd_alt_ctrl, function() { api.launch('itunes'); });
api.bind('a', cmd_alt_ctrl, function() { api.launch('adium'); });
api.bind('r', cmd_alt_ctrl, function() { api.launch('readkit'); });
api.bind('p', cmd_alt_ctrl, function() { api.launch('system preferences'); });
