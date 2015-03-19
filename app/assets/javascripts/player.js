var Bounds = function (x1, y1, x2, y2) {
	this.x1 = x1;
	this.y1 = y1;
	this.x2 = x2;
	this.y2 = y2;

	this.toArray = function () {
		return [x1, y1, x2, y2];
	}
}

var ProgressBarManager = new function () {
	this.bar = null;
	this.bounds = new Bounds(0, 0, 0, 0);
	this.container = null;
	this.handler = null;
	var value = 0;
	var size = 100;

	this.init = function (container, bar, handler) {
		this.bar = bar;
		this.container = container;
		this.handler = handler;

		this.recalcBounds();

		// Make the handler draggable.
		this.handler.draggable({
			axis: 'x',
			containment: [
				this.bounds.x1,
				this.bounds.y1,
				this.bounds.x2,
				this.bounds.y2
			],
			drag: function (event, ui) {
				var left = handler.position().left - container.position().left + (handler.width() / 2);
				var width = container.width();

				value = left / width * size;

				bar.css('width', value + '%');
				bar.attr('aria-valuenow', value);
			}
		});

		this.container.click(function (e) {
			var value = (e.pageX - container.position().left) / container.width() * size;
			ProgressBarManager.setValue(value);
		});
	}

	this.recalcBounds = function () {
		var startX = this.container.position().left - (this.handler.width() / 2);
		var endX = startX + this.container.width();
		var startY = this.container.position().top; - (this.handler.height() / 4);

		this.bounds.x1 = startX;
		this.bounds.y1 = startY;
		this.bounds.x2 = endX;
		this.bounds.y2 = startY;
	}

	this.setValue = function (val) {
		this.value = val;

		this.bar.css('width', this.value + '%');
		this.bar.attr('aria-valuenow', this.value);

		var left = this.container.position().left + this.bar.width();
		this.handler.css({
			left: left - (this.handler.width() / 2),
			top: this.container.position().top - (this.handler.height() / 4)
		});
	}

	this.updateHandler = function () {
		var left = this.container.position().left + this.bar.width();
		this.handler.css({
			left: left - (this.handler.width() / 2),
			top: this.container.position().top - (this.handler.height() / 4)
		});
		this.handler.draggable(
			"option",
			"containment", [
				this.bounds.x1,
				this.bounds.y1,
				this.bounds.x2,
				this.bounds.y2
		]);
	}
};


ProgressBarManager.init(
	$('#ma-player-progressbar'),
	$('#ma-player-progressbar-bar'),
	$('#ma-player-progressbar-handler')
);


$(window).resize(function () {
	ProgressBarManager.recalcBounds();
	ProgressBarManager.updateHandler();
});

$(document).ready(function () {
	ProgressBarManager.recalcBounds();
	ProgressBarManager.updateHandler();
});
