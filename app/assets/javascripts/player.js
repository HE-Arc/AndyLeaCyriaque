/*$( window ).resize(function() {
	var cw = $('#ma-player-play').width();
	$('#ma-player-play').css({'height':cw+'px'});
});*/


var progressBarStartX = $('#ma-player-progressbar').position().left - 10;
var progressBarEndX = progressBarStartX + $('#ma-player-progressbar').width();
var progressBarY = $('#ma-player-progressbar').position().top - 3;
console.log(progressBarStartX + " - " + progressBarEndX);

$('#test').draggable({
	axis: 'x',
	containment: [progressBarStartX, progressBarY, progressBarEndX, progressBarY],
	drag: function (event, ui) {
		console.log($('#test').position().left);
		var left = $('#test').position().left - $('#ma-player-progressbar').position().left + 10;
		var width = $('#ma-player-progressbar').width();

		var value = left / width * 100;
		value = value.toFixed(2);

		var progressBar = $('#ma-player-progressbar-progress');
		progressBar.css('width', value + '%');
		progressBar.attr('aria-valuenow', value);
	}
});

$(window).resize(function () {

	progressBarStartX = $('#ma-player-progressbar').position().left - 10;
	progressBarEndX = progressBarStartX + $('#ma-player-progressbar').width();
	progressBarY = $('#ma-player-progressbar').position().top - 3;

	$('#test').css({
		left: progressBarStartX  + $('#ma-player-progressbar-progress').width(),
		top: progressBarY
	});

	console.log( $('#ma-player-progressbar-progress').width() );
	$('#test').draggable("option", "containment", [progressBarStartX, progressBarY, progressBarEndX, progressBarY + 10]);
});
