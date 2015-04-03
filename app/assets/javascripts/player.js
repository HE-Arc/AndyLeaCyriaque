//= require utils
//= require musics
//= require playlists

/**
 * Player object
 * Manages the player's interface.
 */
var Player = new function() {

    //
    // Variables
    //

    this.audio = '';
    this.buttonSidebarPlaylists = '#ma-player-sidebar-menu-playlists';
    this.buttonSidebarSongs = '#ma-player-sidebar-menu-songs';
    this.buttonSidebarUpload = '#ma-player-sidebar-menu-upload';
    this.content = '#ma-player-content';

    //
    // Methods
    //

    /**
     * Connect a function to an element's event.
     * @param  {string}   object   HTML element's ID
     * @param  {string}   event    Event (eg. click)
     * @param  {function} callback Callback function
     */
    this.connect = function(object, event, callback) {
        $(object).on(event, callback);
    }

    /**
     * Initialization
     */
    this.initialize = function() {
        this.connect(this.buttonSidebarPlaylists, 'click', Playlists.index);
        this.connect(this.buttonSidebarSongs, 'click', Musics.index);
        this.connect(this.buttonSidebarUpload, 'click', Musics.new);

        this.audio = new Audio();

    }

    /**
     * Load a route and show it in the content container.
     * @param  {string} path           Route
     * @param  {function} callbackOnDone Function called when the request is done.
     */
    this.load = function(path, callbackOnDone) {
        $.ajax({
                url: path,
                beforeSend: function(xhr) {
                    xhr.overrideMimeType("text/plain; charset=x-user-defined");
                }
            })
            .done(function(data) {
                $(Player.content).html(data);
                if (typeof callbackOnDone !== 'undefined')
                    callbackOnDone();
            });
    }

    this.play = function(id) {
        $.ajax({
                url: 'music/' + id,
                dataType: 'json',
                beforeSend: function(xhr) {
                    xhr.overrideMimeType("text/plain; charset=x-user-defined");
                }
            })
            .done(function(data) {
                Player.audio.src = data.path;
                Player.audio.oncanplay = function() {
                    alert("Can start playing video");
                };
                Player.audio.play();
                $('#ma-player-sidebar-music-title').html(data.infos.title);
                $('#ma-player-sidebar-music-artist').html(data.infos.artist);
            });
    }

}

/**
 * ProgressBar manager
 */
var ProgressBarManager = new function() {

    //
    // Variables
    //

    this.bar = $('#ma-player-progressbar-bar');
    this.container = $('#ma-player-progressbar');
    this.handler = $('#ma-player-progressbar-handler');

    this.bounds = new Bounds(0, 0, 0, 0);

    var value = 0;
    var size = 100;

    //
    // Methods
    //

    /**
     * Initialization
     */
    this.initialize = function() {

        var bar = ProgressBarManager.bar;
        var container = ProgressBarManager.container;
        var handler = ProgressBarManager.handler;

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
            drag: function(event, ui) {
                var left = handler.position().left - container.position().left + (handler.width() / 2);
                var width = container.width();

                value = left / width * size;

                bar.css('width', value + '%');
                bar.attr('aria-valuenow', value);
            }
        });

        this.container.click(function(e) {
            var value = (e.pageX - container.position().left) / container.width() * size;
            ProgressBarManager.setValue(value);
        });
    }

    /**
     * Recompute the progress bar's boundaries.
     */
    this.recalcBounds = function() {
        var startX = this.container.position().left - (this.handler.width() / 2);
        var endX = startX + this.container.width();
        var startY = this.container.position().top; - (this.handler.height() / 4);

        this.bounds.x1 = startX;
        this.bounds.y1 = startY;
        this.bounds.x2 = endX;
        this.bounds.y2 = startY;
    }

    /**
     * Change the progress bar's value.
     * @param {float} val Value from 0 to 100
     */
    this.setValue = function(val) {
        this.value = val;

        this.bar.css('width', this.value + '%');
        this.bar.attr('aria-valuenow', this.value);

        var left = this.container.position().left + this.bar.width();
        this.handler.css({
            left: left - (this.handler.width() / 2),
            top: this.container.position().top - (this.handler.height() / 4)
        });
    }

    /**
     * Update handler's position.
     */
    this.updateHandler = function() {
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


//
// Window / Document section
//

$(window).resize(function() {
    ProgressBarManager.recalcBounds();
    ProgressBarManager.updateHandler();
});

$(document).ready(function() {
    ProgressBarManager.initialize();
    ProgressBarManager.recalcBounds();
    ProgressBarManager.updateHandler();

    ProgressBarManager.initialize();
    Player.initialize();
});
