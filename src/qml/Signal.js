.pragma library

function Signal() {
	this.fn = [];
	this._onConnect = null;
}

Signal.prototype.connect = function(fn, context) {
	this.fn.push( {fn: fn, context: context} );
	if (this._onConnect) {
		//Create a new signal the callback function can use
		var s = new Signal();
		s.connect(fn, context);
		this._onConnect(s);
	}
}

Signal.prototype.emit = function() {
	for(var i = 0; i < this.fn.length; ++i) {
		this.fn[i].fn.apply(this.fn[i].context, arguments);
	}
}

Signal.prototype.onConnect = function(fn) {
	this._onConnect = fn;
}
